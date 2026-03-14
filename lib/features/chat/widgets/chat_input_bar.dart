import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/session_service.dart';

class ChatInputBar extends StatefulWidget {
  final Function(String) onSend;
  final VoidCallback onEndChat;
  final VoidCallback onStartNewChat;
  final bool chatEnded;
  final SessionService sessionService;
  final String partnerName;

  const ChatInputBar({
    super.key,
    required this.onSend,
    required this.onEndChat,
    required this.onStartNewChat,
    required this.sessionService,
    required this.partnerName,
    this.chatEnded = false,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _showEndConfirm = false;

  @override
  void initState() {
    super.initState();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
    widget.sessionService.emitTyping(false);
    // Re-request focus so user can type next message immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  // ── Enter key on PC sends message ──────────────────────────
  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.enter &&
        !HardwareKeyboard.instance.isShiftPressed) {
      _send();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).dividerColor;
    final bg = Theme.of(context).appBarTheme.backgroundColor ?? AppColors.surface;

    // ── Chat ended → full-width "New Chat" button ──────────────
    if (widget.chatEnded) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: bg, border: Border(top: BorderSide(color: borderColor))),
        child: SafeArea(
          top: false,
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(14)),
              child: ElevatedButton.icon(
                onPressed: widget.onStartNewChat,
                icon: const Icon(Icons.bolt_rounded, color: Colors.white),
                label: const Text('+ New Chat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(color: bg, border: Border(top: BorderSide(color: borderColor))),
      child: SafeArea(
        top: false,
        child: _buildNormalBar(context),
      ),
    );
  }

  Widget _buildNormalBar(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // ── End button: two-tap confirm ─────────────────────────
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _showEndConfirm
              ? GestureDetector(
                  key: const ValueKey('sure'),
                  onTap: () { setState(() => _showEndConfirm = false); widget.onEndChat(); },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    margin: const EdgeInsets.only(bottom: 2),
                    decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(12)),
                    child: const Text('Sure?', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                )
              : GestureDetector(
                  key: const ValueKey('end'),
                  onTap: () => setState(() => _showEndConfirm = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    margin: const EdgeInsets.only(bottom: 2),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.error.withOpacity(0.5)),
                    ),
                    child: const Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.call_end_rounded, color: AppColors.error, size: 14),
                      SizedBox(width: 4),
                      Text('End', style: TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ),
        ),
        const SizedBox(width: 5),

        // ❌ REMOVED: Media picker button - no more file sharing

        // Text field — Enter sends on PC
        Expanded(
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) => _handleKey(_focusNode, event),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              enabled: !widget.chatEnded,
              maxLines: 4,
              minLines: 1,
              maxLength: AppConstants.messageMaxChars,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _send(),
              onChanged: (v) {
                widget.sessionService.emitTyping(v.isNotEmpty);
              },
              decoration: InputDecoration(
                hintText: widget.chatEnded ? 'Chat ended' : 'Message...',
                counterText: '',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none),
                disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none),
                filled: true,
                fillColor: widget.chatEnded
                    ? Theme.of(context).colorScheme.surface.withOpacity(0.5)
                    : Theme.of(context).colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 5),

        // Send button (always visible)
        GestureDetector(
          onTap: widget.chatEnded ? null : _send,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: widget.chatEnded
                  ? LinearGradient(colors: [AppColors.textMuted, AppColors.textMuted])
                  : AppColors.primaryGradient,
            ),
            child: const Icon(Icons.send_rounded, color: Colors.white, size: 19),
          ),
        ),
      ],
    );
  }

}
