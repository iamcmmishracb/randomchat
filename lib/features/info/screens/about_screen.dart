import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routes/app_router.dart';

// ── About ─────────────────────────────────────────────────────────────────────
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) => _InfoScaffold(title: 'About Us', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _HeroBlock(icon: Icons.chat_bubble_rounded, title: 'Strangchatomy', subtitle: 'Meet someone new, right now.'),
    _Section('Who We Are', 'Strangchatomy is an anonymous real-time chat platform built for people who value spontaneous, genuine human connection. We believe the best conversations happen without the pressure of profiles, followers, or social expectations.\n\nFounded in 2026, our team is passionate about creating a space where anyone — anywhere in the world — can have a real conversation with a real person.'),
    _Section('Our Mission', 'Our mission is simple: bring people together in a safe, private, and respectful environment. We are committed to building technology that fosters authentic connection while keeping user safety and privacy at the forefront of everything we do.'),
    _Section('What Makes Us Different', '• Zero chat history — your conversations are private by design\n• Real-time moderation powered by AI + human reviewers\n• Available on Web and Android\n• No account required to start chatting\n• Completely free — no subscriptions, no hidden fees'),
    _Section('Our Values', '🔒  Privacy First — We never store your chats.\n🤝  Respect — Harassment is not tolerated.\n🌍  Inclusivity — Everyone is welcome.\n⚡  Simplicity — No profiles, no followers, just talk.\n🆓  Free Forever — No paywalls, ever.'),
    _Section('Contact Us', 'Have feedback or questions? We\'d love to hear from you.\n\n📧  learneducamy@gmail.com'),
    const SizedBox(height: 8),
    Center(child: Text('Strangchatomy v1.0.0 · Built with ❤️', style: TextStyle(color: AppColors.textMuted, fontSize: 12))),
  ]));
}

// ── Privacy Policy ────────────────────────────────────────────────────────────
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});
  @override
  Widget build(BuildContext context) => _InfoScaffold(title: 'Privacy Policy', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _MetaInfo('Last Updated: March 2026 · Governed by: DPDP Act 2023 & IT Act 2000 (India)'),
    _Section('1. Introduction', 'Strangchatomy ("we", "our", "us") is committed to protecting your privacy under the Digital Personal Data Protection Act, 2023 (DPDP Act) and the Information Technology Act, 2000. This Privacy Policy explains what data we collect, why, and your rights over it.'),
    _Section('2. Data We Collect and Why', 'When you start a chat session we collect:\n\n• Display name — to identify you in chat\n• Gender preference — for partner matching\n• Device identifier — to prevent banned users from rejoining\n• Device model & manufacturer — for compatibility and abuse prevention\n• IP address (AES-256 encrypted immediately on receipt) — for abuse prevention and IT Act 2000 compliance\n• Consent record with timestamp — required by DPDP Act 2023, Sec. 6\n\nWe do NOT collect your real name, phone number, email address, contacts, or social media profiles.'),
    _Section('3. Lawful Basis for Processing', '• Consent (DPDP Act 2023, Sec. 6) — You give explicit, informed, revocable consent before any data is collected.\n• Legitimate use — Fraud prevention and safety.\n• Legal obligation — Compliance with lawful orders under IT Act 2000, Sec. 69.'),
    _Section('4. Data Retention', '• Session records: deleted after 90 days\n• Encrypted IP addresses: deleted after 90 days\n• Chat messages: AES-256-CBC encrypted, auto-deleted after 90 days\n• Accounts under legal hold: retained until hold is lifted\n\nYou may request immediate deletion at any time (see Section 6).'),
    _Section('5. Data Security', 'All IP addresses are encrypted with AES-256 immediately on receipt and are never stored in plaintext. Data in transit uses TLS 1.3. Access to personal data is restricted to authorised personnel only.'),
    _Section('6. Your Rights (DPDP Act 2023)', 'Under the DPDP Act 2023, you have the right to:\n\n• Access — Request confirmation of what data we hold.\n• Correction — Request correction of inaccurate data.\n• Erasure — Delete your account and all data from contacting learneducamy@gmail.com. We process your request unless a legal hold applies.\n• Withdrawal of Consent — Withdraw at any time; this does not affect prior lawful processing.\n• Grievance Redressal — Raise a complaint with our Grievance Officer (Section 8).\n\nTo exercise any right: learneducamy@gmail.com'),
    _Section('7. Law Enforcement Disclosure', 'We may disclose data in response to lawful orders under IT Act 2000 (Sec. 69), CRPC Sec. 91, or MLAT requests. All such requests are logged and reviewed. We notify you unless prohibited by law.'),
    _Section('8. Grievance Officer (IT Rules 2021, Rule 3(1)(c))', 'In accordance with Rule 3(1)(c) of the IT (Intermediary Guidelines) Rules, 2021:\n\n📧  learneducamy@gmail.com\n🕐  Complaints acknowledged within 24 hours, resolved within 15 days.'),
    _Section('9. Children\'s Data (DPDP Act 2023, Sec. 9)', 'Strangchatomy is strictly for users 18+. Users must confirm their age before using the platform. We do not knowingly collect data from minors. Accounts found to belong to minors are immediately deleted.'),
    _Section('10. Contact', 'Privacy: learneducamy@gmail.com\nData Protection Officer: learneducamy@gmail.com\nGrievance Officer: learneducamy@gmail.com'),
  ]));
}

