import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/view_models/timeline_view_model.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_post.dart';

class VideoTimelineScreen extends ConsumerStatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  ConsumerState createState() => VideoTimelineScreenState();
}

class VideoTimelineScreenState extends ConsumerState<VideoTimelineScreen> {
  int _itemCount = 4;
  final _pageController = PageController();
  final _scrollDuration = Duration(milliseconds: 250);
  final _scrollCurve = Curves.linear;

  void _onPageChanged(int page) {
    _pageController.animateToPage(
      page,
      duration: _scrollDuration,
      curve: _scrollCurve,
    );
    if (page == _itemCount - 1) {
      _itemCount = _itemCount + 4;
      setState(() {});
    }
  }

  Future _onRefresh() {
    return Future.delayed(Duration(seconds: 5));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(timelineProvider).when(
          data: (data) => RefreshIndicator(
            displacement: 50,
            edgeOffset: 20,
            color: Theme.of(context).primaryColor,
            onRefresh: _onRefresh,
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: data.length,
              itemBuilder: (context, index) => VideoPost(index: index),
              onPageChanged: _onPageChanged,
            ),
          ),
          error: (error, stackTrace) => Center(
            child: Text(
              "Could not load videos \n$error",
              style: TextStyle(color: Colors.white),
            ),
          ),
          loading: () => Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
  }
}
