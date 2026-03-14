import '../constants/app_constants.dart';

class UserModel {
  final String userId;
  final String displayName;
  final Gender gender;
  final AccountType accountType;
  final String? email;
  final bool isBanned;
  final String? banReason;
  final DateTime createdAt;
  final DateTime? lastSeen;

  const UserModel({
    required this.userId,
    required this.displayName,
    required this.gender,
    this.accountType = AccountType.anonymous,
    this.email,
    this.isBanned = false,
    this.banReason,
    required this.createdAt,
    this.lastSeen,
  });

  factory UserModel.anonymous({required String userId, required String displayName, required Gender gender}) {
    return UserModel(userId: userId, displayName: displayName, gender: gender, accountType: AccountType.anonymous, createdAt: DateTime.now());
  }

  UserModel copyWith({String? displayName, Gender? gender, AccountType? accountType, String? email, bool? isBanned}) {
    return UserModel(userId: userId, displayName: displayName ?? this.displayName, gender: gender ?? this.gender, accountType: accountType ?? this.accountType, email: email ?? this.email, isBanned: isBanned ?? this.isBanned, banReason: banReason, createdAt: createdAt, lastSeen: lastSeen);
  }

  Map<String, dynamic> toJson() => {'user_id': userId, 'display_name': displayName, 'gender': gender.name, 'account_type': accountType.name, 'email': email, 'is_banned': isBanned, 'created_at': createdAt.toIso8601String()};
}

class MessageModel {
  final String messageId;
  final String sessionId;
  final String senderId;
  final String content;
  final DateTime sentAt;
  final DateTime? deliveredAt;
  final DateTime? readAt;
  final MessageStatus status;
  final bool isMe;
  final bool isFlagged;

  const MessageModel({required this.messageId, required this.sessionId, required this.senderId, required this.content, required this.sentAt, this.deliveredAt, this.readAt, this.status = MessageStatus.sent, this.isMe = false, this.isFlagged = false});

  MessageModel copyWith({MessageStatus? status, DateTime? deliveredAt, DateTime? readAt}) {
    return MessageModel(messageId: messageId, sessionId: sessionId, senderId: senderId, content: content, sentAt: sentAt, deliveredAt: deliveredAt ?? this.deliveredAt, readAt: readAt ?? this.readAt, status: status ?? this.status, isMe: isMe, isFlagged: isFlagged);
  }
}

class ChatSessionModel {
  final String sessionId;
  final String user1Id;
  final String user2Id;
  final bool isBotSession;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int messageCount;
  final int durationSeconds;
  final SessionStatus status;
  final String? partnerName;
  final Gender? partnerGender;

  const ChatSessionModel({required this.sessionId, required this.user1Id, required this.user2Id, this.isBotSession = false, required this.startedAt, this.endedAt, this.messageCount = 0, this.durationSeconds = 0, this.status = SessionStatus.active, this.partnerName, this.partnerGender});
}
