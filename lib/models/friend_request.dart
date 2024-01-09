import 'package:wishes_app/models/profile.dart';

class FriendRequestWithID {
  final String id;
  final userProfile fromUser;
  final userProfile toUser;

  const FriendRequestWithID({
    required this.id,
    required this.fromUser,
    required this.toUser,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'fromUser': fromUser.toJson(),
        'toUser': toUser.toJson(),
      };
}

class FriendRequest {
  final String fromUserId;
  final String toUserId;

  const FriendRequest({
    required this.fromUserId,
    required this.toUserId,
  });

  Map<String, dynamic> toJson() => {
        'fromUser': fromUserId,
        'toUser': toUserId,
      };
}
