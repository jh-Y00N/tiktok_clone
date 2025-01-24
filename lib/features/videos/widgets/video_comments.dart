import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/utils.dart';

class VideoComments extends StatefulWidget {
  const VideoComments({super.key});

  @override
  State<VideoComments> createState() => _VideoCommentsState();
}

class _VideoCommentsState extends State<VideoComments> {
  bool _isWriting = false;
  final _scrollController = ScrollController();

  void _onStartWriting() {
    setState(() {
      _isWriting = true;
    });
  }

  void _onClosePressed() {
    Navigator.of(context).pop();
  }

  void _stopWriting() {
    FocusScope.of(context).unfocus();
    setState(() {
      _isWriting = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.8,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(Sizes.size14)),
      clipBehavior: Clip.hardEdge,
      child: Scaffold(
        backgroundColor: isDarkMode(context) ? null : Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: isDarkMode(context) ? null : Colors.grey.shade50,
          title: Text(S.of(context).commentTitle(232423, 232423)),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: _onClosePressed,
              icon: FaIcon(FontAwesomeIcons.xmark),
            ),
          ],
        ),
        body: GestureDetector(
          onTap: _stopWriting,
          child: Stack(
            children: [
              Scrollbar(
                controller: _scrollController,
                child: ListView.separated(
                  controller: _scrollController,
                  separatorBuilder: (context, index) => Gaps.v20,
                  padding: EdgeInsets.only(
                    left: Sizes.size16,
                    right: Sizes.size16,
                    bottom: Sizes.size16 + Sizes.size96,
                  ),
                  itemBuilder: (context, index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor:
                              isDarkMode(context) ? Colors.grey.shade500 : null,
                          child: Text("id"),
                        ),
                        Gaps.h10,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "commenter",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Sizes.size14,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              Gaps.v3,
                              Text("long comment\nlong comment"),
                            ],
                          ),
                        ),
                        Gaps.h10,
                        Column(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.heart,
                              size: Sizes.size20,
                              color: Colors.grey.shade500,
                            ),
                            Gaps.v2,
                            Text(
                              "52.5K",
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                  itemCount: 10,
                ),
              ),
              Positioned(
                bottom: 0,
                width: size.width,
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  padding: EdgeInsets.only(
                    left: Sizes.size16,
                    right: Sizes.size16,
                    top: Sizes.size10,
                    bottom: Sizes.size48,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.grey.shade500,
                        foregroundColor: Colors.white,
                        child: Text("Me"),
                      ),
                      Gaps.h10,
                      Expanded(
                        child: SizedBox(
                          height: Sizes.size44,
                          child: TextField(
                            onTap: _onStartWriting,
                            cursorColor: Theme.of(context).primaryColor,
                            textInputAction: TextInputAction.newline,
                            expands: true,
                            minLines: null,
                            maxLines: null,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(Sizes.size12),
                                borderSide: BorderSide.none,
                              ),
                              hintText: "Write a comment...",
                              fillColor: isDarkMode(context)
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade200,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: Sizes.size12,
                                horizontal: Sizes.size10,
                              ),
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(right: Sizes.size14),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.at,
                                      color: isDarkMode(context)
                                          ? Colors.grey.shade500
                                          : Colors.grey.shade900,
                                    ),
                                    Gaps.h14,
                                    FaIcon(
                                      FontAwesomeIcons.gift,
                                      color: isDarkMode(context)
                                          ? Colors.grey.shade500
                                          : Colors.grey.shade900,
                                    ),
                                    Gaps.h14,
                                    FaIcon(
                                      FontAwesomeIcons.faceSmile,
                                      color: isDarkMode(context)
                                          ? Colors.grey.shade500
                                          : Colors.grey.shade900,
                                    ),
                                    if (_isWriting) ...[
                                      Gaps.h14,
                                      GestureDetector(
                                        onTap: _stopWriting,
                                        child: FaIcon(
                                          FontAwesomeIcons.circleArrowUp,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
