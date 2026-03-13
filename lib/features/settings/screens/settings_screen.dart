import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/routes/app_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _usernameController = TextEditingController(text: 'Anonymous');
  Gender _gender = Gender.preferNotToSay;
  int _age = 18;
  String _location = 'United States';
  final List<String> _interests = [];

  bool _soundNotifications = true;
  bool _pushNotifications = true;
  bool _autoConnect = false;
  bool _autoCallWhenPartnerEnds = false;
  bool _autoCallWhenIEnd = false;
  bool _allowVideoCallsIn = true;
  bool _allowAudioCallsIn = true;
  bool _allowMediaIn = false;

  // Matching preferences
  final List<Gender> _getRequestFrom = [Gender.male, Gender.female, Gender.preferNotToSay];
  final List<Gender> _sendRequestTo  = [Gender.male, Gender.female, Gender.preferNotToSay];

  static const List<String> _interestOptions = [
    'Music', 'Travel', 'Movies', 'Gaming', 'Sports', 'Cooking',
    'Fitness', 'Art', 'Technology', 'Books', 'Photography', 'Fashion',
    'Anime', 'Science', 'Nature', 'Comedy', 'Podcasts', 'Politics',
  ];

  static const List<String> _countries = [
    'Afghanistan','Albania','Algeria','Argentina','Australia','Austria','Bangladesh',
    'Belgium','Brazil','Canada','Chile','China','Colombia','Croatia','Czech Republic',
    'Denmark','Egypt','Ethiopia','Finland','France','Germany','Ghana','Greece',
    'Hungary','India','Indonesia','Iran','Iraq','Ireland','Israel','Italy',
    'Japan','Jordan','Kenya','Malaysia','Mexico','Morocco','Netherlands','New Zealand',
    'Nigeria','Norway','Pakistan','Peru','Philippines','Poland','Portugal','Romania',
    'Russia','Saudi Arabia','South Africa','South Korea','Spain','Sri Lanka','Sweden',
    'Switzerland','Thailand','Turkey','Ukraine','United Arab Emirates','United Kingdom',
    'United States','Vietnam',
  ];

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _goBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      context.go(AppRoutes.dashboard);
    }
  }

  void _showCountryPicker() {
    String search = '';
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModal) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(width: 36, height: 4, decoration: BoxDecoration(color: Theme.of(context).dividerColor, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  autofocus: true,
                  decoration: const InputDecoration(hintText: 'Search country...', prefixIcon: Icon(Icons.search_rounded, color: AppColors.textMuted)),
                  onChanged: (v) => setModal(() => search = v),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  children: _countries
                      .where((c) => c.toLowerCase().contains(search.toLowerCase()))
                      .map((c) => ListTile(
                            title: Text(c),
                            trailing: _location == c ? const Icon(Icons.check_rounded, color: AppColors.primary) : null,
                            onTap: () { setState(() => _location = c); Navigator.pop(ctx); },
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(String title, {required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10, top: 24),
          child: Text(title.toUpperCase(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _tile({required Widget leading, required String title, String? subtitle, Widget? trailing, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          leading,
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: Theme.of(context).textTheme.bodyLarge),
            if (subtitle != null) ...[
              const SizedBox(height: 3),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.3)),
            ],
          ])),
          if (trailing != null) trailing,
        ]),
      ),
    );
  }

  Widget _toggle({required IconData icon, required String title, String? subtitle, required bool value, required ValueChanged<bool> onChanged, Color? iconColor}) {
    return _tile(
      leading: Icon(icon, color: iconColor ?? Theme.of(context).iconTheme.color, size: 20),
      title: title,
      subtitle: subtitle,
      trailing: Switch(value: value, onChanged: onChanged, activeColor: AppColors.primary),
    );
  }

  Widget _divider() => Divider(height: 1, indent: 48, color: Theme.of(context).dividerColor);

  void _showAgeConfirm({required String message, required VoidCallback onConfirmed}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: const [
          Icon(Icons.verified_user_outlined, color: AppColors.primary, size: 22),
          SizedBox(width: 8),
          Text('Confirm Age'),
        ]),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () { onConfirmed(); Navigator.pop(context); },
            child: const Text("I'm 18+, Enable"),
          ),
        ],
      ),
    );
  }

  Widget _genderPref(Gender gender, String emoji, String label, List<Gender> selected, Function(Gender) onToggle) {
    final isSelected = selected.contains(gender);
    Color color;
    if (gender == Gender.male) color = AppColors.male;
    else if (gender == Gender.female) color = AppColors.female;
    else color = AppColors.other;
    return Expanded(
      child: GestureDetector(
        onTap: () => onToggle(gender),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.15) : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isSelected ? color : Theme.of(context).dividerColor, width: isSelected ? 1.5 : 1),
          ),
          child: Column(children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 11, color: isSelected ? color : AppColors.textMuted, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _goBack,
        ),
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [

          // ── PROFILE ──────────────────────────────────────────────
          _section('Profile', children: [
            // Avatar row
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                Stack(children: [
                  Container(
                    width: 64, height: 64,
                    decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppColors.primaryGradient),
                    child: const Icon(Icons.person_rounded, color: Colors.white, size: 30),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      width: 22, height: 22,
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 12),
                    ),
                  ),
                ]),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Profile Picture', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text('Reviewed by moderators · Max 5MB', style: Theme.of(context).textTheme.bodySmall),
                ])),
              ]),
            ),
            _divider(),
            // Username
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(children: [
                const Icon(Icons.badge_outlined, size: 20),
                const SizedBox(width: 12),
                Expanded(child: TextField(
                  controller: _usernameController,
                  maxLength: 50,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    counterText: '',
                    filled: false,
                  ),
                )),
              ]),
            ),
            _divider(),
            // Gender
            _tile(
              leading: const Icon(Icons.wc_rounded, size: 20),
              title: 'Gender',
              trailing: DropdownButton<Gender>(
                value: _gender,
                underline: const SizedBox(),
                dropdownColor: Theme.of(context).cardColor,
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 14),
                items: const [
                  DropdownMenuItem(value: Gender.male, child: Text('Male')),
                  DropdownMenuItem(value: Gender.female, child: Text('Female')),
                  DropdownMenuItem(value: Gender.preferNotToSay, child: Text('Other')),
                ],
                onChanged: (v) => setState(() => _gender = v!),
              ),
            ),
            _divider(),
            // Age
            _tile(
              leading: const Icon(Icons.cake_outlined, size: 20),
              title: 'Age',
              trailing: DropdownButton<int>(
                value: _age,
                underline: const SizedBox(),
                dropdownColor: Theme.of(context).cardColor,
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 14),
                menuMaxHeight: 240,
                items: List.generate(73, (i) => i + 18)
                    .map((a) => DropdownMenuItem(value: a, child: Text('$a')))
                    .toList(),
                onChanged: (v) => setState(() => _age = v!),
              ),
            ),
            _divider(),
            // Location
            _tile(
              leading: const Icon(Icons.location_on_outlined, size: 20),
              title: 'Location',
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(_location, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 18),
              ]),
              onTap: _showCountryPicker,
            ),
          ]),

          // ── INTERESTS ────────────────────────────────────────────
          _section('Interests', children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Share your interests or what you\'d like to chat about',
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: _interestOptions.map((interest) {
                    final selected = _interests.contains(interest);
                    return GestureDetector(
                      onTap: () => setState(() => selected ? _interests.remove(interest) : _interests.add(interest)),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primary.withOpacity(0.15) : Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: selected ? AppColors.primary : Theme.of(context).dividerColor, width: selected ? 1.5 : 1),
                        ),
                        child: Text(interest, style: TextStyle(
                          fontSize: 13,
                          color: selected ? AppColors.primary : Theme.of(context).textTheme.bodySmall?.color,
                          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                        )),
                      ),
                    );
                  }).toList(),
                ),
              ]),
            ),
          ]),

          // ── NOTIFICATIONS ────────────────────────────────────────
          _section('Notifications', children: [
            _toggle(icon: Icons.volume_up_rounded, title: 'Enable Sound Notifications', value: _soundNotifications, onChanged: (v) => setState(() => _soundNotifications = v)),
            _divider(),
            _toggle(icon: Icons.notifications_outlined, title: 'Push Notifications (DMs)', value: _pushNotifications, onChanged: (v) => setState(() => _pushNotifications = v)),
          ]),

          // ── CHAT BEHAVIOUR ───────────────────────────────────────
          _section('Chat Behaviour', children: [
            _toggle(icon: Icons.bolt_rounded, title: 'Auto-connect when chat ends',
              subtitle: 'Automatically find a new chat partner', value: _autoConnect, onChanged: (v) => setState(() => _autoConnect = v)),
            _divider(),
            _toggle(icon: Icons.call_end_outlined, title: 'Auto-call when partner ends call',
              subtitle: 'Restart call if your partner hangs up', value: _autoCallWhenPartnerEnds, onChanged: (v) => setState(() => _autoCallWhenPartnerEnds = v)),
            _divider(),
            _toggle(icon: Icons.replay_rounded, title: 'Auto-call when I end call',
              subtitle: 'Restart call immediately after you hang up', value: _autoCallWhenIEnd, onChanged: (v) => setState(() => _autoCallWhenIEnd = v)),
          ]),

          // ── APPEARANCE ───────────────────────────────────────────
          _section('Appearance', children: [
            _toggle(
              icon: themeProvider.isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              title: 'Dark Mode',
              subtitle: themeProvider.isDark ? 'Currently using dark theme' : 'Currently using light theme',
              value: themeProvider.isDark,
              onChanged: (_) => themeProvider.toggle(),
              iconColor: themeProvider.isDark ? AppColors.primary : const Color(0xFFF59E0B),
            ),
          ]),

          // ── MATCHING PREFERENCES ─────────────────────────────────
          _section('Matching Preferences', children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              child: Text('Get requests from', style: Theme.of(context).textTheme.titleMedium),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
              child: Row(children: [
                _genderPref(Gender.male, '👨', 'Male', _getRequestFrom, (g) {
                  setState(() => _getRequestFrom.contains(g) ? _getRequestFrom.remove(g) : _getRequestFrom.add(g));
                }),
                const SizedBox(width: 8),
                _genderPref(Gender.female, '👩', 'Female', _getRequestFrom, (g) {
                  setState(() => _getRequestFrom.contains(g) ? _getRequestFrom.remove(g) : _getRequestFrom.add(g));
                }),
                const SizedBox(width: 8),
                _genderPref(Gender.preferNotToSay, '🧑', 'Others', _getRequestFrom, (g) {
                  setState(() => _getRequestFrom.contains(g) ? _getRequestFrom.remove(g) : _getRequestFrom.add(g));
                }),
              ]),
            ),
            Divider(height: 1, color: Theme.of(context).dividerColor),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              child: Text('Send requests to', style: Theme.of(context).textTheme.titleMedium),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
              child: Row(children: [
                _genderPref(Gender.male, '👨', 'Male', _sendRequestTo, (g) {
                  setState(() => _sendRequestTo.contains(g) ? _sendRequestTo.remove(g) : _sendRequestTo.add(g));
                }),
                const SizedBox(width: 8),
                _genderPref(Gender.female, '👩', 'Female', _sendRequestTo, (g) {
                  setState(() => _sendRequestTo.contains(g) ? _sendRequestTo.remove(g) : _sendRequestTo.add(g));
                }),
                const SizedBox(width: 8),
                _genderPref(Gender.preferNotToSay, '🧑', 'Others', _sendRequestTo, (g) {
                  setState(() => _sendRequestTo.contains(g) ? _sendRequestTo.remove(g) : _sendRequestTo.add(g));
                }),
              ]),
            ),
          ]),

          // ── PRIVACY & PERMISSIONS ─────────────────────────────────
          _section('Privacy & Permissions', children: [
            _tile(
              leading: const Icon(Icons.videocam_outlined, color: AppColors.primary, size: 20),
              title: 'Allow incoming video calls',
              subtitle: 'Video chat is for users 18+ only',
              trailing: Switch(
                value: _allowVideoCallsIn,
                activeColor: AppColors.primary,
                onChanged: (v) {
                  if (v) {
                    _showAgeConfirm(
                      message: 'By enabling this, you confirm you are 18 years of age or older and consent to receiving video calls from chat partners.',
                      onConfirmed: () => setState(() => _allowVideoCallsIn = true),
                    );
                  } else {
                    setState(() => _allowVideoCallsIn = false);
                  }
                },
              ),
            ),
            _divider(),
            _tile(
              leading: const Icon(Icons.mic_outlined, color: AppColors.primary, size: 20),
              title: 'Allow incoming audio calls',
              subtitle: 'Audio chat is for users 18+ only',
              trailing: Switch(
                value: _allowAudioCallsIn,
                activeColor: AppColors.primary,
                onChanged: (v) {
                  if (v) {
                    _showAgeConfirm(
                      message: 'By enabling this, you confirm you are 18 years of age or older and consent to receiving audio calls from chat partners.',
                      onConfirmed: () => setState(() => _allowAudioCallsIn = true),
                    );
                  } else {
                    setState(() => _allowAudioCallsIn = false);
                  }
                },
              ),
            ),
            _divider(),
            _tile(
              leading: const Icon(Icons.perm_media_outlined, color: AppColors.primary, size: 20),
              title: 'Allow incoming images & videos',
              subtitle: 'By enabling, you confirm you are 18+ and consent to receive media',
              trailing: Switch(
                value: _allowMediaIn,
                activeColor: AppColors.primary,
                onChanged: (v) {
                  if (v) {
                    _showAgeConfirm(
                      message: 'By enabling this, you confirm you are 18 years of age or older and consent to receiving media files from chat partners.',
                      onConfirmed: () => setState(() => _allowMediaIn = true),
                    );
                  } else {
                    setState(() => _allowMediaIn = false);
                  }
                },
              ),
            ),
          ]),

          // ── INFO & LEGAL ─────────────────────────────────────────
          _section('Info & Legal', children: [
            _tile(leading: const Icon(Icons.info_outline_rounded, size: 20), title: 'About Us', trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 18), onTap: () => context.push(AppRoutes.aboutUs)),
            _divider(),
            _tile(leading: const Icon(Icons.privacy_tip_outlined, size: 20), title: 'Privacy Policy', trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 18), onTap: () => context.push(AppRoutes.privacyPolicy)),
            _divider(),
            _tile(leading: const Icon(Icons.gavel_rounded, size: 20), title: 'Terms of Use', trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 18), onTap: () => context.push(AppRoutes.termsOfUse)),
            _divider(),
            _tile(leading: const Icon(Icons.description_outlined, size: 20), title: 'Terms & Conditions', trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 18), onTap: () => context.push(AppRoutes.termsConditions)),
            _divider(),
            _tile(leading: const Icon(Icons.quiz_outlined, size: 20), title: 'FAQs', trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 18), onTap: () => context.push(AppRoutes.faq)),
            _divider(),
            _tile(leading: const Icon(Icons.article_outlined, size: 20), title: 'Blog', trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 18), onTap: () => context.push(AppRoutes.blog)),
          ]),

          const SizedBox(height: 32),
          Center(child: Text('RandomChat v1.0.0', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted))),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
