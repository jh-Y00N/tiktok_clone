import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/videos/repos/videos_repo.dart';

class VideoPostViewModel extends FamilyAsyncNotifier<bool, String> {
  late final VideosRepo _repository;
  late final String _videoId;
  late bool isLiked;

  @override
  FutureOr<bool> build(String arg) async {
    _repository = ref.read(videosRepo);
    _videoId = arg;
    isLiked = false;
    isLiked = await isLikedVideo();
    state = AsyncData(isLiked);
    return isLiked;
  }

  Future<void> likeVideo() async {
    final user = ref.read(authRepo).user;
    await _repository.likeVideo(_videoId, user!.uid);
    state = AsyncData(!(state.value ?? false));
    isLiked = !isLiked;
  }

  Future<bool> isLikedVideo() async {
    final user = ref.read(authRepo).user;
    return await _repository.isLiked(_videoId, user!.uid);
  }
}

final videoPostProvider =
    AsyncNotifierProvider.family<VideoPostViewModel, bool, String>(
  () => VideoPostViewModel(),
);
