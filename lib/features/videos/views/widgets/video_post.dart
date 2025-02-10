import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/view_models/video_post_view_model.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_button.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_comments.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPost extends ConsumerStatefulWidget {
  const VideoPost({
    super.key,
    required this.index,
    required this.videoData,
  });

  final int index;
  final VideoModel videoData;

  @override
  ConsumerState createState() => VideoPostState();
}

class VideoPostState extends ConsumerState<VideoPost>
    with SingleTickerProviderStateMixin {
  bool _isPaused = false;
  bool _isLiked = false;
  int likeCount = 0;
  late bool _isCurrentMuted;
  bool _isDescriptionExpanded = false;
  final _animationDuration = Duration(milliseconds: 200);
  late final AnimationController _animationController;
  late final String description;
  late final VideoPlayerController _videoPlayerController;

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
      // if (ref.read(playbackConfigProvider).isAutoplay) {
      //   _videoPlayerController.play();
      // }
    }

    if (_videoPlayerController.value.isPlaying && info.visibleFraction == 0) {
      _onTogglePause();
    }
  }

  void _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(
        widget.videoData.fileUrl,
      ),
    );

    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    if (kIsWeb) {
      await _videoPlayerController.setVolume(0);
    }

    if (!mounted) return;
    // final isMuted = ref.read(playbackConfigProvider).isMuted;
    // _videoPlayerController.setVolume(isMuted ? 0 : 1);
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

  void _onLikeTap() async {
    await ref.read(videoPostProvider(widget.videoData.id).notifier).likeVideo();
    if (mounted) {
      setState(() {
        _isLiked = !_isLiked;
        if (_isLiked) {
          likeCount += 1;
        } else {
          likeCount -= 1;
        }
      });
    }
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

  void _onPlaybackConfigChanged() {
    if (!mounted) return;
    // final isMuted = ref.read(playbackConfigProvider).isMuted;
    // if (isMuted) {
    //   _videoPlayerController.setVolume(0);
    // } else {
    //   _videoPlayerController.setVolume(1);
    // }
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

    likeCount = widget.videoData.likes;
    description = widget.videoData.description;

    // context.read<PlaybackConfigVm>().addListener(_onPlaybackConfigChanged);
    // _isCurrentMuted = ref.read(playbackConfigProvider).isMuted;
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isLiked =
        ref.watch(videoPostProvider(widget.videoData.id).notifier).isLiked;
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
                : Image(
                    image: NetworkImage(widget.videoData.thumbnailUrl),
                    fit: BoxFit.cover,
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
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animationController.value,
                      child: child,
                    );
                  },
                  child: AnimatedOpacity(
                    opacity: _isPaused ? 0 : 1,
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
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: FaIcon(
                // ref.watch(playbackConfigProvider).isMuted
                false
                    ? FontAwesomeIcons.volumeOff
                    : FontAwesomeIcons.volumeHigh,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _isCurrentMuted = !_isCurrentMuted;
                });
                _onPlaybackConfigChanged();
              },
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "@${widget.videoData.creator}",
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
                    "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-jh.firebasestorage.app/o/avatars%2F${widget.videoData.creatorUid}?alt=media",
                  ),
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: _onLikeTap,
                  child: VideoButton(
                    icon: FontAwesomeIcons.solidHeart,
                    color: _isLiked
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    text: S.of(context).likeCount(likeCount),
                  ),
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: _onCommentsTap,
                  child: VideoButton(
                    icon: FontAwesomeIcons.solidComment,
                    color: Colors.white,
                    text: S.of(context).commentCount(widget.videoData.comments),
                  ),
                ),
                Gaps.v24,
                VideoButton(
                  icon: FontAwesomeIcons.share,
                  color: Colors.white,
                  text: "Share",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
