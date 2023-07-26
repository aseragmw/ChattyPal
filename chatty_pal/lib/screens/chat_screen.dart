import 'dart:developer';
import 'dart:io';
import 'package:chatty_pal/blocs/chats_bloc/chats_bloc.dart';
import 'package:chatty_pal/models/user.dart';
import 'package:chatty_pal/screens/reciever_profile_screen.dart';
import 'package:chatty_pal/screens/video_widget.dart';
import 'package:chatty_pal/services/Firestore/firestore_database.dart';
import 'package:chatty_pal/utils/app_constants.dart';
import 'package:chatty_pal/utils/toast_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:video_player/video_player.dart';
import 'package:chatty_pal/utils/components.dart';
import 'package:path/path.dart' as p;

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key, required this.reciverUser});
  final User reciverUser;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseStorage storage = FirebaseStorage.instance;

  File? _photo;
  File? _video;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 50);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 50);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> videoFromGallery() async {
    final pickedFile = await _picker.pickVideo(
      source: ImageSource.gallery,
    );

    setState(() {
      if (pickedFile != null) {
        _video = File(pickedFile.path);
        uploadVideo();
      } else {
        print('No videooooooooooooooooooooooooooooo selected.');
      }
    });
  }

  Future<void> videoFromCamera() async {
    final XFile? pickedFile = await _picker.pickVideo(
      source: ImageSource.camera,
    );

    setState(() {
      log('video ahooooooooooo222222222222222');

      if (pickedFile != null) {
        log('video ahooooooooooo');

        _video = File(pickedFile.path);
        uploadVideo();
      } else {
        print(
            'No videooooooooooooooooooooooooooooooooooooooooooooooooooooooo selected.');
      }
    });
  }

  Future uploadVideo() async {
    if (_video == null) return;
    final fileName = p.basename(_video!.path);
    final destination = 'files/$fileName';

    try {
      log('video 0');
      final ref = FirebaseStorage.instance.ref(destination).child('file/');
      log('video 1');
      final task = await ref.putFile(_video!);
      log('video 2');
      final url = await task.ref.getDownloadURL();
      log('video 3');
      await FirestoreDatabase.sendAMessage(AppConstants.userId!,
          widget.reciverUser.userId, url, DateTime.now(), 'video');
      log('video 4');
    } catch (e) {
      print('error occured');
    }
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = p.basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = FirebaseStorage.instance.ref(destination).child('file/');
      final task = await ref.putFile(_photo!);
      final url = await task.ref.getDownloadURL();
      await FirestoreDatabase.sendAMessage(AppConstants.userId!,
          widget.reciverUser.userId, url, DateTime.now(), 'image');
    } catch (e) {
      print('error occured');
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _showMultiMediaPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo'),
                      onTap: () {
                        Navigator.of(context).pop();
                        _showPicker(context);
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Video'),
                    onTap: () {
                      Navigator.of(context).pop();

                      _showVideoPicker(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _showVideoPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () async {
                        await videoFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () async {
                      await videoFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  ///////////////////////////////////////////////////////////////////////////////////
  final recorder = FlutterSoundRecorder();
  bool isRecording = false;

  //////////////////////////////////////////////////////////////////////////////////////////////////////
  final _messageController = TextEditingController();

  static final _formKey = GlobalKey<FormState>();
  bool hasMessgaes = false;
  @override
  void deactivate() async {
    context.read<ChatsBloc>().add(GetAllChatsEvent());
    await recorder.closeRecorder();
    super.deactivate();
  }

  Future<void> initRecorder() async {
    final status = await Permission.microphone.request();
    await recorder.openRecorder();
    await recorder.setSubscriptionDuration(Duration(milliseconds: 500));
  }

  @override
  void initState() {
    context.read<ChatsBloc>().add(GetChatStreamEvent(widget.reciverUser));

    super.initState();
    initRecorder();
  }

  bool gotRecHasPic = false;
  String recPic = '';

  ScrollController _controller = new ScrollController();
  @override
  Widget build(BuildContext context) {
    //  context.read<ChatsBloc>().add(GetChatStreamEvent(widget.reciverUser));
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    log(widget.reciverUser.userProfileImage);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: Color.fromRGBO(135, 182, 151, 1),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Color.fromRGBO(9, 77, 61, 1),
                height: screenHeight / 25,
              ),
              Container(
                width: screenWidth,
                color: Color.fromRGBO(9, 77, 61, 1),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          )),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RecieverProfileScreen(
                                    recieverUser: widget.reciverUser,
                                  )));
                        },
                        child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 25,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                // width: 100,
                                // height: 100,
                                imageUrl: widget.reciverUser.userProfileImage,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            )),
                      ),
                      SizedBox(
                        width: screenWidth / 25,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RecieverProfileScreen(
                                      recieverUser: widget.reciverUser)));
                            },
                            child: Text(
                              widget.reciverUser.userName,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.07),
                            ),
                          ),
                          // Text(
                          //   'Last seen 11:00',
                          //   style: TextStyle(color: Colors.white),
                          // ),
                        ],
                      ),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            showChatSettings(context, AppConstants.userId!,
                                widget.reciverUser.userId);
                          },
                          icon: Icon(
                            color: Colors.white,
                            Icons.more_vert,
                            size: screenHeight / screenWidth * 15,
                          ))
                    ],
                  ),
                ),
              ),
              Expanded(
                child: BlocConsumer<ChatsBloc, ChatsState>(
                  listener: (context, state) {
                    if (state is GettingAllChatsSuccessState) {
                      // context
                      //     .read<ChatsBloc>()
                      //     .add(GetChatStreamEvent(widget.reciverUser));
                    }
                  },
                  builder: (context, state) {
                    if (state is GettingChatStreamSuccessState) {
                      return StreamBuilder(
                          stream: state.chatStream,
                          builder: ((context, snapshot) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (_controller.hasClients) {
                                _controller.jumpTo(
                                    _controller.position.maxScrollExtent);
                              } else {
                                setState(() => null);
                              }
                            });

                            if (snapshot.hasData) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth / 50),
                                child: ListView.builder(
                                    controller: _controller,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      hasMessgaes = true;
                                      if (snapshot.data!.docs[index]
                                              ['fromId'] ==
                                          AppConstants.userId) {
                                        if (snapshot.data!.docs[index]
                                                ['type'] ==
                                            'text') {
                                          return sentMessage(
                                              context,
                                              AppConstants.userId!,
                                              widget.reciverUser.userId,
                                              DateTime.parse(snapshot.data!
                                                  .docs[index]['timeStamp']
                                                  .toDate()
                                                  .toString()),
                                              screenWidth,
                                              screenHeight,
                                              snapshot.data!.docs[index]
                                                  ['content']);
                                        } else if (snapshot.data!.docs[index]
                                                ['type'] ==
                                            'image') {
                                          return sentImage(
                                              context,
                                              AppConstants.userId!,
                                              widget.reciverUser.userId,
                                              DateTime.parse(snapshot.data!
                                                  .docs[index]['timeStamp']
                                                  .toDate()
                                                  .toString()),
                                              screenWidth,
                                              screenHeight,
                                              snapshot.data!.docs[index]
                                                  ['content']);
                                        } else if (snapshot.data!.docs[index]
                                                ['type'] ==
                                            'record') {
                                          // log('${snapshot.data!.docs[index]['content']}');
                                          // return AudioWidget(
                                          //   audioUrl: snapshot.data!.docs[index]
                                          //       ['content'],
                                          // );
                                          return Column(
                                            children: [
                                              sentAudio(
                                                  context,
                                                  AppConstants.userId!,
                                                  widget.reciverUser.userId,
                                                  DateTime.parse(snapshot.data!
                                                      .docs[index]['timeStamp']
                                                      .toDate()
                                                      .toString()),
                                                  snapshot.data!.docs[index]
                                                      ['content']),
                                              SizedBox(
                                                height: screenHeight / 60,
                                              )
                                            ],
                                          );
                                        } else if (snapshot.data!.docs[index]
                                                ['type'] ==
                                            'video') {
                                          return sentVideo(
                                              context,
                                              AppConstants.userId!,
                                              widget.reciverUser.userId,
                                              DateTime.parse(snapshot.data!
                                                  .docs[index]['timeStamp']
                                                  .toDate()
                                                  .toString()),
                                              screenWidth,
                                              screenHeight,
                                              snapshot.data!.docs[index]
                                                  ['content']);
                                        }
                                      } else {
                                        if (snapshot.data!.docs[index]
                                                ['type'] ==
                                            'text') {
                                          return recievedMessage(
                                              context,
                                              AppConstants.userId!,
                                              widget.reciverUser.userId,
                                              DateTime.parse(snapshot.data!
                                                  .docs[index]['timeStamp']
                                                  .toDate()
                                                  .toString()),
                                              screenWidth,
                                              screenHeight,
                                              snapshot.data!.docs[index]
                                                  ['content']);
                                        } else if (snapshot.data!.docs[index]
                                                ['type'] ==
                                            'image') {
                                          return recievedImage(
                                              context,
                                              AppConstants.userId!,
                                              widget.reciverUser.userId,
                                              DateTime.parse(snapshot.data!
                                                  .docs[index]['timeStamp']
                                                  .toDate()
                                                  .toString()),
                                              screenWidth,
                                              screenHeight,
                                              snapshot.data!.docs[index]
                                                  ['content']);
                                        } else if (snapshot.data!.docs[index]
                                                ['type'] ==
                                            'record') {
                                          return Column(
                                            children: [
                                              recievedAudio(
                                                  context,
                                                  AppConstants.userId!,
                                                  widget.reciverUser.userId,
                                                  DateTime.parse(snapshot.data!
                                                      .docs[index]['timeStamp']
                                                      .toDate()
                                                      .toString()),
                                                  snapshot.data!.docs[index]
                                                      ['content']),
                                              SizedBox(
                                                height: screenHeight / 60,
                                              )
                                            ],
                                          );
                                        } else if (snapshot.data!.docs[index]
                                                ['type'] ==
                                            'video') {
                                          return recievedVideo(
                                              context,
                                              AppConstants.userId!,
                                              widget.reciverUser.userId,
                                              DateTime.parse(snapshot.data!
                                                  .docs[index]['timeStamp']
                                                  .toDate()
                                                  .toString()),
                                              screenWidth,
                                              screenHeight,
                                              snapshot.data!.docs[index]
                                                  ['content']);
                                        }
                                      }
                                    },
                                    itemCount: snapshot.data!.docs.length),
                              );
                            } else {
                              return Text('');
                            }
                          }));
                    } else if (state is GettingChatStreamErrorState) {
                      ToastManager.show(
                          context, 'Something went wrong..', Colors.red);
                      return SizedBox();
                    } else {
                      log('state is ${state.toString()}');
                      return Padding(
                        padding: EdgeInsets.fromLTRB(0, screenHeight / 3, 0, 0),
                        child: Center(
                            child: CircularProgressIndicator(
                          color: Color.fromRGBO(9, 77, 61, 1),
                        )),
                      );
                    }
                  },
                ),
              ),
              // SizedBox(
              //   height: screenHeight / 60,
              // ),
              // Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth / 50),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        // color: Colors.transparent,
                        width: screenWidth * .60,
                        child: TextField(
                            key: _formKey,
                            controller: _messageController,
                            maxLines: null,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: IconButton(
                                  onPressed: () async {
                                    if (_messageController.text.isNotEmpty) {
                                      FirestoreDatabase.sendAMessage(
                                          AppConstants.userId!,
                                          widget.reciverUser.userId,
                                          _messageController.text,
                                          DateTime.now(),
                                          'text');

                                      // FocusScope.of(context).unfocus();
                                      _messageController.text = '';
                                    }
                                  },
                                  icon: Icon(Icons.send)),
                              suffixIconColor: Colors.black45,
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  )),
                              hintText: 'Message',
                              labelStyle: TextStyle(
                                  fontSize: screenWidth / 23,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w500),
                            )),
                      ),
                      IconButton(
                          onPressed: () async {
                            _showMultiMediaPicker(context);
                          },
                          icon: Icon(
                            color: Color.fromRGBO(9, 77, 61, 1),
                            Icons.image,
                            size: screenHeight / screenWidth * 18,
                          )),
                      StatefulBuilder(
                        builder: (context, setState2) {
                          return IconButton(
                              onPressed: () async {
                                if (isRecording) {
                                  setState2(
                                    () {
                                      isRecording = false;
                                    },
                                  );
                                  isRecording = false;
                                  final path = await recorder.stopRecorder();

                                  final audioFile = File(path!);
                                  if (audioFile == null) return;
                                  final fileName = p.basename(audioFile.path);
                                  final user = await FirebaseFirestore.instance
                                      .collection('users')
                                      .where('id',
                                          isEqualTo: AppConstants.userId!)
                                      .get();
                                  int recordsCount = user.docs.first
                                      .data()['recordsCount'] as int;
                                  recordsCount++;
                                  String destination =
                                      'files/${AppConstants.userId}/${recordsCount.toString()}/$fileName';
                                  log('hhh1');

                                  log('hhh2');

                                  log(' des issssssssss ${destination}');
                                  final ref = FirebaseStorage.instance
                                      .ref(destination)
                                      .child('file/');

                                  final task = await ref.putFile(audioFile);
                                  final url = await task.ref.getDownloadURL();
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .where('id',
                                          isEqualTo: AppConstants.userId!)
                                      .get()
                                      .then((value) {
                                    value.docs.first.reference
                                        .update({'recordsCount': recordsCount});
                                  });
                                  log('download link is ${url}');
                                  try {
                                    await FirestoreDatabase.sendAMessage(
                                        AppConstants.userId!,
                                        widget.reciverUser.userId,
                                        url,
                                        DateTime.now(),
                                        'record');
                                  } catch (e) {
                                    print('error occured');
                                  }

                                  log('audio path is ${audioFile.path}');
                                } else {
                                  setState2(() {
                                    isRecording = true;
                                  });
                                  isRecording = true;
//                                 var tempDir = await getTemporaryDirectory();
//  String path = '${tempDir.path}/audio.acc';
                                  Directory directory =
                                      Directory(p.dirname('audio'));
                                  if (!directory.existsSync()) {
                                    directory.createSync();
                                  }
                                  await recorder.startRecorder(toFile: 'audio');
                                }
                              },
                              icon: !isRecording
                                  ? Icon(Icons.mic,
                                      color: Color.fromRGBO(9, 77, 61, 1),
                                      size: screenHeight / screenWidth * 15)
                                  : Column(
                                      children: [
                                        StreamBuilder<RecordingDisposition>(
                                            stream: recorder.onProgress,
                                            builder: (context, snapshot) {
                                              final duration = snapshot.hasData
                                                  ? snapshot.data!.duration
                                                  : Duration.zero;
                                              final durationText = duration
                                                      .inMinutes
                                                      .toString() +
                                                  ':' +
                                                  duration.inSeconds.toString();
                                              return Text(
                                                durationText,
                                                style: TextStyle(fontSize: 10),
                                              );
                                            }),
                                        Icon(Icons.stop,
                                            color: Color.fromRGBO(9, 77, 61, 1),
                                            size:
                                                screenHeight / screenWidth * 9),
                                      ],
                                    ));
                        },
                      ),
                    ]),
              ),
              SizedBox(
                height: screenHeight / 70,
              ),
            ],
          )),
    );
  }
}

class VideoApp extends StatefulWidget {
  VideoApp({super.key, this.videoUrl});
  final videoUrl;

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromRGBO(135, 182, 151, 1),
      body: Center(
        child: _controller.value.isInitialized
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
              )
            : Container(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
