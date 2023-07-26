import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class MyVideoWidget extends StatefulWidget {
  MyVideoWidget({Key? key, required this.videoUrl}) : super(key: key);
  final String videoUrl;

  @override
  State<MyVideoWidget> createState() => _MyVideoWidgetState();
}

class _MyVideoWidgetState extends State<MyVideoWidget> {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    // _initPlayer();
  }

  Future<void> _initPlayer() async {
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    await videoPlayerController.initialize();

    chewieController = ChewieController(
      materialProgressColors: ChewieProgressColors(
          playedColor: Colors.white, bufferedColor: Colors.black54),
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      looping: false,
      // additionalOptions: (context) {
      //   return <OptionItem>[
      //     OptionItem(
      //       onTap: () => debugPrint('Option 1 pressed!'),
      //       iconData: Icons.chat,
      //       title: 'Option 1',
      //     ),
      //     OptionItem(
      //       onTap: () => debugPrint('Option 2 pressed!'),
      //       iconData: Icons.share,
      //       title: 'Option 2',
      //     ),
      //   ];
      // },
    );
    initialized = true;
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !initialized
        ? FutureBuilder(
            future: _initPlayer(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                case ConnectionState.done:
                  return Chewie(
                    controller: chewieController!,
                  );

                default:
                  return Center(
                      child: CircularProgressIndicator(
                    color: Color.fromRGBO(9, 77, 61, 1),
                  ));
              }
            })
        : Chewie(
            controller: chewieController!,
          );
  }
}
