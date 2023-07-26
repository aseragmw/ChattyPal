import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatty_pal/screens/video_widget.dart';
import 'package:chatty_pal/services/Firestore/firestore_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:photo_view/photo_view.dart';
import 'package:just_audio/just_audio.dart';

Widget customTextField(
        Function(String) onChanged,
        TextInputType? inputType,
        bool obsecureText,
        TextEditingController controller,
        String label,
        Widget suffixIcon,
        double screenWidth,
        Color enabledBorderColor,
        Color focusedBorderColor) =>
    TextField(
        onChanged: onChanged,
        obscureText: obsecureText,
        keyboardType: inputType,
        controller: controller,
        autocorrect: false,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          suffixIconColor: Colors.black45,
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: enabledBorderColor, width: 2)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: focusedBorderColor)),
          label: Text(label),
          labelStyle: TextStyle(
              fontSize: screenWidth / 23,
              color: enabledBorderColor,
              fontWeight: FontWeight.w500),
        ));

Widget customButton(Color color, Color textColor, String title,
        Function() onPressed, double screenWidth, double screenHeight) =>
    Container(
      height: screenHeight / 15,
      width: screenWidth,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), color: color),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(color: textColor),
        ),
      ),
    );

void showCustomDialog(BuildContext context, String dialogTitle,
        String dialogDescription, List<Widget> actions) =>
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
          title: Text(dialogTitle),
          content: Text(dialogDescription),
          actions: actions),
    );

Widget chatListTile(Function() onTap, String tileText) => Slidable(
    startActionPane: ActionPane(
      // A motion is a widget used to control how the pane animates.
      motion: const ScrollMotion(),

      // A pane can dismiss the Slidable.
      dismissible: DismissiblePane(onDismissed: () {}),

      // All actions are defined in the children parameter.
      children: [
        // A SlidableAction can have an icon and/or a label.
        SlidableAction(
          onPressed: (context) {},
          backgroundColor: Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
        SlidableAction(
          onPressed: (context) {},
          backgroundColor: Color(0xFF21B7CA),
          foregroundColor: Colors.white,
          icon: Icons.share,
          label: 'Share',
        ),
      ],
    ),
    child: ListTile(
      onTap: onTap,
      leading: Text(tileText),
    ));

Widget recievedMessage(
    BuildContext context,
    String fromId,
    String toId,
    DateTime timeStamp,
    double screenWidth,
    double screenHeight,
    String message) {
  return InkWell(
    onLongPress: () {
      showMessageSettings(context, fromId, toId, timeStamp);
    },
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    message,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 2.0, // soften the shadow
                          spreadRadius: 1.0,
                          offset: Offset(5, 5))
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                        bottomLeft: Radius.circular(50))),
              ),
            ),
          ],
        ),
        SizedBox(
          height: screenHeight / 60,
        ),
      ],
    ),
  );
}

Widget sentMessage(
    BuildContext context,
    String fromId,
    String toId,
    DateTime timeStamp,
    double screenWidth,
    double screenHeight,
    String message) {
  return InkWell(
    onLongPress: () {
      showMessageSettings(context, fromId, toId, timeStamp);
    },
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    message,
                    style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white24,
                          blurRadius: 2.0, // soften the shadow
                          spreadRadius: 1.0,
                          offset: Offset(-5, 5))
                    ],
                    color: Color.fromRGBO(9, 77, 61, 0.71),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                        bottomLeft: Radius.circular(50))),
              ),
            ),
          ],
        ),
        SizedBox(
          height: screenHeight / 60,
        ),
      ],
    ),
  );
}

