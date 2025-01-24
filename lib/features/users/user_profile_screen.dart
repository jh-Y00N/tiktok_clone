import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/settings/settings_screen.dart';
import 'package:tiktok_clone/features/users/widgets/persistent_tab_bar.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key, required this.username});

  final String username;

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  void _onGearPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SettingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  title: Text(widget.username),
                  actions: [
                    IconButton(
                      onPressed: _onGearPressed,
                      icon: FaIcon(
                        FontAwesomeIcons.gear,
                        size: Sizes.size20,
                      ),
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Gaps.v20,
                      CircleAvatar(
                        radius: 50,
                        foregroundImage: NetworkImage(
                          "https://as2.ftcdn.net/v2/jpg/03/39/59/03/1000_F_339590393_XJuAY32X8cwqpVcm2mnhTVfWM368Q78n.jpg",
                        ),
                      ),
                      Gaps.v20,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "@${widget.username}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          Gaps.h5,
                          FaIcon(
                            FontAwesomeIcons.solidCircleCheck,
                            color: Colors.blue.shade500,
                            size: Sizes.size16,
                          ),
                        ],
                      ),
                      Gaps.v24,
                      SizedBox(
                        height: Sizes.size48,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "97",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Gaps.v2,
                                Text(
                                  "Following",
                                  style: TextStyle(color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                            VerticalDivider(
                              width: Sizes.size32,
                              thickness: Sizes.size1,
                              color: Colors.grey.shade400,
                              indent: Sizes.size14,
                              endIndent: Sizes.size14,
                            ),
                            Column(
                              children: [
                                Text(
                                  "10M",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Gaps.v2,
                                Text(
                                  "Followers",
                                  style: TextStyle(color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                            VerticalDivider(
                              width: Sizes.size32,
                              thickness: Sizes.size1,
                              color: Colors.grey.shade400,
                              indent: Sizes.size14,
                              endIndent: Sizes.size14,
                            ),
                            Column(
                              children: [
                                Text(
                                  "194.3M",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Gaps.v2,
                                Text(
                                  "Likes",
                                  style: TextStyle(color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Gaps.v14,
                      FractionallySizedBox(
                        widthFactor: 1 / 3,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: Sizes.size12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(Sizes.size4)),
                          ),
                          child: Text(
                            "Follow",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Gaps.v14,
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Sizes.size32,
                        ),
                        child: Text(
                          "All highlights and where to watch live",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Gaps.v14,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.link,
                            size: Sizes.size12,
                          ),
                          Gaps.h4,
                          Text(
                            "www.google.com",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Gaps.v20,
                    ],
                  ),
                ),
                SliverPersistentHeader(
                  delegate: PersistentTabBar(),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              children: [
                GridView.builder(
                  padding: EdgeInsets.zero,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: Sizes.size2,
                    mainAxisSpacing: Sizes.size2,
                    childAspectRatio: 9 / 14,
                  ),
                  itemBuilder: (context, index) => Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 9 / 14,
                        child: Image.network(
                          fit: BoxFit.cover,
                          "https://plus.unsplash.com/premium_photo-1736520566943-78675ec3f42e?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                        ),
                      ),
                    ],
                  ),
                  itemCount: 20,
                ),
                Container(),
              ],
            ),
          ),
          // child: CustomScrollView(
          //   slivers: [
          // SliverAppBar(
          //   // floating: true, // show app bar slowly when scroll down
          //   pinned: true, // show background color + titles always
          //   stretch: true,
          //   // snap: true, // show app bar immediately when scroll down
          //   collapsedHeight: 80,
          //   expandedHeight: 200,
          //   backgroundColor: Colors.blue,
          //   title: Text("title outside"),
          //   flexibleSpace: FlexibleSpaceBar(
          //     title: Text("title inside"),
          //     stretchModes: [
          //       StretchMode.blurBackground,
          //       StretchMode.zoomBackground,
          //     ],
          //     background: Image.network(
          //       "https://plus.unsplash.com/premium_photo-1736520566943-78675ec3f42e?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          // SliverFixedExtentList(
          //   delegate: SliverChildBuilderDelegate(
          //     childCount: 10,
          //     (context, index) => Container(
          //       color: Colors.amber[100 * (index % 9)],
          //       child: Align(
          //         alignment: Alignment.center,
          //         child: Text("item $index"),
          //       ),
          //     ),
          //   ),
          //   itemExtent: 100, // item height
          // ),
          // SliverPersistentHeader(
          //   delegate: CustomDelegate(),
          //   pinned: true,
          //   // floating: true, // app bar와 중첩됨
          // ),
          // SliverGrid(
          //   delegate: SliverChildBuilderDelegate(
          //     childCount: 50,
          //     (context, index) => Container(
          //       color: Colors.blue[100 * (index % 9)],
          //       child: Align(
          //         alignment: Alignment.center,
          //         child: Text("item $index"),
          //       ),
          //     ),
          //   ),
          //   gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          //     maxCrossAxisExtent: 100,
          //     mainAxisSpacing: Sizes.size20,
          //     crossAxisSpacing: Sizes.size20,
          //     childAspectRatio: 1,
          //   ),
          // ),
          //   ],
          // ),
        ),
      ),
    );
  }
}

// class CustomDelegate extends SliverPersistentHeaderDelegate {
//   @override
//   Widget build(
//     BuildContext context,
//     double shrinkOffset,
//     bool overlapsContent,
//   ) {
//     return Container(
//       color: Colors.indigo,
//       child: FractionallySizedBox(
//         heightFactor: 1,
//         child: Center(
//           child: Text("title"),
//         ),
//       ),
//     );
//   }

//   @override
//   double get maxExtent => 100;

//   @override
//   double get minExtent => 50;

//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
//     return false;
//   }
// }
