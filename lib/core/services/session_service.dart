import 'dart:async';
import 'package:uuid/uuid.dart';
import 'app_config.dart';
import 'api_service.dart';
import 'websocket_service.dart';
import 'device_info_service.dart';
import '../constants/app_constants.dart';
import '../models/user_model.dart';

/// 🎯 Session Service - Device-Based Anonymous Sessions

class SessionService {
  static final SessionService _instance = SessionService._internal();
  factory SessionService() => _instance;
  SessionService._internal();

  final _apiService       = ApiService();
  final _webSocketService = WebSocketService();

  UserModel?       _currentUser;
  ChatSessionModel? _currentSession;
  DeviceSession?   _deviceSession;
  final List<MessageModel> _messages = [];
  bool _botActive           = false;
  bool _chatEnabled         = true;
  int  _botConversationStep = 0;

  // ── Session stat tracking (Gaps 2, 3, 4) ─────────────────────────────
  DateTime? _sessionStartTime;
  int       _sentMessageCount = 0;   // outgoing messages only (server counts both sides)

  Completer<ChatSessionModel>? _matchCompleter;
  Completer<void>? _authCompleter;

  final _messageController = StreamController<MessageModel>.broadcast();
  final _typingController  = StreamController<bool>.broadcast();
  final _sessionController = StreamController<ChatSessionModel?>.broadcast();

  Stream<MessageModel>    get messageStream => _messageController.stream;
  Stream<bool>            get typingStream  => _typingController.stream;
  Stream<ChatSessionModel?> get sessionStream => _sessionController.stream;

  UserModel?       get currentUser    => _currentUser;
  ChatSessionModel? get currentSession => _currentSession;
  List<MessageModel> get messages     => List.unmodifiable(_messages);
  bool get isBotSession  => _botActive;
  bool get isChatEnabled => _chatEnabled;

  static const _maleNames   = ['Alex', 'Jordan', 'Chris', 'Taylor', 'Casey'];
  static const _femaleNames = ['Emma', 'Sofia', 'Mia', 'Luna', 'Aria'];
  static const _interests   = ['music', 'travel', 'gaming', 'photography'];
  static const _questions   = [
    'What do you do for fun?',
    'Where are you from?',
    'What kind of music do you like?',
  ];

  void setCurrentUser(UserModel user) => _currentUser = user;

