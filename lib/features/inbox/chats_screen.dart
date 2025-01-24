import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/chat_detail_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final _key = GlobalKey<AnimatedListState>();
  int itemLength = 0;

  void _addItem() {
    if (_key.currentState != null) {
      _key.currentState!.insertItem(itemLength++);
    }
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

  void _onChatTap(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(chatId: "$index"),
      ),
    );
  }

  ListTile _makeTile(int index) {
    return ListTile(
      onLongPress: () => _deleteItem(index),
      onTap: () => _onChatTap(index),
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
      body: AnimatedList(
        key: _key,
        padding: EdgeInsets.symmetric(vertical: Sizes.size10),
        itemBuilder: (context, index, animation) {
          return FadeTransition(
            key: UniqueKey(),
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              child: _makeTile(index),
            ),
          );
        },
      ),
    );
  }
}
