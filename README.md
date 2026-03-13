# RandomChat — Flutter App (Android & Web)

> Anonymous Real-Time Chat Platform | Flutter 3.13+ | Dart 3.1+

---

## Project Overview

RandomChat is a cross-platform Flutter application targeting **Android** and **Web (PWA)**, built from the RandomChat PRD v1.0. This codebase covers the full user-facing app. The Admin Panel is a separate project.

---

## Architecture

```
lib/
├── main.dart                    # Entry point
├── app.dart                     # MaterialApp + Router config
├── core/
│   ├── theme/
│   │   └── app_theme.dart       # Dark theme, colors, typography
│   ├── constants/
│   │   └── app_constants.dart   # App-wide constants, enums
│   ├── models/
│   │   └── user_model.dart      # Data models (User, Message, Session, Call)
│   ├── routes/
│   │   └── app_router.dart      # GoRouter navigation config
│   ├── services/
│   │   └── session_service.dart # Mock session/chat/call service
│   └── utils/
│       └── app_utils.dart       # Utilities, shared widgets
└── features/
    ├── home/screens/
    │   └── home_screen.dart          # Landing screen (name, gender, Start Chat)
    ├── matching/screens/
    │   └── matching_screen.dart      # Animated matching loader
    ├── chat/
    │   ├── screens/chat_screen.dart  # Chat room with real-time messages
    │   └── widgets/
    │       ├── message_bubble.dart   # Chat message UI
    │       └── chat_input_bar.dart   # Message input with emoji/attach
    ├── call/
    │   ├── screens/
    │   │   ├── audio_call_screen.dart # Audio call with waveform animation
    │   │   └── video_call_screen.dart # Video call with PiP
    │   └── widgets/
    │       └── incoming_call_modal.dart # Incoming call overlay with countdown
    ├── post_chat/screens/
    │   └── post_chat_screen.dart     # Session summary, rating, next actions
    ├── auth/screens/
    │   ├── login_screen.dart         # Email/Google/Apple sign in
    │   └── signup_screen.dart        # Registration with terms
    └── dashboard/screens/
        └── dashboard_screen.dart     # Profile, chat history, call history
```

---

## Screens Implemented

| Screen | Route | Status |
|--------|-------|--------|
| Landing / Home | `/` | ✅ Complete |
| Matching Loader | `/matching` | ✅ Complete |
| Chat Room | `/chat/:sessionId` | ✅ Complete |
| Incoming Call Modal | Overlay | ✅ Complete |
| Audio Call | `/call/audio/:sessionId` | ✅ Complete |
| Video Call | `/call/video/:sessionId` | ✅ Complete |
| Post-Chat Screen | `/session/end` | ✅ Complete |
| Sign In | `/login` | ✅ Complete |
| Sign Up | `/signup` | ✅ Complete |
| User Dashboard | `/dashboard` | ✅ Complete |

---

## Setup & Running

### Prerequisites
- Flutter SDK 3.13+
- Android Studio / Xcode
- Node.js (for backend WebSocket server)

### Install Dependencies
```bash
flutter pub get
```

### Run on Android
```bash
flutter run -d android
```

### Run on Web
```bash
flutter run -d chrome
# or for production build:
flutter build web --release
```

### Run on Android Emulator
```bash
flutter emulators --launch <emulator_id>
flutter run
```

---

## Design System

### Colors
| Token | Value | Usage |
|-------|-------|-------|
| `primary` | `#00D4C8` | Electric Teal — CTAs, accents |
| `accent` | `#FF5C7A` | Coral — destructive, attention |
| `background` | `#0A0E1A` | Deep navy — main background |
| `surface` | `#111827` | App bars, cards |
| `bubbleSent` | `#00C4B4` | Sent message bubbles |
| `bubbleReceived` | `#1E2A40` | Received message bubbles |

### Typography
- **Display/Headings**: Space Grotesk (bold, geometric)
- **Body/UI**: DM Sans (clean, readable)

---

## Backend Integration

The app currently uses a **mock `SessionService`** that simulates:
- Matching with random bot partners after 3s delay
- Bi-directional message flow with bot auto-replies
- Typing indicators
- Session state management

### To connect to your real backend:

1. **Replace `SessionService`** with a real WebSocket client:
   ```dart
   final socket = io('wss://ws.randomchat.app', OptionBuilder().setTransports(['websocket']).build());
   ```

2. **WebRTC** — integrate `flutter_webrtc` for real calls:
   ```dart
   final peerConnection = await createPeerConnection(configuration);
   ```

3. **Authentication** — add your API endpoints to `AuthService`

4. **Firebase** — add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)

---

## Key Dependencies

| Package | Purpose |
|---------|---------|
| `go_router` | Type-safe navigation |
| `provider` | State management |
| `socket_io_client` | WebSocket (real-time) |
| `flutter_webrtc` | Audio/Video calls |
| `google_fonts` | DM Sans + Space Grotesk |
| `emoji_picker_flutter` | In-chat emoji picker |
| `firebase_messaging` | Push notifications |
| `permission_handler` | Camera/mic permissions |
| `flutter_animate` | Advanced animations |
| `fl_chart` | Charts (for dashboard) |

---

## Android Configuration

- **Min SDK**: API 26 (Android 8.0)
- **Target SDK**: API 34
- **Permissions**: Camera, Microphone, Internet, Notifications
- **Push**: FCM + ConnectionService for call alerts
- **Deep Links**: App Links on `randomchat.app`

## Web Configuration

- **PWA**: Full manifest.json with standalone display
- **Install prompt**: Shown after first successful chat
- **Service Worker**: Offline landing page + asset caching
- **Push**: Web Push API

---

## Next Steps

1. **Backend**: Build Node.js/Go WebSocket server with Socket.IO
2. **WebRTC**: Configure STUN/TURN servers (Coturn or Twilio)
3. **Bot Engine**: Integrate GPT-4 or Gemini for bot responses
4. **Firebase**: Set up FCM for push notifications
5. **Authentication**: Implement real JWT auth flow
6. **Admin Panel**: Build Flutter Web admin dashboard

---

*RandomChat v1.0 — Flutter Frontend | PRD v1.0 March 2026*