  /// 🚀 Main entry point - Create session and start matching
  Future<ChatSessionModel> startMatching() async {
    _print('🚀 Starting device-based matching...');
    _chatEnabled      = true;
    _sessionStartTime = null;
    _sentMessageCount = 0;

    try {
      // Step 1: Collect Device Info
      _print('📱 Collecting device information...');
      final deviceInfo = await DeviceInfoService().getDeviceInfo();
      _print('✅ Device info collected');

      // Step 2: Create Anonymous Session (also creates User in MongoDB)
      _print('🌐 Creating anonymous session...');
      _deviceSession = await _apiService.createAnonymousSession(
        displayName: _currentUser?.displayName ?? 'Anonymous',
        gender: (_currentUser?.gender.displayName ?? 'other').toLowerCase(),
        deviceInfo: deviceInfo,
        consentGiven: true,       // User accepted terms on HomeScreen before calling startMatching()
        ageConfirmed: true,       // User confirmed 18+ on HomeScreen
        consentTimestamp: DateTime.now(),
      );
      _print('✅ Session created: ${_deviceSession!.sessionId}  userId: ${_deviceSession!.userId}');

      // Step 3: Connect WebSocket (sends appKey + token in first message)
      _print('🔌 Connecting to WebSocket...');
      await _webSocketService.connect(
        AppConfig.wsUrl,
        _deviceSession!.sessionToken,
      );
      _print('✅ WebSocket connected');

      // Step 4: Setup listeners
      _setupWebSocketListeners();

      // Step 5: Wait for match_found
      _matchCompleter = Completer<ChatSessionModel>();

      // Step 6: Wait for server to confirm authentication FIRST,
      // then send find_match. This is critical - if we send find_match
      // before authenticated arrives, the server hasn't set up its
      // message listener yet and will never see the find_match event.
      _print('🔍 Waiting for auth confirmation then searching...');
      _authCompleter = Completer<void>();
      await _authCompleter!.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Auth confirmation timeout'),
      );
      _webSocketService.emit('find_match', {});
      _print('📤 find_match sent after auth confirmed');

      // Step 7: Wait indefinitely for a real match
      _print('⏳ Waiting for real match...');
      final matchedSession = await _matchCompleter!.future;
      _print('✅ Match received!');
      return matchedSession;

    } on ApiException catch (e) {
      _print('⚠️ Backend unavailable: ${e.message}');
      _print('🤖 Falling back to demo bot...');
      return _createDemoSession();
    } catch (e) {
      _print('❌ Error: $e');
      _print('🤖 Falling back to demo bot...');
      return _createDemoSession();
    }
  }

  void _setupWebSocketListeners() {
    _webSocketService.on('authenticated', (data) {
      _print('✅ WebSocket authenticated by server');
      // Signal that auth is confirmed - now safe to send find_match
      if (_authCompleter != null && !_authCompleter!.isCompleted) {
        _authCompleter!.complete();
      }
    });

    _webSocketService.on('match_found', (data) {
      _print('✅ MATCH FOUND!');
      _handleMatchFound(data);
      if (_matchCompleter != null && !_matchCompleter!.isCompleted) {
        _matchCompleter!.complete(_currentSession);
      }
    });

    _webSocketService.on('waiting_for_match', (data) {
      _print('⏳ In waiting queue...');
    });

    _webSocketService.on('new_message', (data) {
      _print('💬 Message received');
      _handleNewMessage(data);
    });

    _webSocketService.on('partner_typing', (data) {
      _typingController.add(data['isTyping'] ?? false);
    });

    _webSocketService.on('chat_ended', (data) {
      _print('🏁 Chat ended: ${data['reason']}');
      _chatEnabled = false;
    });
  }

  void _handleMatchFound(Map<String, dynamic> data) {
    if (data['sessionId'] == null) {
      _print('❌ Invalid match data: no sessionId');
      return;
    }
    _currentSession = ChatSessionModel(
      sessionId:     data['sessionId'],
      user1Id:       _currentUser?.userId ?? 'device-1',
      user2Id:       'device-2',
      isBotSession:  false,
      startedAt:     DateTime.now(),
      partnerName:   data['partnerName'] ?? 'User',
      partnerGender: _parseGender(data['partnerGender']),
    );
    _messages.clear();
    _chatEnabled      = true;
    _sessionStartTime = DateTime.now();
    _sentMessageCount = 0;
    _sessionController.add(_currentSession);
    _print('🎉 Session started: ${_currentSession!.sessionId}');
  }

  void _handleNewMessage(Map<String, dynamic> data) {
    final msg = MessageModel(
      messageId: data['tempId'] ?? 'msg-${DateTime.now().millisecondsSinceEpoch}',
      sessionId: data['sessionId'],
      senderId:  'partner',
      content:   data['content'],
      sentAt:    DateTime.now(),
      status:    MessageStatus.delivered,
      isMe:      false,
    );
    _messages.add(msg);
    _messageController.add(msg);
  }

  MessageModel sendMessage(String content) {
    if (_currentSession == null || _currentUser == null) {
      throw Exception('No active session');
    }
    if (!_chatEnabled) throw Exception('Chat has ended');
    if (content.trim().isEmpty) throw Exception('Cannot send empty message');

    final message = MessageModel(
      messageId: const Uuid().v4(),
      sessionId: _currentSession!.sessionId,
      senderId:  _currentUser!.userId,
      content:   content,
      sentAt:    DateTime.now(),
      status:    MessageStatus.sent,
      isMe:      true,
    );
    _messages.add(message);
    _messageController.add(message);
    _sentMessageCount++; // track for stats (Gap 2)

    Future.delayed(const Duration(milliseconds: 600), () {
      final idx = _messages.indexWhere((m) => m.messageId == message.messageId);
      if (idx != -1) {
        _messages[idx] = message.copyWith(status: MessageStatus.delivered);
        _messageController.add(_messages[idx]);
      }
    });

    if (_webSocketService.isConnected && !isBotSession) {
      _webSocketService.emit('send_message', {'content': content});
      _print('📤 Message sent via WebSocket');
    } else if (isBotSession) {
      _scheduleBotReply();
    }

    return message;
  }

  void emitTyping(bool isTyping) {
    if (_currentSession != null && _webSocketService.isConnected && !isBotSession) {
      _webSocketService.emit('typing', {'isTyping': isTyping});
    }
  }

  /// 🚩 Flag a specific message (Gap 5)
  /// Marks the message locally and notifies the server so the backend
  /// can store isFlagged=true on that message document.
  void flagMessage(String messageId) {
    final idx = _messages.indexWhere((m) => m.messageId == messageId);
    if (idx == -1) return;
    final flagged = MessageModel(
      messageId:   _messages[idx].messageId,
      sessionId:   _messages[idx].sessionId,
      senderId:    _messages[idx].senderId,
      content:     _messages[idx].content,
      sentAt:      _messages[idx].sentAt,
      deliveredAt: _messages[idx].deliveredAt,
      readAt:      _messages[idx].readAt,
      status:      _messages[idx].status,
      isMe:        _messages[idx].isMe,
      isFlagged:   true,
    );
    _messages[idx] = flagged;
    _messageController.add(flagged);
    // Notify server so the message document is marked isFlagged (Gap 5)
    if (_webSocketService.isConnected && !isBotSession) {
      _webSocketService.emit('flag_message', {
        'messageId': messageId,
        'sessionId': _currentSession?.sessionId,
      });
    }
    _print('🚩 Message flagged: $messageId');
  }

  // ── Demo/bot fallback ──────────────────────────────────────────────────

  ChatSessionModel _createDemoSession() {
    _botActive           = true;
    _botConversationStep = 0;
    _chatEnabled         = true;

    final partnerGender = (DateTime.now().millisecond % 2) == 0 ? Gender.male : Gender.female;
    final partnerName   = partnerGender == Gender.male
        ? _maleNames[DateTime.now().second % _maleNames.length]
        : _femaleNames[DateTime.now().second % _femaleNames.length];

    _currentSession = ChatSessionModel(
      sessionId:     const Uuid().v4(),
      user1Id:       _currentUser?.userId ?? '',
      user2Id:       const Uuid().v4(),
      isBotSession:  true,
      startedAt:     DateTime.now(),
      partnerName:   partnerName,
      partnerGender: partnerGender,
    );
    _messages.clear();
    _sessionController.add(_currentSession);
    _sessionStartTime = DateTime.now();
    _sentMessageCount = 0;
    _print('🤖 Demo session started with $partnerName');
    _scheduleNextIntroMessage();
    return _currentSession!;
  }

  void _scheduleNextIntroMessage() {
    if (!_botActive || _currentSession == null) return;
    const delay = Duration(milliseconds: 1400);
    switch (_botConversationStep) {
      case 0:
        _delayedTypeThen('Hey! 👋 I\'m ${_currentSession!.partnerName}. Nice to meet you!', delay);
      case 1:
        _delayedTypeThen('I\'m ${_currentSession!.partnerGender?.displayName ?? 'Unknown'} 🙂', delay);
      case 2:
        _delayedTypeThen('I love ${_interests[DateTime.now().second % _interests.length]} ✨', delay);
      case 3:
        _delayedTypeThen('${_questions[DateTime.now().second % _questions.length]}', delay);
      default:
        break;
    }
  }

  void _scheduleBotReply() {
    if (!_botActive || _currentSession == null || _botConversationStep < 4) return;
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!_botActive || _currentSession == null) return;
      _typingController.add(true);
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (!_botActive || _currentSession == null) return;
        _typingController.add(false);
        final reactions = ['Oh nice! 😊', 'That\'s cool!', 'Tell me more!'];
        _receiveMessage(reactions[DateTime.now().second % reactions.length]);
      });
    });
  }

  void _delayedTypeThen(String text, Duration delay) {
    if (!_botActive || _currentSession == null) return;
    Future.delayed(delay, () {
      if (!_botActive || _currentSession == null) return;
      _typingController.add(true);
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!_botActive || _currentSession == null) return;
        _typingController.add(false);
        _receiveMessage(text);
        _botConversationStep++;
        if (_botConversationStep < 4) _scheduleNextIntroMessage();
      });
    });
  }

  void _receiveMessage(String content) {
    if (_currentSession == null) return;
    final msg = MessageModel(
      messageId: const Uuid().v4(),
      sessionId: _currentSession!.sessionId,
      senderId:  _currentSession!.user2Id,
      content:   content,
      sentAt:    DateTime.now(),
      status:    MessageStatus.delivered,
      isMe:      false,
    );
    _messages.add(msg);
    _messageController.add(msg);
  }

  // ── Lifecycle ──────────────────────────────────────────────────────────

  Future<void> disconnect() async {
    // ── Capture ALL stats BEFORE mutating any state ────────────────────────
    // Bug 1 fix: use the MATCH session ID (match-XXXX), not the login session
    // ID (_deviceSession.sessionId). The backend /end route updates the match
    // session document, not the login session document.
    final matchSessionId  = _currentSession?.sessionId;
    final durationSeconds = _sessionStartTime != null
        ? DateTime.now().difference(_sessionStartTime!).inSeconds
        : 0;
    final totalMessages   = _messages.length; // sent + received
    // Bug 2 fix: read isBotSession directly before _botActive is cleared.
    // Previous code set _botActive=false first, making the ternary always true.
    final wasBotSession   = _currentSession?.isBotSession ?? false;
    final hasFlagged      = _messages.any((m) => m.isFlagged);
    final sessionStatus   = hasFlagged ? 'flagged' : 'ended';

    _botActive      = false;
    _chatEnabled    = false;
    _currentSession = null;
    _sessionController.add(null);

    // Send stats only when we have a real match session ID to update
    if (_deviceSession != null && matchSessionId != null) {
      await _apiService.endSessionWithStats(
        sessionId:       matchSessionId,       // ← match session, not login session
        userId:          _deviceSession!.userId,
        messageCount:    totalMessages,
        durationSeconds: durationSeconds,
        isBotSession:    wasBotSession,
        status:          sessionStatus,
      );
    }

    _webSocketService.disconnect();
    _sessionStartTime = null;
    _sentMessageCount = 0;
    _print('🔌 Disconnected  msgs=$totalMessages  dur=${durationSeconds}s  bot=$wasBotSession');
  }

  Future<void> startNewChat() async {
    _print('🔄 Starting new chat session...');
    _botActive      = false;
    _chatEnabled    = true;
    _currentSession = null;
    _messages.clear();
    _sessionController.add(null);
    await startMatching();
  }

  void dispose() {
    _messageController.close();
    _typingController.close();
    _sessionController.close();
    _webSocketService.disconnect();
    _apiService.dispose();
  }

  Gender _parseGender(String? gender) => switch (gender?.toLowerCase()) {
    'male'   => Gender.male,
    'female' => Gender.female,
    _        => Gender.preferNotToSay,
  };

  void _print(String msg) {
    if (AppConfig.debugLogging) print('🎯 SessionService: $msg');
  }
}
