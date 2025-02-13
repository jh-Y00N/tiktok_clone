import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room_model.dart';
import 'package:tiktok_clone/features/inbox/repos/messages_repo.dart';

class ChatListViewModel extends AsyncNotifier<List<ChatRoomModel>> {
  late MessagesRepo _repository;

  @override
  FutureOr<List<ChatRoomModel>> build() async {
    _repository = ref.read(messagesRepo);
    return await _repository.getChats();
  }
}

final chatListProvider =
    AsyncNotifierProvider<ChatListViewModel, List<ChatRoomModel>>(
  () => ChatListViewModel(),
);
