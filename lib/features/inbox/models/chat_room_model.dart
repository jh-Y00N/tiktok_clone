import 'package:tiktok_clone/features/inbox/models/message_model.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class ChatRoomModel {
  ChatRoomModel({
    required this.id,
    required this.texts,
    required this.user,
  });

  String id;
  List<MessageModel> texts;
  UserProfileModel user;

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "texts": texts.map((e) => e.toJson()).toList(),
      "user": user.toJson(),
    };
  }

  factory ChatRoomModel.fromJson({required Map<String, dynamic> json}) {
    final user = UserProfileModel.fromJson(json['user']);

    final textsList = (json['texts'] as List)
        .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return ChatRoomModel(
      id: json['id'],
      texts: textsList,
      user: user,
    );
  }
}
