import 'package:shared_preferences/shared_preferences.dart';

class VideoPlaybackConfigRepo {
  static const String _isAutoplay = "isAutoplay";
  static const String _isMuted = "isMuted";

  VideoPlaybackConfigRepo(this._preferences);

  final SharedPreferences _preferences;

  Future<void> setMuted(bool value) async {
    _preferences.setBool(_isMuted, value);
  }

  Future<void> setAutoplay(bool value) async {
    _preferences.setBool(_isAutoplay, value);
  }

  bool isMuted() {
    return _preferences.getBool(_isMuted) ?? false;
  }

  bool isAutoplay() {
    return _preferences.getBool(_isAutoplay) ?? false;
  }
}
