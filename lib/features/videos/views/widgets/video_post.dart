import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_button.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_comments.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPost extends StatefulWidget {
  const VideoPost({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost>
    with SingleTickerProviderStateMixin {
  bool _isPaused = false;
  bool _isDescriptionExpanded = false;
  // bool _autoMute = videoConfig.autoMute;
  // bool _autoMute = videoConfig.value;
  final _animationDuration = Duration(milliseconds: 200);
  late final AnimationController _animationController;
  final description =
      "super long description is shown and see more button would expanded the space to show all of it.";
  final VideoPlayerController _videoPlayerController =
      VideoPlayerController.networkUrl(
    Uri.parse(
      "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
    ),
  );

  void _onVideoChange() {
    if (_videoPlayerController.value.isInitialized) {
      if (_videoPlayerController.value.duration ==
          _videoPlayerController.value.position) {}
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;
    if (info.visibleFraction == 1 &&
        !_videoPlayerController.value.isPlaying &&
        !_isPaused) {
      _videoPlayerController.play();
    }

    if (_videoPlayerController.value.isPlaying && info.visibleFraction == 0) {
      _onTogglePause();
    }
  }

  void _initVideoPlayer() async {
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    if (kIsWeb) {
      await _videoPlayerController.setVolume(0);
    }
    setState(() {});
    _videoPlayerController.addListener(_onVideoChange);
  }

  void _onTogglePause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _animationController.reverse();
    } else {
      _videoPlayerController.play();
      _animationController.forward();
    }
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _onCommentsTap() async {
    if (_videoPlayerController.value.isPlaying) _onTogglePause();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VideoComments(),
    );
    _onTogglePause();
  }

  void _onDescriptionTap() {
    setState(() {
      _isDescriptionExpanded = !_isDescriptionExpanded;
    });
  }

  @override
  void initState() {
    super.initState();

    _initVideoPlayer();

    _animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.5,
      value: 1.5,
      duration: _animationDuration,
    );

    // _animationController.addListener(() {
    //   setState(() {});
    // });

    // videoConfig.addListener(
    //   () {
    //     setState(() {
    //       // _autoMute = videoConfig.autoMute;
    //       _autoMute = videoConfig.value;
    //     });
    //   },
    // );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final videoConfig =
    //     context.dependOnInheritedWidgetOfExactType<VideoConfig>();
    // print(videoConfig?.autoMute);
    return VisibilityDetector(
      onVisibilityChanged: _onVisibilityChanged,
      key: Key("${widget.index}"),
      child: Stack(
        children: [
          Positioned.fill(
            child: _videoPlayerController.value.isInitialized
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      height: _videoPlayerController.value.size.height,
                      width: _videoPlayerController.value.size.width,
                      child: VideoPlayer(_videoPlayerController),
                    ),
                  )
                : Container(
                    color: Colors.black,
                  ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: _onTogglePause,
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                // child: Transform.scale(
                //   scale: _animationController.value,
                //   child: AnimatedOpacity(
                //     opacity: isPaused ? 1 : 0,
                //     duration: _animationDuration,
                //     child: FaIcon(
                //       FontAwesomeIcons.play,
                //       color: Colors.white,
                //       size: Sizes.size52,
                //     ),
                //   ),
                // ),
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animationController.value,
                      child: child,
                    );
                  },
                  child: AnimatedOpacity(
                    opacity: _isPaused ? 1 : 0,
                    duration: _animationDuration,
                    child: FaIcon(
                      FontAwesomeIcons.play,
                      color: Colors.white,
                      size: Sizes.size52,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Positioned(
          //   top: 40,
          //   left: 20,
          //   child: IconButton(
          //     icon: FaIcon(
          //       // VideoConfigData.of(context).autoMute
          //       // _autoMute
          //       context.watch<VideoConfig>().isMuted
          //           ? FontAwesomeIcons.volumeOff
          //           : FontAwesomeIcons.volumeHigh,
          //       color: Colors.white,
          //     ),
          //     onPressed: () {
          //       // VideoConfigData.of(context).toggleMute();
          //       // videoConfig.toggleMute();
          //       // videoConfig.value = !videoConfig.value;
          //       context.read<VideoConfig>().toggleMute();
          //     },
          //   ),
          // ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "@id",
                  style: TextStyle(
                    fontSize: Sizes.size20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gaps.v10,
                GestureDetector(
                  onTap: description.length > 25 ? _onDescriptionTap : null,
                  child: FittedBox(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 40 - 36 - 20,
                      child: Text(
                        _isDescriptionExpanded
                            ? description
                            : description.length > 25
                                ? "${description.substring(0, 24)}...See more"
                                : description,
                        style: TextStyle(
                          fontSize: Sizes.size16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  foregroundImage: NetworkImage(
                    "https://as2.ftcdn.net/v2/jpg/03/39/59/03/1000_F_339590393_XJuAY32X8cwqpVcm2mnhTVfWM368Q78n.jpg",
                  ),
                  child: Text("id"),
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: () => _onCommentsTap(),
                  child: VideoButton(
                    icon: FontAwesomeIcons.solidHeart,
                    text: S.of(context).likeCount(479895),
                  ),
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: _onCommentsTap,
                  child: VideoButton(
                    icon: FontAwesomeIcons.solidComment,
                    text: S.of(context).commentCount(225934),
                  ),
                ),
                Gaps.v24,
                VideoButton(icon: FontAwesomeIcons.share, text: "Share"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
