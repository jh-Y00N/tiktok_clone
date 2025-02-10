import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/repos/videos_repo.dart';

class TimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  List<VideoModel> _list = [];
  late final VideosRepo _repository;

  @override
  FutureOr<List<VideoModel>> build() async {
    _repository = ref.read(videosRepo);

    _list = await _fetchVideos();
    return _list;
  }

  Future<List<VideoModel>> _fetchVideos({
    int? lastItemCreatedAt,
  }) async {
    final result =
        await _repository.fetchVideos(lastItemCreatedAt: lastItemCreatedAt);
    final videos = result.docs
        .map((doc) => VideoModel.fromJson(json: doc.data(), videoId: doc.id));
    return videos.toList();
  }

  Future<void> fetchNextPage() async {
    final nextPage =
        await _fetchVideos(lastItemCreatedAt: _list.last.createdAt);
    state = AsyncValue.data([..._list, ...nextPage]);
  }

  Future<void> refresh() async {
    final videos = await _fetchVideos(lastItemCreatedAt: null);
    _list = videos;
    state = AsyncValue.data(videos);
  }

  void uploadVideo(String? title) async {
    state = AsyncValue.loading();
    await Future.delayed(Duration(seconds: 2));

    // final newVideo = VideoModel(title: "${DateTime.now()}", creatorUid: creatorUid, description: description, fileUrl: fileUrl, thumbnailUrl: thumbnailUrl, likes: likes, comments: comments, createdAt: createdAt);
    // _list = [..._list, newVideo];
    state = AsyncValue.data(_list);
  }
}

final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<VideoModel>>(
  () => TimelineViewModel(),
);
