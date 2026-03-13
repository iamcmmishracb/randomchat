import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/models/user_model.dart';
import '../../../core/utils/app_utils.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool showTimestamp;

  const MessageBubble({super.key, required this.message, this.showTimestamp = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showTimestamp)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: AppColors.surfaceElevated, borderRadius: BorderRadius.circular(20)),
                child: Text(AppUtils.formatMessageTime(message.sentAt), style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11)),
              ),
            ),
          ),
        Align(
          alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.only(
              bottom: 4,
              left: message.isMe ? 60 : 0,
              right: message.isMe ? 0 : 60,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: message.isMe ? AppColors.bubbleSent : AppColors.bubbleReceived,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(message.isMe ? 18 : 4),
                bottomRight: Radius.circular(message.isMe ? 4 : 18),
              ),
              boxShadow: message.isMe ? [BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 2))] : null,
            ),
            child: Column(
              crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // ❌ REMOVED: Image display - no more media
                // Just show text messages
                Text(
                  message.content,
                  style: TextStyle(
                    color: message.isMe ? const Color(0xFF001A18) : AppColors.textPrimary,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppUtils.formatMessageTime(message.sentAt),
                      style: TextStyle(
                        fontSize: 10,
                        color: message.isMe ? const Color(0xFF003330) : AppColors.textMuted,
                      ),
                    ),
                    if (message.isMe) ...[
                      const SizedBox(width: 4),
                      _buildStatusIcon(message.status),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sent:
        return const Icon(Icons.check_rounded, size: 13, color: Color(0xFF003330));
      case MessageStatus.delivered:
        return const Icon(Icons.done_all_rounded, size: 13, color: Color(0xFF003330));
      case MessageStatus.read:
        return const Icon(Icons.done_all_rounded, size: 13, color: Colors.white);
    }
  }
}
