import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/inbox/view_models/messages_view_model.dart';
import 'package:tiktok_clone/features/inbox/view_models/user_list_view_model.dart';
import 'package:tiktok_clone/features/inbox/views/chat_detail_screen.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class SelectUserView extends ConsumerStatefulWidget {
  const SelectUserView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SelectUserViewState();
}

class SelectUserViewState extends ConsumerState {
  Future<void> _onUserTap(UserProfileModel user) async {
    String chatId =
        await ref.read(messagesProvider(null).notifier).findChatRoom(user);
    if (chatId == "") {
      chatId =
          await ref.read(messagesProvider(null).notifier).createChatRoom(user);
    }

    if (mounted) {
      context.pushReplacementNamed(
        ChatDetailScreen.routeName,
        pathParameters: {"chatId": chatId},
        extra: {"user": user, "chatId": chatId},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(userListProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("New message"),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Text(
                "Send to",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            users.when(
              data: (data) {
                return Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final user = data[index];
                      return ListTile(
                        onTap: () => _onUserTap(user),
                        title: Text(user.name),
                        leading: user.hasAvatar
                            ? CircleAvatar(
                                foregroundImage: NetworkImage(
                                  "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-jh.firebasestorage.app/o/avatars%2F${user.uid}?alt=media",
                                ),
                              )
                            : CircleAvatar(
                                child: Text("?"),
                              ),
                      );
                    },
                    itemCount: data.length,
                  ),
                );
              },
              error: (error, stackTrace) => Center(
                child: Text(error.toString()),
              ),
              loading: () => Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
