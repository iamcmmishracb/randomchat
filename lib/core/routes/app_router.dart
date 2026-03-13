import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/matching/screens/matching_screen.dart';
import '../../features/chat/screens/chat_screen.dart';
import '../../features/post_chat/screens/post_chat_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/info/screens/about_screen.dart';

class AppRoutes {
  static const String home               = '/';
  static const String matching           = '/matching';
  static const String postChat           = '/session/end';
  static const String dashboard          = '/dashboard';
  static const String settings           = '/settings';
  static const String aboutUs            = '/about';
  static const String privacyPolicy      = '/privacy';
  static const String termsOfUse         = '/terms-of-use';
  static const String termsConditions    = '/terms-conditions';
  static const String faq                = '/faq';
  static const String blog               = '/blog';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(path: AppRoutes.home,      builder: (_, __) => const HomeScreen()),
    GoRoute(path: AppRoutes.matching,  builder: (_, __) => const MatchingScreen()),
    GoRoute(
      path: '/chat/:sessionId',
      builder: (_, state) {
        final sessionId = state.pathParameters['sessionId'] ?? '';
        final extra = state.extra as Map<String, dynamic>?;
        return ChatScreen(
          sessionId: sessionId,
          partnerName: extra?['partnerName'] ?? 'Stranger',
          partnerGender: extra?['partnerGender'],
        );
      },
    ),
    GoRoute(
      path: AppRoutes.postChat,
      builder: (_, state) => PostChatScreen(sessionData: state.extra as Map<String, dynamic>?),
    ),
    GoRoute(path: AppRoutes.dashboard,        builder: (_, __) => const DashboardScreen()),
    GoRoute(path: AppRoutes.settings,         builder: (_, __) => const SettingsScreen()),
    GoRoute(path: AppRoutes.aboutUs,          builder: (_, __) => const AboutScreen()),
    GoRoute(path: AppRoutes.privacyPolicy,    builder: (_, __) => const PrivacyPolicyScreen()),
    GoRoute(path: AppRoutes.termsOfUse,       builder: (_, __) => const TermsOfUseScreen()),
    GoRoute(path: AppRoutes.termsConditions,  builder: (_, __) => const TermsAndConditionsScreen()),
    GoRoute(path: AppRoutes.faq,              builder: (_, __) => const FAQScreen()),
    GoRoute(path: AppRoutes.blog,             builder: (_, __) => const BlogScreen()),
  ],
  errorBuilder: (_, state) => Scaffold(
    body: Center(child: Text('Page not found: ${state.error}')),
  ),
);
