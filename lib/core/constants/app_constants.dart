class AppConstants {
  // App Info
  static const String appName = 'Strangchatomy';
  static const String appTagline = 'Meet someone new, right now.';
  static const String appVersion = '1.0.0';

  // Timing
  static const int matchingTimeoutSeconds = 8;
  static const int botResponseMinMs = 1500;
  static const int botResponseMaxMs = 4000;
  static const int typingIndicatorDebounceMs = 1000;

  // Limits
  static const int messageMaxChars = 1000;
  static const int displayNameMaxChars = 50;
  static const int maxRetries = 3;

  // Storage Keys
  static const String keySessionToken = 'session_token';
  static const String keyUserId = 'user_id';
  static const String keyDisplayName = 'display_name';
  static const String keyGender = 'gender';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyAuthToken = 'auth_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyTheme = 'theme';

  // ===== LOCAL DEVELOPMENT URLs =====
  // Change these to your backend IP address: 192.168.1.3
  static const String baseUrl = 'http://localhost:3000';
  static const String wsUrl = 'ws://localhost:3000';

  // ===== PRODUCTION URLs (uncomment when deploying) =====
  // static const String baseUrl = 'https://api.strangchatomy.app';
  // static const String wsUrl = 'wss://ws.strangchatomy.app';

  // ── SECURITY: App Key ───────────────────────────────────────────────────
  // Must match APP_SECRET in your backend .env file.
  // Every HTTP request to /api/sessions/* and every WebSocket connection
  // must include this value. Keep it secret — do not commit the real value.
  static const String appKey = 'rc_app_secret_change_this_in_production_719ef8e35a7dbb6ecf85d8d8';

  // Feature Flags
  static const bool enableBotFallback = true;
  static const bool enablePushNotifications = true;

  // Matching
  static const int botPoolSize = 200;
  static const int maxSessionsBeforeCaptcha = 5;
  static const int captchaWindowMinutes = 10;

  // Retention
  static const int defaultRetentionDays = 30;
}

enum Gender { male, female, preferNotToSay }

enum AccountType { anonymous, registered }


enum SessionStatus { active, ended, flagged }

enum MessageStatus { sent, delivered, read }

extension GenderExtension on Gender {
  String get displayName {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.preferNotToSay:
        return 'Prefer Not to Say';
    }
  }

  String get emoji {
    switch (this) {
      case Gender.male:
        return '👨';
      case Gender.female:
        return '👩';
      case Gender.preferNotToSay:
        return '🧑';
    }
  }
}
