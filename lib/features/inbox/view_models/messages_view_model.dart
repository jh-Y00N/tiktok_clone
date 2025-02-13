import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/message_model.dart';
import 'package:tiktok_clone/features/inbox/repos/messages_repo.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class MessagesViewModel extends FamilyAsyncNotifier<void, String?> {
  late MessagesRepo _repository;
  late String? _chatId;

  @override
  FutureOr<void> build(String? arg) {
    _repository = ref.read(messagesRepo);
    _chatId = arg;
  }

  Future<String> createChatRoom(UserProfileModel user) async {
    return _repository.createChatRoom(user);
  }

  Future<String> findChatRoom(UserProfileModel user) async {
    return _repository.findChatRoom(user);
  }

  Future<void> sendMessage(String text) async {
    final user = ref.read(authRepo).user;
    state = AsyncValue.loading();
    state = await AsyncValue.guard(
      () async {
        final message = MessageModel(
          id: "",
          text: text,
          userId: user!.uid,
          createdAt: DateTime.now().millisecondsSinceEpoch,
        );
        _repository.sendMessage(
          chatRoomId: _chatId!,
          message: message,
        );
      },
    );
  }

  Future<void> deleteMessage({
    required String textId,
  }) async {
    _repository.deleteMessage(_chatId!, textId);
  }
}

class ChatIdNotifier extends StateNotifier<String> {
  ChatIdNotifier(super.state);

  void setId(String id) {
    state = id;
  }

  String getId() {
    return state;
  }
}

final chatIdProvider = StateNotifierProvider<ChatIdNotifier, void>(
  (ref) => ChatIdNotifier(""),
);

final messagesProvider =
    AsyncNotifierProvider.family<MessagesViewModel, void, String?>(
  () => MessagesViewModel(),
);

final chatProvider = StreamProvider.autoDispose
    .family<List<MessageModel>, String?>((ref, chatRoomId) {
  // A stream of results from an API
  final db = FirebaseFirestore.instance;
  return db
      .collection("chat_rooms")
      .doc(chatRoomId)
      .collection("texts")
      .orderBy("createdAt")
      .snapshots()
      .map(
        (event) => event.docs
            .map(
              (e) => MessageModel.fromJson(e.data()),
            )
            .toList()
            .reversed
            .toList(),
      );
});
