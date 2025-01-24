import 'package:flutter/material.dart';

// using InheritedWidget
// class VideoConfigData extends InheritedWidget {
//   const VideoConfigData({
//     super.key,
//     required super.child,
//     required this.autoMute,
//     required this.toggleMute,
//   });

//   final bool autoMute;
//   final void Function() toggleMute;

//   static VideoConfigData of(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<VideoConfigData>()!;
//   }

//   @override
//   bool updateShouldNotify(covariant InheritedWidget oldWidget) {
//     return true;
//   }
// }

// using StatefulWidget to access and modify InheritedWidget
// class VideoConfig extends StatefulWidget {
//   const VideoConfig({super.key, required this.child});

//   final Widget child;

//   @override
//   State<VideoConfig> createState() => _VideoConfigState();
// }

// class _VideoConfigState extends State<VideoConfig> {
//   bool autoMute = true;

//   void toggleMute() {
//     setState(() {
//       autoMute = !autoMute;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return VideoConfigData(
//       autoMute: autoMute,
//       toggleMute: toggleMute,
//       child: widget.child,
//     );
//   }
// }

// // for multiple values
// class VideoConfig extends ChangeNotifier {
//   bool autoMute = false;

//   void toggleMute() {
//     autoMute = !autoMute;
//     notifyListeners();
//   }
// }

// // final videoConfig = VideoConfig();

// // for one value
// final videoConfig = ValueNotifier(false);

// using Provider
class VideoConfig extends ChangeNotifier {
  bool isMuted = false;
  bool isAutoplay = false;

  void toggleMute() {
    isMuted = !isMuted;
    notifyListeners();
  }

  void toggleAutoplay() {
    isAutoplay = !isAutoplay;
    notifyListeners();
  }
}