// ── Terms of Use ──────────────────────────────────────────────────────────────
class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});
  @override
  Widget build(BuildContext context) => _InfoScaffold(title: 'Terms of Use', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _MetaInfo('Last Updated: March 2026 · Governed by laws of India'),
    _Section('1. Acceptance', 'By accessing or using Strangchatomy, you confirm that you are at least 18 years of age and agree to be bound by these Terms of Use, our Privacy Policy, and all applicable Indian laws including the IT Act 2000 and DPDP Act 2023.'),
    _Section('2. Age Requirement & Eligibility', '• You must be 18 years of age or older. By using this platform you confirm this under DPDP Act 2023, Sec. 9.\n• You must not be a previously banned user attempting to re-access the platform.\n• You must not use this platform on behalf of a minor.'),
    _Section('3. Prohibited Conduct', 'You agree NOT to:\n• Share sexual, violent, or illegal content\n• Harass, threaten, or abuse other users\n• Share personal information of others without consent\n• Use bots, scripts, or automated tools\n• Share CSAM or any content involving minors\n• Attempt to de-anonymise other users'),
    _Section('4. Consent & Data', 'By using Strangchatomy you consent to the collection and processing of limited personal data as described in our Privacy Policy. You may withdraw consent at any time by contacting us at learneducamy@gmail.com.'),
    _Section('5. Moderation & Bans', 'We reserve the right to ban any user at any time for violations. Severe violations result in immediate permanent bans. Repeat offenders may be reported to law enforcement under IT Act 2000.'),
    _Section('6. Grievance Redressal (IT Rules 2021)', 'If you believe your rights have been violated or wish to report content, contact our Grievance Officer at learneducamy@gmail.com. Complaints are acknowledged within 24 hours and resolved within 15 days.'),
    _Section('7. Disclaimer', 'Strangchatomy is provided "as is" without warranty of any kind. We do not guarantee match availability or the behaviour of other users.'),
    _Section('8. Governing Law', 'These Terms are governed by the laws of India. Any disputes shall be subject to the exclusive jurisdiction of courts in India.'),
    _Section('7. Contact', 'Legal & Grievance Officer: learneducamy@gmail.com'),
  ]));
}

// ── Terms & Conditions ────────────────────────────────────────────────────────
class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});
  @override
  Widget build(BuildContext context) => _InfoScaffold(title: 'Terms & Conditions', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _MetaInfo('Last Updated: March 2026'),
    _Section('1. Platform Description', 'Strangchatomy provides a real-time anonymous chat service connecting users for text-based communication. The service is completely free — no subscriptions, no premium tiers, no hidden fees.'),
    _Section('2. Free Service', 'Strangchatomy is and will remain entirely free. All features are available to all users at no cost:\n• Unlimited text messaging\n• Instant random matching\n• AI partner when no real user is available'),
    _Section('3. Free Tier Features', '• Unlimited text messaging\n• Standard queue priority'),
    _Section('4. Intellectual Property', 'All platform content, design, trademarks, and technology are owned by Strangchatomy. You may not reproduce or create derivative works without written permission.'),
    _Section('5. Service Availability', 'We aim for 99.9% uptime but do not guarantee uninterrupted service.'),
    _Section('6. Termination', 'We may terminate access immediately for conduct that violates these terms or harms other users.'),
  ]));
}

