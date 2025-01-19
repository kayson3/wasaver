import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';

class StatusVideo extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final String videoSrc;
  final double? aspectRatio;

  const StatusVideo({
    required this.videoPlayerController,
    this.looping = false,
    required this.videoSrc,
    this.aspectRatio,
    super.key,
  });

  @override
  _StatusVideoState createState() => _StatusVideoState();
}

class _StatusVideoState extends State<StatusVideo> {
  ChewieController? _chewieController;

  @override
  initState() {
    super.initState();
    getAspectRation();
  }

  getAspectRation() async {
    if (widget.videoPlayerController.value.isInitialized) {
      if (kDebugMode) {
        print("initialized");
      }
      _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        autoInitialize: true,
        looping: widget.looping,
        allowFullScreen: true,
        aspectRatio: widget.aspectRatio ??
            widget.videoPlayerController.value.aspectRatio,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(errorMessage),
          );
        },
      );
    } else {
      if (kDebugMode) {
        print("not initialized");
      }
      await widget.videoPlayerController.initialize();
      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: widget.videoPlayerController,
          autoInitialize: true,
          looping: widget.looping,
          allowFullScreen: true,
          aspectRatio: widget.aspectRatio ??
              widget.videoPlayerController.value.aspectRatio,
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(errorMessage),
            );
          },
        );
      });
    }

    if (kDebugMode) {
      print("aspect ration: ${widget.videoPlayerController.value.aspectRatio}");
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (_chewieController == null) {
    //   getAspectRation();
    // }
    return Container(
      padding: const EdgeInsets.only(top: 0),
      child: Hero(
        tag: widget.videoSrc,
        child: _chewieController != null &&
                widget.videoPlayerController.value.isInitialized
            ? Chewie(
                controller: _chewieController!,
              )
            : const Center(
                child: SpinKitSpinningLines(
                color: Colors.white,
              )),
      ),
    );
  }

  @override
  void dispose() async {
    print('disposing');
    await widget.videoPlayerController.pause();
    // _chewieController?.pause();
    super.dispose();
  }
}
