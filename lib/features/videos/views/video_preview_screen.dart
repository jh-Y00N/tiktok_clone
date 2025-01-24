import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewScreen extends StatefulWidget {
  const VideoPreviewScreen({
    super.key,
    required this.video,
    required this.isPicked,
  });

  final XFile video;
  final bool isPicked;

  @override
  State<VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  bool _savedVideo = false;

  late final VideoPlayerController _videoPlayerController;

  Future<void> _initVideo() async {
    _videoPlayerController =
        VideoPlayerController.file(File(widget.video.path));
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();
    setState(() {});
  }

  Future<String> fixFilePath(String path) async {
    final tempFile = File(path);
    final fileContent = await tempFile.readAsBytes();

    final newFilePath = path.replaceFirst(".temp", ".mp4");
    final newFile = File(newFilePath);
    await newFile.writeAsBytes(fileContent);
    return newFilePath;
  }

  Future<void> _saveToGallery() async {
    if (_savedVideo) return;

    String newFilePath;
    if (widget.video.path.endsWith(".temp")) {
      newFilePath = await fixFilePath(widget.video.path);
    } else {
      newFilePath = widget.video.path;
    }

    await GallerySaver.saveVideo(
      newFilePath,
      albumName: "TikTok Clone",
    );
    _savedVideo = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Preview video"),
        actions: [
          if (!widget.isPicked)
            IconButton(
              onPressed: _saveToGallery,
              icon: FaIcon(
                _savedVideo
                    ? FontAwesomeIcons.check
                    : FontAwesomeIcons.download,
              ),
            ),
        ],
      ),
      body: _videoPlayerController.value.isInitialized
          ? VideoPlayer(_videoPlayerController)
          : null,
    );
  }
}
