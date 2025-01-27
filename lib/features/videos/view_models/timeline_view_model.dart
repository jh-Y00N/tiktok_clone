import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';

class TimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  List<VideoModel> _list = [];

  @override
  FutureOr<List<VideoModel>> build() async {
    await Future.delayed(Duration(seconds: 5));
    return _list;
  }

  void uploadVideo() async {
    state = AsyncValue.loading();
    await Future.delayed(Duration(seconds: 2));

    final newVideo = VideoModel(title: "${DateTime.now()}");
    _list = [..._list, newVideo];
    state = AsyncValue.data(_list);
  }
}

final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<VideoModel>>(
  () => TimelineViewModel(),
);