Widget recievedImage(
    BuildContext context,
    String fromId,
    String toId,
    DateTime timeStamp,
    double screenWidth,
    double screenHeight,
    String imgUrl) {
  return InkWell(
    onLongPress: () {
      showMessageSettings(context, fromId, toId, timeStamp);
    },
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                width: screenHeight / screenWidth * 150,
                height: screenHeight / screenWidth * 150,
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CachedNetworkImage(
                      imageUrl: imgUrl,
                      imageBuilder: (context, imageProvider) => PhotoView(
                        imageProvider: imageProvider,
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 2.0, // soften the shadow
                          spreadRadius: 1.0,
                          offset: Offset(5, 5))
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                        bottomLeft: Radius.circular(50))),
              ),
            ),
          ],
        ),
        SizedBox(
          height: screenHeight / 60,
        ),
      ],
    ),
  );
}

Widget sentImage(
    BuildContext context,
    String fromId,
    String toId,
    DateTime timeStamp,
    double screenWidth,
    double screenHeight,
    String imageUrl) {
  return InkWell(
    onLongPress: () {
      showMessageSettings(context, fromId, toId, timeStamp);
    },
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                width: screenHeight / screenWidth * 150,
                height: screenHeight / screenWidth * 150,
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      imageBuilder: (context, imageProvider) => PhotoView(
                        imageProvider: imageProvider,
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white24,
                          blurRadius: 2.0, // soften the shadow
                          spreadRadius: 1.0,
                          offset: Offset(-5, 5))
                    ],
                    color: Color.fromRGBO(9, 77, 61, 0.71),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                        bottomLeft: Radius.circular(50))),
              ),
            ),
          ],
        ),
        SizedBox(
          height: screenHeight / 60,
        ),
      ],
    ),
  );
}



Widget sentVideo(
    BuildContext context,
    String fromId,
    String toId,
    DateTime timeStamp,
    double screenWidth,
    double screenHeight,
    String videoUrl) {
  return InkWell(
    onLongPress: () {
      showMessageSettings(context, fromId, toId, timeStamp);
    },
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                width: screenHeight / screenWidth * 150,
                height: screenHeight / screenWidth * 150,
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: MyVideoWidget(videoUrl: videoUrl)
                    ),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white24,
                          blurRadius: 2.0, // soften the shadow
                          spreadRadius: 1.0,
                          offset: Offset(-5, 5))
                    ],
                    color: Color.fromRGBO(9, 77, 61, 0.71),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                        bottomLeft: Radius.circular(50))),
              ),
            ),
          ],
        ),
        SizedBox(
          height: screenHeight / 60,
        ),
      ],
    ),
  );
}



Widget recievedVideo(
    BuildContext context,
    String fromId,
    String toId,
    DateTime timeStamp,
    double screenWidth,
    double screenHeight,
    String videoUrl) {
  return InkWell(
    onLongPress: () {
      showMessageSettings(context, fromId, toId, timeStamp);
    },
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                width: screenHeight / screenWidth * 150,
                height: screenHeight / screenWidth * 150,
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: MyVideoWidget(videoUrl: videoUrl)
                    ),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 2.0, // soften the shadow
                          spreadRadius: 1.0,
                          offset: Offset(5, 5))
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                        bottomLeft: Radius.circular(50))),
              ),
            ),
          ],
        ),
        SizedBox(
          height: screenHeight / 60,
        ),
      ],
    ),
  );
}


Widget sentAudio(BuildContext context, String fromId, String toId,
    DateTime timeStamp, String audioUrl) {
  return InkWell(
    onLongPress: () {
      showMessageSettings(context, fromId, toId, timeStamp);
    },
    child: Container(
      // width: screenHeight / screenWidth * 150,
      // height: screenHeight / screenWidth * 150,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: AudioWidget(
          audioUrl: audioUrl,
        ),
      ),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.white24,
                blurRadius: 2.0, // soften the shadow
                spreadRadius: 1.0,
                offset: Offset(-5, 5))
          ],
          color: Color.fromRGBO(9, 77, 61, 0.71),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
              bottomLeft: Radius.circular(50))),
    ),
  );
}

