import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import '../constants/app_constants.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  WebSocketChannel? _channel;
  bool _connected = false;
  bool get isConnected => _connected;

  final Map<String, List<Function>> _listeners = {};

  /// Connect to WebSocket server with token.
  /// The FIRST message sent must include both appKey and token —
  /// the backend validates both before allowing any further communication.
  Future<void> connect(String url, [String? token]) async {
    try {
      print('🔌 Connecting to WebSocket: $url');

      String wsUrl = url.replaceFirst(RegExp(r'^https://'), 'wss://');
      wsUrl = wsUrl.replaceFirst(RegExp(r'^http://'), 'ws://');

      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      // ── Auth handshake: send appKey + token as the very first message ──
      // Backend (server.js) rejects the connection if either is missing/wrong.
      if (token != null) {
        print('🔐 Sending auth handshake (appKey + token)');
        _channel!.sink.add(jsonEncode({
          'appKey': AppConstants.appKey,  // ← NEW: required by backend
          'token':  token,
        }));
      }

      _channel!.stream.listen(
        _handleMessage,
        onError: (error) {
          print('❌ WebSocket Error: $error');
          _connected = false;
        },
        onDone: () {
          print('⚠️ WebSocket Disconnected');
          _connected = false;
        },
      );

      _connected = true;
      print('✅ WebSocket Connected');
    } catch (e) {
      print('❌ Failed to connect: $e');
      _connected = false;
      rethrow;
    }
  }

  void _handleMessage(dynamic message) {
    try {
      if (message is String) {
        final data = jsonDecode(message);
        final eventType = data['type'] as String?;
        if (eventType != null) {
          final handlers = _listeners[eventType] ?? [];
          for (final handler in handlers) {
            handler(data);
          }
        }
      }
    } catch (e) {
      print('❌ Error handling message: $e');
    }
  }

  void emit(String eventType, [dynamic data]) {
    if (!_connected || _channel == null) {
      print('❌ WebSocket not connected');
      return;
    }
    try {
      final Map<String, dynamic> message = {'type': eventType};
      if (data != null && data is Map) {
        data.forEach((key, value) => message[key] = value);
      }
      _channel!.sink.add(jsonEncode(message));
      print('📤 Sent: $eventType');
    } catch (e) {
      print('❌ Error emitting event: $e  ($eventType)');
    }
  }

  void on(String eventType, Function(dynamic) handler) {
    _listeners.putIfAbsent(eventType, () => []).add(handler);
    print('👂 Listening for: $eventType');
  }

  void off(String eventType, Function(dynamic) handler) {
    _listeners[eventType]?.remove(handler);
  }

  void clearListeners(String eventType) => _listeners.remove(eventType);

  void disconnect() {
    try {
      _channel?.sink.close();
      _connected = false;
      _listeners.clear();
      print('🔌 WebSocket Disconnected');
    } catch (e) {
      print('❌ Error disconnecting: $e');
    }
  }
}
