import 'dart:developer';

import 'package:chatty_pal/blocs/chats_bloc/chats_bloc.dart';
import 'package:chatty_pal/models/user.dart';
import 'package:chatty_pal/services/Firestore/firestore_database.dart';
import 'package:chatty_pal/utils/app_constants.dart';
import 'package:chatty_pal/utils/components.dart';
import 'package:chatty_pal/utils/toast_manager.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key, required this.reciverUser});
  final User reciverUser;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();

  static final _formKey = GlobalKey<FormState>();
  bool hasMessgaes = false;
  @override
  void deactivate() async {
    context.read<ChatsBloc>().add(GetAllChatsEvent());
    super.deactivate();
  }

  @override
  void initState() {
    context.read<ChatsBloc>().add(GetChatStreamEvent(widget.reciverUser));
    super.initState();
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
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 25,
                        child: ClipOval(
                            child: CachedNetworkImage(
                          // width: 10,
                          // height: 10,
                          imageUrl: widget.reciverUser.userProfileImage,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )),
                      ),
                      SizedBox(
                        width: screenWidth / 25,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.reciverUser.userName,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: screenHeight / screenWidth * 14),
                          ),
                          // Text(
                          //   'Last seen 11:00',
                          //   style: TextStyle(color: Colors.white),
                          // ),
                        ],
                      ),
                      Spacer(),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            color: Colors.white,
                            Icons.menu,
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
                                        return sentMessage(
                                            screenWidth,
                                            screenHeight,
                                            snapshot.data!.docs[index]
                                                ['content']);
                                      } else {
                                        return recievedMessage(
                                            screenWidth,
                                            screenHeight,
                                            snapshot.data!.docs[index]
                                                ['content']);
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
                      width: screenWidth * .70,
                      child: TextField(
                          key: _formKey,
                          controller: _messageController,
                          maxLines: null,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: IconButton(
                                onPressed: () async {
                                  FirestoreDatabase.sendAMessage(
                                      AppConstants.userId!,
                                      widget.reciverUser.userId,
                                      _messageController.text,
                                      DateTime.now());

                                  FocusScope.of(context).unfocus();
                                  _messageController.text = '';
                                },
                                icon: Icon(Icons.send)),
                            suffixIconColor: Colors.black45,
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                    color: Colors.black, width: 1.3)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                    color: Colors.black, width: 1.3)),
                            hintText: 'Message',
                            labelStyle: TextStyle(
                                fontSize: screenWidth / 23,
                                color: Colors.black45,
                                fontWeight: FontWeight.w500),
                          )),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          color: Color.fromRGBO(9, 77, 61, 1),
                          Icons.attach_file_rounded,
                          size: screenHeight / screenWidth * 18,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          color: Color.fromRGBO(9, 77, 61, 1),
                          Icons.mic,
                          size: screenHeight / screenWidth * 20,
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight / 70,
              ),
            ],
          )),
    );
  }
}

Widget recievedMessage(
    double screenWidth, double screenHeight, String message) {
  return Column(
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
                      fontSize: screenHeight / screenWidth * 9,
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
  );
}

Widget sentMessage(double screenWidth, double screenHeight, String message) {
  return Column(
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
                      fontSize: screenHeight / screenWidth * 9,
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
  );
}
