import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/utils/app_utils.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            else context.go(AppRoutes.home);
          },
        ),
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 8),

            // Profile card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppColors.primaryGradient),
                    child: const Icon(Icons.person_rounded, color: Colors.white, size: 36),
                  ),
                  const SizedBox(height: 14),
                  Text('Anonymous User', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Container(width: 7, height: 7, decoration: const BoxDecoration(color: AppColors.online, shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      Text('Online', style: Theme.of(context).textTheme.bodySmall),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => context.push(AppRoutes.settings),
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text('Edit Profile & Settings'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Privacy notice
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Row(children: [
                const Icon(Icons.lock_outline_rounded, color: AppColors.primary, size: 16),
                const SizedBox(width: 10),
                Expanded(child: Text(
                  'RandomChat is fully anonymous. Chat history is never saved — once you disconnect, the conversation is gone forever.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.5),
                )),
              ]),
            ),

            const SizedBox(height: 20),

            GradientButton(
              label: 'Start New Chat',
              onPressed: () => context.go(AppRoutes.matching),
              icon: const Icon(Icons.bolt_rounded, color: Colors.white, size: 20),
            ),

            const SizedBox(height: 28),

            _linkSection(context, 'Settings', [
              _Link(Icons.settings_outlined, 'App Settings', () => context.push(AppRoutes.settings)),
            ]),
            const SizedBox(height: 12),
            _linkSection(context, 'Info & Legal', [
              _Link(Icons.info_outline_rounded,   'About Us',            () => context.push(AppRoutes.aboutUs)),
              _Link(Icons.privacy_tip_outlined,   'Privacy Policy',      () => context.push(AppRoutes.privacyPolicy)),
              _Link(Icons.gavel_rounded,          'Terms of Use',        () => context.push(AppRoutes.termsOfUse)),
              _Link(Icons.description_outlined,   'Terms & Conditions',  () => context.push(AppRoutes.termsConditions)),
              _Link(Icons.quiz_outlined,          'FAQs',                () => context.push(AppRoutes.faq)),
              _Link(Icons.article_outlined,       'Blog',                () => context.push(AppRoutes.blog)),
            ]),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _linkSection(BuildContext context, String title, List<_Link> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title.toUpperCase(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Column(
            children: items.asMap().entries.map((e) {
              final i = e.key; final item = e.value;
              return Column(children: [
                ListTile(
                  leading: Icon(item.icon, size: 20),
                  title: Text(item.label, style: Theme.of(context).textTheme.bodyLarge),
                  trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 18),
                  onTap: item.onTap,
                ),
                if (i < items.length - 1) Divider(height: 1, indent: 56, color: Theme.of(context).dividerColor),
              ]);
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _Link {
  final IconData icon; final String label; final VoidCallback onTap;
  const _Link(this.icon, this.label, this.onTap);
}