// ── FAQ ───────────────────────────────────────────────────────────────────────
class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});
  static const _faqs = [
    ('Is Strangchatomy really anonymous?', 'Yes. You do not need to create an account. You only provide a nickname. We do not collect your real name, phone number, or email. Messages are encrypted and auto-deleted after 90 days.'),
    ('What is the Device ID and is it real?', 'Yes — it is a real, hardware-assigned identifier. On Android we use the Android Device ID (assigned by the OS, no special permission needed). On iOS we use the identifierForVendor. On web/desktop we generate a session-based fallback ID. We use this solely to prevent banned users from rejoining — it is never shared with third parties.'),
    ('How does matching work?', 'When you tap "Start Chat", our system finds another available user. If no real user is available within a few seconds, you\'ll be connected to an AI partner so you\'re never left waiting.'),
    ('Can I choose who I talk to?', 'No — that\'s the whole point! Strangchatomy is about spontaneous, unexpected connections. Every match is completely random.'),
    ('Is my chat history saved?', 'No. Once a chat ends, it is permanently deleted. Chat messages are encrypted and auto-deleted after 90 days. This is a core privacy feature of Strangchatomy.'),
    ('What happens if I get disconnected?', 'If either party disconnects, the chat session ends immediately. You can start a new chat from the home screen at any time.'),
    ('How do I report someone?', 'Tap the menu (⋮) in the top-right corner of any chat and select "Report User". Choose a reason and add details. All reports are reviewed within 24 hours.'),
    ('Is Strangchatomy safe for minors?', 'No. Strangchatomy is strictly for users 18+. We have content moderation systems in place, but the platform is not appropriate for minors under any circumstances.'),
    ('How do I delete my account?', 'Email us at learneducamy@gmail.com and we will delete your data within 30 days.'),
  ];
  @override
  Widget build(BuildContext context) => _InfoScaffold(title: 'FAQs', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Padding(padding: const EdgeInsets.only(bottom: 20), child: Text('Frequently Asked Questions', style: Theme.of(context).textTheme.headlineSmall)),
    ..._faqs.map((faq) => _FAQItem(question: faq.$1, answer: faq.$2)),
  ]));
}

// ── Blog (list + detail) ──────────────────────────────────────────────────────
class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  static const _posts = [
    _BlogPost(
      id: '1',
      title: 'Why Anonymous Chat is the Future of Authentic Connection',
      date: 'March 2026', readTime: '5 min read',
      excerpt: 'In a world saturated with curated profiles and performative social media, there\'s a growing hunger for something real.',
      body: 'In a world saturated with curated profiles and performative social media, there\'s a growing hunger for something real. Strangchatomy taps into that desire by stripping away the social armour we all wear online.\n\nWhen you know someone can see your profile picture, follower count, and post history, you perform. You self-censor. You say what you think sounds good rather than what you actually think.\n\nAnonymity removes that pressure. Studies consistently show that people share more honestly, engage more deeply, and feel more genuine connection when their identity is protected. The therapist\'s couch works for the same reason: safety comes from privacy.\n\nStrangchatomy is built on this insight. No profiles. No followers. No permanent record. Just two humans, talking.',
    ),
    _BlogPost(
      id: '2',
      title: 'How We Built Our Matching Engine',
      date: 'March 2026', readTime: '8 min read',
      excerpt: 'One of the most common complaints about random chat platforms is the mismatch in expectations between users.',
      body: 'One of the most common complaints about random chat platforms is the mismatch in expectations between users. You tap \"next\" and get matched with someone looking for something completely different.\n\nOur matching algorithm considers:\n• Active session count (to predict match availability)\n• User interest overlap (derived from early messages)\n• Gender preference (if provided)\n• Connection stability (to avoid timeout mismatches)\n\nThe system is intelligent enough to learn, but transparent enough that users understand why they\'re matched with someone. We don\'t use dark patterns or hidden metrics.\n\nThe result: better conversations, longer sessions, and more natural connections.',
    ),
    _BlogPost(
      id: '3',
      title: 'Safety First: How We Moderate Conversations',
      date: 'March 2026', readTime: '6 min read',
      excerpt: 'Real safety requires both technology and humans working together.',
      body: 'Real safety requires both technology and humans working together. Our moderation system uses AI to detect patterns of abuse and flag violations, but human reviewers make the final call.\n\nWhen a user reports another:\n1. The report is logged and reviewed within 24 hours\n2. Context is evaluated — a single report isn\'t enough\n3. Patterns of behavior are analyzed\n4. Users who repeatedly violate terms are permanently banned\n\nWe don\'t store conversations, but we do flag IP addresses of banned users to prevent rejoining. This is a careful balance between safety and privacy.',
    ),
  ];

  @override
  Widget build(BuildContext context) => _InfoScaffold(title: 'Blog', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Padding(padding: const EdgeInsets.only(bottom: 20), child: Text('Latest Stories', style: Theme.of(context).textTheme.headlineSmall)),
    ..._posts.map((post) => _BlogCard(
      post: post,
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => _BlogDetailScreen(post: post),
      )),
    )),
  ]));
}

