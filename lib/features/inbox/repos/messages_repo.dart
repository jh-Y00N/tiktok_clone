import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room_model.dart';
import 'package:tiktok_clone/features/inbox/models/message_model.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class MessagesRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<ChatRoomModel>> getChats() async {
    final snapshot = await _db.collection("chat_rooms").get();
    final chatList = await Future.wait(
      snapshot.docs.map(
        (e) async {
          final textsSnapshot = await _db
              .collection("chat_rooms")
              .doc(e.id)
              .collection("texts")
              .get();
          if (textsSnapshot.docs.isEmpty) {
            _db.collection("chat_rooms").doc(e.id).delete();
            return null;
          }
          final texts = textsSnapshot.docs
              .map((text) => MessageModel.fromJson(text.data()))
              .toList();
          final userSnapshot = await _db
              .collection("chat_rooms")
              .doc(e.id)
              .collection("user")
              .get();
          final user =
              UserProfileModel.fromJson(userSnapshot.docs.first.data());
          return ChatRoomModel(id: e.id, texts: texts, user: user);
        },
      ).toList(),
    );
    return chatList
        .where((chatRoom) => chatRoom != null)
        .cast<ChatRoomModel>()
        .toList();
  }

  Future<void> sendMessage({
    required String chatRoomId,
    required MessageModel message,
  }) async {
    await _db
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("texts")
        .add(message.toJson());
  }

  Future<String> createChatRoom(UserProfileModel user) async {
    final ref = await _db.collection("chat_rooms").add({});
    await _db
        .collection("chat_rooms")
        .doc(ref.id)
        .collection("user")
        .add(user.toJson());
    return ref.id;
  }

  Future<String> findChatRoom(UserProfileModel user) async {
    final chatRoom = await _db.collection("chat_rooms").get();
    String chatId = "";
    for (var element in chatRoom.docs) {
      final chat = await _db
          .collection("chat_rooms")
          .doc(element.id)
          .collection("user")
          .get();
      if (UserProfileModel.fromJson(chat.docs.first.data()).uid == user.uid) {
        chatId = element.id;
      }
    }
    print(chatId);
    return chatId;
  }

  Future<void> deleteMessage(String chatRoomId, String textId) async {
    await _db
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("texts")
        .doc(textId)
        .update({"text": "[deleted]"});
  }
}

final messagesRepo = Provider(
  (ref) => MessagesRepo(),
);
