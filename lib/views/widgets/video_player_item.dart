import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;
  bool videoPause = false;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
        videoPlayerController.setLooping(true);
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        videoPlayerController.pause();
        setState(() {
          videoPause = true;
        });
      },
      child: Stack(children: [
        Container(
          width: size.width,
          height: size.height,
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: VideoPlayer(videoPlayerController),
        ),
        if (videoPause) ...[
          Center(
            child: IconButton(
              onPressed: () {
                videoPlayerController.play();
                setState(() {
                  videoPause = false;
                });
              },
              icon: const Icon(Icons.play_arrow,color: Colors.white,size: 60,),
            ),
          )
        ]
      ]),
    );
  }
}