// ── Blog Detail ───────────────────────────────────────────────────────────────
class _BlogDetailScreen extends StatelessWidget {
  final _BlogPost post;
  const _BlogDetailScreen({required this.post});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    appBar: AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.pop(context),
      ),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(post.date, style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              Container(width: 3, height: 3, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.textMuted)),
              const SizedBox(width: 8),
              Text(post.readTime, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 12),
          Text(post.title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 20),
          Text(post.body, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.8)),
        ],
      ),
    ),
  );
}

// ── Shared Widgets ────────────────────────────────────────────────────────────
class _InfoScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  const _InfoScaffold({required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    appBar: AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => context.go(AppRoutes.home),
      ),
      title: Text(title),
    ),
    body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: child),
  );
}

class _HeroBlock extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  const _HeroBlock({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 28),
    child: Center(child: Column(children: [
      Container(width: 72, height: 72, decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppColors.primaryGradient), child: Icon(icon, color: Colors.white, size: 32)),
      const SizedBox(height: 12),
      Text(title, style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppColors.primary)),
      const SizedBox(height: 4),
      Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
    ])),
  );
}

class _MetaInfo extends StatelessWidget {
  final String text;
  const _MetaInfo(this.text);
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 20),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.06), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.primary.withOpacity(0.2))),
    child: Text(text, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
  );
}

class _Section extends StatelessWidget {
  final String heading, body;
  const _Section(this.heading, this.body);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(heading, style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8),
      Text(body, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.7)),
      const Divider(height: 28),
    ]),
  );
}

class _FAQItem extends StatefulWidget {
  final String question, answer;
  const _FAQItem({required this.question, required this.answer});
  @override
  State<_FAQItem> createState() => _FAQItemState();
}
class _FAQItemState extends State<_FAQItem> {
  bool _open = false;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _open ? AppColors.primary.withOpacity(0.5) : Theme.of(context).dividerColor),
    ),
    child: Column(children: [
      ListTile(
        title: Text(widget.question, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: _open ? AppColors.primary : null)),
        trailing: Icon(_open ? Icons.expand_less_rounded : Icons.expand_more_rounded, color: _open ? AppColors.primary : AppColors.textMuted),
        onTap: () => setState(() => _open = !_open),
      ),
      if (_open) Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Text(widget.answer, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6)),
      ),
    ]),
  );
}

class _BlogCard extends StatelessWidget {
  final _BlogPost post;
  final VoidCallback onTap;
  const _BlogCard({required this.post, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(post.date, style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Container(width: 3, height: 3, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.textMuted)),
          const SizedBox(width: 8),
          Text(post.readTime, style: Theme.of(context).textTheme.bodySmall),
        ]),
        const SizedBox(height: 8),
        Text(post.title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 6),
        Text(post.excerpt, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5), maxLines: 2, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 10),
        Row(children: [
          const Text('Read More', style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_forward_rounded, color: AppColors.primary, size: 14),
        ]),
      ]),
    ),
  );
}

class _BlogPost {
  final String id, title, date, readTime, excerpt, body;
  const _BlogPost({required this.id, required this.title, required this.date, required this.readTime, required this.excerpt, required this.body});
}
