import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'app_config.dart';
import 'device_info_service.dart';

/// 🌐 API Service - Device-Based Anonymous Sessions

class DeviceSession {
  final String sessionId;
  final String userId;       // ← NEW: MongoDB User _id returned by backend
  final String sessionToken;
  final int expiresIn;
  final String displayName;
  final String gender;

  DeviceSession({
    required this.sessionId,
    required this.userId,
    required this.sessionToken,
    required this.expiresIn,
    required this.displayName,
    required this.gender,
  });

  factory DeviceSession.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return DeviceSession(
      sessionId:    data['sessionId'],
      userId:       data['userId'],       // ← NEW
      sessionToken: data['sessionToken'],
      expiresIn:    data['expiresIn'],
      displayName:  data['displayName'],
      gender:       data['gender'],
    );
  }
}

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final http.Client _client = http.Client();
  String? _sessionToken;

  void setSessionToken(String token) => _sessionToken = token;
  String? getSessionToken() => _sessionToken;
  void clearSessionToken() => _sessionToken = null;

  // ── Headers: X-App-Key on every request ───────────────────────────────
  // AppConfig.baseHeaders already includes Content-Type + X-App-Key.
  // We add Authorization on top when we have a session token.
  Map<String, String> get _headers {
    final headers = Map<String, String>.from(AppConfig.baseHeaders);
    if (_sessionToken != null) {
      headers['Authorization'] = 'Bearer $_sessionToken';
    }
    return headers;
  }

  /// 📱 Create Anonymous Session
  /// NOTE: IMEI removed — collecting IMEI violates Google Play policy.
  Future<DeviceSession> createAnonymousSession({
    required String displayName,
    required String gender,
    required DeviceInfo deviceInfo,
  }) async {
    try {
      _log('🎯 Creating anonymous session for: $displayName');

      final response = await _post(
        AppConfig.createSessionUrl,
        body: {
          'deviceId':           deviceInfo.deviceId,
          'displayName':        displayName,
          'gender':             gender,
          'deviceModel':        deviceInfo.deviceModel,
          'deviceManufacturer': deviceInfo.deviceManufacturer,
          // ← imei removed (Play Store violation)
          'location': deviceInfo.latitude != null
              ? {
                  'latitude':  deviceInfo.latitude,
                  'longitude': deviceInfo.longitude,
                  'accuracy':  deviceInfo.accuracy,
                }
              : null,
        },
      );

      if (response is Map && response['success'] == true) {
        final session = DeviceSession.fromJson(response as Map<String, dynamic>);
        setSessionToken(session.sessionToken);
        _log('✅ Session created: ${session.sessionId}  userId: ${session.userId}');
        return session;
      }

      throw ApiException('Failed to create session');
    } on TimeoutException {
      throw ApiException('Connection timeout - backend may be offline');
    } catch (e) {
      throw ApiException('Failed to create session: $e');
    }
  }

  /// ✅ Verify Session Token
  Future<bool> verifySession() async {
    try {
      if (_sessionToken == null) return false;
      final response = await _get(AppConfig.verifySessionUrl);
      if (response is Map && response['success'] == true) {
        _log('✅ Session verified');
        return true;
      }
      _log('❌ Session invalid or expired');
      return false;
    } catch (e) {
      _log('⚠️ Verification failed: $e');
      return false;
    }
  }

  /// 🏁 End Anonymous Session
  /// userId is now required so the backend can mark the user offline.
  Future<void> endSession(String sessionId, String userId) async {
    try {
      _log('🏁 Ending session: $sessionId');
      final response = await _post(
        AppConfig.endSessionUrl,
        body: {
          'sessionId': sessionId,
          'userId':    userId,    // ← NEW: required by backend
        },
      );
      if (response is Map && response['success'] == true) {
        clearSessionToken();
        _log('✅ Session ended');
      }
    } catch (e) {
      _log('⚠️ Error ending session: $e');
    }
  }

  // ── Private HTTP helpers ───────────────────────────────────────────────

  Future<dynamic> _get(String url) async {
    try {
      _log('GET $url');
      final response = await _client
          .get(Uri.parse(url), headers: _headers)
          .timeout(const Duration(seconds: 10));
      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException('Request timeout');
    } catch (e) {
      throw ApiException('Connection failed: $e');
    }
  }

  Future<dynamic> _post(String url, {Map<String, dynamic>? body}) async {
    try {
      _log('POST $url');
      final response = await _client
          .post(Uri.parse(url), headers: _headers, body: jsonEncode(body ?? {}))
          .timeout(const Duration(seconds: 10));
      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException('Request timeout');
    } catch (e) {
      throw ApiException('Connection failed: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    _log('Response: ${response.statusCode}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        return response.body;
      }
    } else if (response.statusCode == 401) {
      throw ApiException('Session expired or invalid');
    } else if (response.statusCode == 403) {
      throw ApiException('Access denied - invalid app key');
    } else if (response.statusCode == 404) {
      throw ApiException('Endpoint not found');
    } else {
      try {
        final error = jsonDecode(response.body);
        throw ApiException(error['message'] ?? 'Server error');
      } catch (_) {
        throw ApiException('Server error: ${response.statusCode}');
      }
    }
  }

  void _log(String message) {
    if (AppConfig.debugLogging) print('📡 ApiService: $message');
  }

  void dispose() => _client.close();
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}
