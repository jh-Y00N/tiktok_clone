import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/message_model.dart';
import 'package:tiktok_clone/features/inbox/view_models/messages_view_model.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  static String routeUrl = ":chatId";
  static String routeName = "chatDetail";

  const ChatDetailScreen({
    super.key,
    required this.chatId,
    required this.user,
  });

  final String chatId;
  final UserProfileModel user;

  @override
  ConsumerState createState() => ChatDetailScreenState();
}

class ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final _textEditingController = TextEditingController();

  void _onSendPressed() async {
    final text = _textEditingController.text;
    if (text == "") return;

    ref.read(messagesProvider(widget.chatId).notifier).sendMessage(text);

    _textEditingController.text = "";
  }

  void _onLongPress(MessageModel message) {
    message.text = "[deleted]";
    ref
        .read(messagesProvider(widget.chatId).notifier)
        .deleteMessage(textId: message.id);
    setState(() {});
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(messagesProvider(widget.chatId)).isLoading;
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          horizontalTitleGap: Sizes.size8,
          contentPadding: EdgeInsets.zero,
          leading: Stack(
            children: [
              CircleAvatar(
                radius: Sizes.size24,
                foregroundImage: NetworkImage(
                  "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-jh.firebasestorage.app/o/avatars%2F${widget.user.uid}?alt=media",
                ),
                child: Text("?"),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            widget.user.name,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text("Active now"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                FontAwesomeIcons.flag,
                color: Colors.black,
                size: Sizes.size20,
              ),
              Gaps.h32,
              FaIcon(
                FontAwesomeIcons.ellipsis,
                color: Colors.black,
                size: Sizes.size20,
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          ref.watch(chatProvider(widget.chatId)).when(
                data: (data) {
                  return ListView.separated(
                    reverse: true,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.only(
                      top: Sizes.size20,
                      bottom:
                          MediaQuery.of(context).padding.bottom + Sizes.size96,
                      left: Sizes.size14,
                      right: Sizes.size14,
                    ),
                    itemBuilder: (context, index) {
                      final isMine =
                          data[index].userId == ref.read(authRepo).user!.uid;
                      return GestureDetector(
                        onLongPress: () =>
                            isMine ? _onLongPress(data[index]) : null,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: isMine
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(Sizes.size14),
                              decoration: BoxDecoration(
                                color: isMine
                                    ? Colors.blue
                                    : Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(Sizes.size20),
                                  topRight: Radius.circular(Sizes.size20),
                                  bottomLeft: Radius.circular(
                                    isMine ? Sizes.size20 : Sizes.size5,
                                  ),
                                  bottomRight: Radius.circular(
                                    isMine ? Sizes.size5 : Sizes.size20,
                                  ),
                                ),
                              ),
                              child: Text(
                                data[index].text,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Sizes.size16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Gaps.v10,
                    itemCount: data.length,
                  );
                },
                error: (error, stackTrace) => Center(
                  child: Text(error.toString()),
                ),
                loading: () => Center(
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.black,
                  ),
                ),
              ),
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: BottomAppBar(
              color: Colors.grey.shade50,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: TextField(
                          onTapOutside: (event) =>
                              FocusScope.of(context).unfocus(),
                          controller: _textEditingController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(Sizes.size24),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Send a message...",
                            contentPadding: EdgeInsets.symmetric(
                              vertical: Sizes.size12,
                              horizontal: Sizes.size10,
                            ),
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.faceLaugh,
                                  color: Colors.grey.shade900,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Gaps.h20,
                    IconButton(
                      icon: FaIcon(
                        isLoading
                            ? FontAwesomeIcons.hourglass
                            : FontAwesomeIcons.paperPlane,
                      ),
                      onPressed: isLoading ? null : _onSendPressed,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
