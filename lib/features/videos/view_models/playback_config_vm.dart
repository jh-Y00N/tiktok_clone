import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/playback_config_model.dart';
import 'package:tiktok_clone/features/videos/repos/video_playback_config_repo.dart';

class PlaybackConfigVm extends Notifier<PlaybackConfigModel> {
  PlaybackConfigVm(this._repository);

  final VideoPlaybackConfigRepo _repository;

  void setMuted(bool value) {
    _repository.setMuted(value);
    state = PlaybackConfigModel(isMuted: value, isAutoplay: state.isAutoplay);
  }

  void setAutoplay(bool value) {
    _repository.setAutoplay(value);
    state = PlaybackConfigModel(isMuted: state.isMuted, isAutoplay: value);
  }

  @override
  PlaybackConfigModel build() {
    return PlaybackConfigModel(
      isMuted: _repository.isMuted(),
      isAutoplay: _repository.isAutoplay(),
    );
  }
}

final playbackConfigProvider =
    NotifierProvider<PlaybackConfigVm, PlaybackConfigModel>(
  () => throw UnimplementedError(),
);
