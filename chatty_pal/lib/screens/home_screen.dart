import 'dart:developer';
import 'package:chatty_pal/blocs/chats_bloc/chats_bloc.dart';
import 'package:chatty_pal/models/user.dart';
import 'package:chatty_pal/screens/chat_screen.dart';
import 'package:chatty_pal/services/Firestore/firestore_database.dart';
import 'package:chatty_pal/utils/app_constants.dart';
import 'package:chatty_pal/utils/toast_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final _searchController = TextEditingController();
  List<User> searchResult = [];

  @override
  Widget build(BuildContext context) {
    if (AppConstants.userProfileImgUrl == null) {
      log('null');
    }
    // context.read<ChatsBloc>().add(GetAllChatsEvent());
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: Color.fromRGBO(135, 182, 151, 1),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(
                        'assets/images/logo2.png',
                        width: screenHeight / screenWidth * 35,
                        height: screenHeight / screenWidth * 35,
                      ),
                      Container(
                        width: screenWidth * .60,
                        child: TextField(
                            onChanged: (value) {
                              if (value.isEmpty) {
                                context
                                    .read<ChatsBloc>()
                                    .add(GetAllChatsEvent());
                              } else {
                                context.read<ChatsBloc>().add(
                                    GetSearchedChatsEvent(value.toLowerCase()));
                              }
                            },
                            controller: _searchController,
                            maxLines: null,
                            decoration: InputDecoration(
                              isDense: true,
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: Icon(Icons.search),
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
                              hintText: 'Search',
                              labelStyle: TextStyle(
                                  fontSize: screenWidth / 23,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w500),
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed('settingsScreen');
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 25,
                          child: ClipOval(
                              child: AppConstants.userProfileImgUrl != null
                                  ? FutureBuilder(
                                      future: FirestoreDatabase
                                          .getUserProfilePicture(
                                              AppConstants.userProfileImgUrl!),
                                      builder: (context, snapshot) {
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.done:
                                            return Image.network(snapshot.data!);
                                          default:
                                            return CircularProgressIndicator(
                                              color: Color.fromRGBO(
                                                  135, 182, 151, 1),
                                            );
                                        }
                                      },
                                    )
                                  : Icon(Icons.person)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              BlocConsumer<ChatsBloc, ChatsState>(builder: (context, state) {
                if (state is GettingAllChatsSuccessState) {
                  return Expanded(
                    child: StreamBuilder(
                        stream: ChatsBloc.chatsStream,
                        builder: ((context, chatStreamSnapshot) {
                          if (chatStreamSnapshot.hasData) {
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: chatStreamSnapshot.data!.length,
                                itemBuilder: ((context, index) {
                                  return FutureBuilder(
                                      future: FirestoreDatabase.getChat(
                                          AppConstants.userId!,
                                          chatStreamSnapshot
                                              .data![index].userId),
                                      builder: (context, snapshot2) {
                                        switch (snapshot2.connectionState) {
                                          default:
                                            return StreamBuilder(
                                                stream: snapshot2.data,
                                                builder: ((context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    String messageTime = '';
                                                    if (snapshot.data!.docs
                                                        .isNotEmpty) {
                                                      final date = DateTime
                                                          .parse(snapshot
                                                              .data!
                                                              .docs[snapshot
                                                                      .data!
                                                                      .docs
                                                                      .length -
                                                                  1]['timeStamp']
                                                              .toDate()
                                                              .toString());

                                                      messageTime +=
                                                          (date.second)
                                                              .toString();

                                                      return chatTile(() {
                                                        FocusScope.of(context)
                                                            .unfocus();
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ChatScreen(
                                                                          reciverUser:
                                                                              chatStreamSnapshot.data![index],
                                                                        )));
                                                      },
                                                          screenWidth,
                                                          screenHeight,
                                                          chatStreamSnapshot
                                                              .data![index]
                                                              .userName,
                                                          snapshot.data!.docs[
                                                              snapshot
                                                                      .data!
                                                                      .docs
                                                                      .length -
                                                                  1]['content'],
                                                          messageTime);
                                                    } else {
                                                      return SizedBox();
                                                    }
                                                  } else {
                                                    return Text('');
                                                  }
                                                }));
                                        }
                                      });
                                }));
                          } else {
                            return Center(
                                child: Text(
                              '',
                              style: TextStyle(
                                  fontSize: screenHeight / screenHeight * 20,
                                  color: Colors.white),
                            ));
                          }
                        })),
                  );
                } else if (state is GettingSearchedChatsSuccessState) {
                  return Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.searchResult.length,
                          itemBuilder: ((context, index) {
                            return chatTile(() {
                              _searchController.text = '';

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                        reciverUser: state.searchResult[index],
                                      )));
                              FocusScope.of(context).unfocus();
                            }, screenWidth, screenHeight,
                                state.searchResult[index].userName, '', '');
                          })));
                } else {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(0, screenHeight / 3, 0, 0),
                    child: Center(
                        child: CircularProgressIndicator(
                      color: Color.fromRGBO(9, 77, 61, 1),
                    )),
                  );
                }
              }, listener: (context, state) {
                if (state is GettingAllChatsErrorState ||
                    state is GettingSearchedChatsErrorState) {
                  ToastManager.show(
                      context, 'Something Went Wrong', Colors.red);
                }
              }),
              SizedBox(
                height: screenHeight / 60,
              ),
              SizedBox(
                height: screenHeight / 70,
              ),
            ],
          )),
    );
  }
}

Widget chatTile(Function() onTap, double screenWidth, double screenHeight,
    String username, String message, String messageTime) {
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            width: screenWidth,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color.fromRGBO(9, 77, 61, 1),
                    radius: 28,
                    child: ClipOval(
                        child: Icon(
                      Icons.person_3_rounded,
                      color: Colors.white,
                      size: screenHeight / screenWidth * 20,
                    )),
                  ),
                  SizedBox(
                    width: screenWidth * 0.03,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: screenWidth * .70,
                        child: Row(
                          children: [
                            Text(
                              username,
                              style: TextStyle(
                                  color: Color.fromRGBO(9, 77, 61, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenHeight / screenWidth * 11),
                            ),
                            Spacer(),
                            Text(
                              messageTime,
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        message,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
      SizedBox(
        height: screenHeight * 0.02,
      )
    ],
  );
}
