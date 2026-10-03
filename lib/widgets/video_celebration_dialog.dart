import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/milestone.dart';
import '../theme/app_colors.dart';
import 'svg_asset.dart';
import 'squishy_button.dart';

class VideoCelebrationDialog extends StatefulWidget {
  final Milestone milestone;
  final VoidCallback onClaim;

  const VideoCelebrationDialog({
    super.key,
    required this.milestone,
    required this.onClaim,
  });

  static Future<void> show(
    BuildContext context, {
    required Milestone milestone,
    required VoidCallback onClaim,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => VideoCelebrationDialog(
        milestone: milestone,
        onClaim: onClaim,
      ),
    );
  }

  @override
  State<VideoCelebrationDialog> createState() => _VideoCelebrationDialogState();
}

class _VideoCelebrationDialogState extends State<VideoCelebrationDialog> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      _controller = VideoPlayerController.asset(widget.milestone.videoAsset);
      await _controller!.initialize();
      await _controller!.setLooping(true);
      await _controller!.play();
      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      debugPrint('Error playing celebration video: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.snow,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.swan, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Video or Icon display
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: double.infinity,
                height: 200,
                color: const Color(0xFFFFF7ED),
                child: _isInitialized && _controller != null
                    ? AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      )
                    : Center(
                        child: SvgAsset(
                          assetName: widget.milestone.iconAsset,
                          width: 80,
                          height: 80,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // Milestone Title
            Text(
              widget.milestone.title.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'DINRoundPro',
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.streakOrange,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              widget.milestone.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'DINRoundPro',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.wolf,
              ),
            ),
            const SizedBox(height: 16),

            // Reward pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFBAE6FD), width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SvgAsset(assetName: 'freezed.svg', width: 22, height: 22),
                  const SizedBox(width: 8),
                  Text(
                    '+${widget.milestone.rewardFreezes} Streak Freeze Added!',
                    style: const TextStyle(
                      fontFamily: 'DINRoundPro',
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.eelBlue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Claim Reward Squishy Button
            SizedBox(
              width: double.infinity,
              child: SquishyButton(
                backgroundColor: AppColors.owlGreen,
                shadowColor: AppColors.owlGreenDeep,
                onPressed: () {
                  widget.onClaim();
                  Navigator.pop(context);
                },
                height: 54,
                child: const Text(
                  'CLAIM REWARD',
                  style: TextStyle(
                    fontFamily: 'DINRoundPro',
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
