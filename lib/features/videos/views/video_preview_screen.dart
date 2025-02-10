import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/view_models/upload_video_view_model.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewScreen extends ConsumerStatefulWidget {
  const VideoPreviewScreen({
    super.key,
    required this.video,
    required this.isPicked,
  });

  final XFile video;
  final bool isPicked;

  @override
  ConsumerState createState() => VideoPreviewScreenState();
}

class VideoPreviewScreenState extends ConsumerState<VideoPreviewScreen> {
  bool _savedVideo = false;
  String? title;
  String? description;

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

  void _onUploadPressed() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) => title = value,
              decoration: InputDecoration(
                hintText: 'title',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ),
            Gaps.v16,
            TextField(
              onChanged: (value) => description = value,
              decoration: InputDecoration(
                hintText: 'description',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ),
            Gaps.v28,
            GestureDetector(
              onTap: ref.read(uploadVideoProvider).isLoading
                  ? null
                  : () {
                      ref.read(uploadVideoProvider.notifier).uploadVideo(
                            File(widget.video.path),
                            title,
                            description,
                            context,
                          );

                      if (!ref.read(uploadVideoProvider).isLoading) {
                        context.pop();
                        context.go("/home");
                      }
                    },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: Sizes.size16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Sizes.size5),
                  color: Theme.of(context).primaryColor,
                ),
                child: ref.watch(uploadVideoProvider).isLoading
                    ? Text(
                        "Upload",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : CircularProgressIndicator.adaptive(
                        backgroundColor: Colors.white,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
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
          IconButton(
            onPressed: ref.watch(uploadVideoProvider).isLoading
                ? () {}
                : _onUploadPressed,
            icon: ref.watch(uploadVideoProvider).isLoading
                ? CircularProgressIndicator.adaptive()
                : FaIcon(FontAwesomeIcons.cloudArrowUp),
          ),
        ],
      ),
      body: _videoPlayerController.value.isInitialized
          ? VideoPlayer(_videoPlayerController)
          : null,
    );
  }
}
