import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room_model.dart';
import 'package:tiktok_clone/features/inbox/view_models/chat_list_view_model.dart';
import 'package:tiktok_clone/features/inbox/views/chat_detail_screen.dart';
import 'package:tiktok_clone/features/inbox/views/select_user_view.dart';

class ChatsScreen extends ConsumerStatefulWidget {
  static String routeUrl = "/chats";
  static String routeName = "chats";

  const ChatsScreen({super.key});

  @override
  ConsumerState createState() => ChatsScreenState();
}

class ChatsScreenState extends ConsumerState<ChatsScreen> {
  final _key = GlobalKey<AnimatedListState>();
  int itemLength = 0;

  void _addItem() {
    // if (_key.currentState != null) {
    //   _key.currentState!.insertItem(itemLength++);
    // }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SelectUserView(),
      ),
    );
  }

  void _deleteItem(int index) {
    if (_key.currentState != null) {
      _key.currentState!.removeItem(
        index,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: Container(color: Colors.red, child: _makeTile(index)),
        ),
      );
    }
    itemLength--;
  }

  void _onChatTap(ChatRoomModel chat) {
    context.pushNamed(
      ChatDetailScreen.routeName,
      pathParameters: {"chatId": chat.id},
      extra: {"chatId": chat.id, "user": chat.user},
    );
  }

  ListTile _makeTile(int index) {
    return ListTile(
      onLongPress: () => _deleteItem(index),
      // onTap: () => _onChatTap(index),
      leading: CircleAvatar(
        radius: 30,
        foregroundImage: NetworkImage(
          "https://as2.ftcdn.net/v2/jpg/03/39/59/03/1000_F_339590393_XJuAY32X8cwqpVcm2mnhTVfWM368Q78n.jpg",
        ),
        child: Text("id"),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "user id $index",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(
            "2:16 PM",
            style: TextStyle(
              fontSize: Sizes.size12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
      subtitle: Text("Say hi to me"),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatList = ref.watch(chatListProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text("Direct messages"),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: FaIcon(FontAwesomeIcons.plus),
          ),
        ],
      ),
      body: chatList.when(
        data: (data) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final chat = data[index];
              return ListTile(
                onLongPress: () => _deleteItem(index),
                onTap: () => _onChatTap(chat),
                leading: CircleAvatar(
                  radius: 30,
                  foregroundImage: NetworkImage(
                    "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-jh.firebasestorage.app/o/avatars%2F${chat.user.uid}?alt=media",
                  ),
                  child: Text("?"),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      chat.user.name,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      DateFormat("yMd").format(
                        DateTime.fromMillisecondsSinceEpoch(
                          chat.texts.last.createdAt,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: Sizes.size12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                subtitle: Text(chat.texts.last.text),
              );
            },
            itemCount: data.length,
          );
          // return AnimatedList(
          //   key: _key,
          //   padding: EdgeInsets.symmetric(vertical: Sizes.size10),
          //   itemBuilder: (context, index, animation) {
          //     print(data[index]);
          //     return FadeTransition(
          //       key: UniqueKey(),
          //       opacity: animation,
          //       child: SizeTransition(
          //         sizeFactor: animation,
          //         child: _makeTile(index),
          //       ),
          //     );
          //   },
          // );
        },
        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
        ),
        loading: () => Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}