Widget recievedAudio(BuildContext context, String fromId, String toId,
    DateTime timeStamp, String audioUrl) {
  return InkWell(
    onLongPress: () {
      showMessageSettings(context, fromId, toId, timeStamp);
    },
    child: Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: AudioWidget(
          audioUrl: audioUrl,
        ),
      ),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 2.0, // soften the shadow
                spreadRadius: 1.0,
                offset: Offset(-5, 5))
          ],
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(50),
              bottomRight: Radius.circular(50),
              bottomLeft: Radius.circular(50))),
    ),
  );
}

void showChatSettings(context, String fromId, String toId) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.delete_forever),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Delete Chat'),
                    ],
                  ),
                  onTap: () async {
                    await FirestoreDatabase.deleteChat(fromId, toId);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      });
}

void showMessageSettings(
    context, String fromId, String toId, DateTime timeStamp) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  // leading: Icon(Icons.delete_forever),
                  title: Row(
                    children: [
                      Icon(Icons.delete_forever),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Delete Message'),
                    ],
                  ),
                  onTap: () async {
                    await FirestoreDatabase.deleteAMessage(
                        fromId, toId, timeStamp);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      });
}

class AudioWidget extends StatefulWidget {
  AudioWidget({super.key, this.audioUrl});
  final audioUrl;

  @override
  State<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  final player = AudioPlayer();

  Duration audioPlayerDuration = Duration.zero;
  Duration audioPlayerPosition = Duration.zero; //
  bool initialized = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initPlayer();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> initPlayer() async {
    try {
      audioPlayerDuration = await player.setUrl(widget.audioUrl) as Duration;
    initialized = true;
    } catch (e) {
      
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return !initialized
        ? FutureBuilder(
            future: initPlayer(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                case ConnectionState.active:
                  return StreamBuilder<Duration>(
                      stream: player.positionStream,
                      builder: (context, snapshot) {
                        Duration pos =
                            snapshot.hasData ? snapshot.data! : Duration.zero;
                        if (pos == audioPlayerDuration) {
                          player.seek(Duration.zero);
                          player.pause();
                        }
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () async {
                                  if (player.playing) {
                                    await player.stop();
                                  } else {
                                    await player.play();
                                  }
                                },
                                icon: !player.playing
                                    ? Icon(Icons.play_arrow)
                                    : Icon(Icons.stop)),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: ProgressBar(
                                timeLabelLocation: TimeLabelLocation.sides,
                                progress: pos,
                                total: audioPlayerDuration,
                                progressBarColor: Colors.grey,
                                baseBarColor: Colors.black.withOpacity(0.24),
                                bufferedBarColor:
                                    Colors.black.withOpacity(0.24),
                                thumbColor: Colors.black,
                                barHeight: 3.0,
                                thumbRadius: 5.0,
                                onSeek: (duration) async {
                                  await player.seek(duration);
                                },
                              ),
                            ),
                          ],
                        );
                      });

                default:
                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      color: Color.fromRGBO(9, 77, 61, 0.71),
                    ),
                  ));
              }
            },
          )
        : StreamBuilder<Duration>(
            stream: player.positionStream,
            builder: (context, snapshot) {
              Duration pos = snapshot.hasData ? snapshot.data! : Duration.zero;
              if (pos == audioPlayerDuration) {
                player.seek(Duration.zero);
                player.pause();
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () async {
                        if (player.playing) {
                          await player.stop();
                        } else {
                          await player.play();
                        }
                      },
                      icon: !player.playing
                          ? Icon(Icons.play_arrow)
                          : Icon(Icons.stop)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: ProgressBar(
                      timeLabelLocation: TimeLabelLocation.sides,
                      progress: pos,
                      total: audioPlayerDuration,
                      progressBarColor: Colors.grey,
                      baseBarColor: Colors.black.withOpacity(0.24),
                      bufferedBarColor: Colors.black.withOpacity(0.24),
                      thumbColor: Colors.black,
                      barHeight: 3.0,
                      thumbRadius: 5.0,
                      onSeek: (duration) async {
                        await player.seek(duration);
                      },
                    ),
                  ),
                ],
              );
            });
    ;
  }
}
