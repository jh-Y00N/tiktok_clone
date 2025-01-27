import 'package:flutter/material.dart';
import 'package:tiktok_clone/features/videos/models/playback_config_model.dart';
import 'package:tiktok_clone/features/videos/repos/video_playback_config_repo.dart';

class PlaybackConfigVm extends ChangeNotifier {
  PlaybackConfigVm(this._repository);

  final VideoPlaybackConfigRepo _repository;
  late final PlaybackConfigModel _model = PlaybackConfigModel(
    isMuted: _repository.isMuted(),
    isAutoplay: _repository.isAutoplay(),
  );

  bool get isMuted => _model.isMuted;
  bool get isAutoplay => _model.isAutoplay;

  void setMuted(bool value) {
    _repository.setMuted(value);
    _model.isMuted = value;
    notifyListeners();
  }

  void setAutoplay(bool value) {
    _repository.setAutoplay(value);
    _model.isAutoplay = value;
    notifyListeners();
  }
}
