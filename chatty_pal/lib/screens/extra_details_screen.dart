import 'dart:developer';
import 'dart:io';

import 'package:chatty_pal/blocs/basic_auth_provider_bloc/basic_auth_provider_bloc.dart';
import 'package:chatty_pal/blocs/chats_bloc/chats_bloc.dart';
import 'package:chatty_pal/services/Auth/basic_auth_provider.dart';
import 'package:chatty_pal/services/Firestore/firestore_database.dart';
import 'package:chatty_pal/utils/app_constants.dart';
import 'package:chatty_pal/utils/cache_manager.dart';
import 'package:chatty_pal/utils/components.dart';
import 'package:chatty_pal/utils/constants.dart';
import 'package:chatty_pal/utils/toast_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class ExtraDetailsScreen extends StatefulWidget {
  ExtraDetailsScreen({super.key});

  @override
  State<ExtraDetailsScreen> createState() => _ExtraDetailsScreenState();
}

class _ExtraDetailsScreenState extends State<ExtraDetailsScreen> {
  final _bioController = TextEditingController();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  String? _photoPath;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery,maxHeight: 480, maxWidth: 640,imageQuality: 50);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera,maxHeight: 480, maxWidth: 640,imageQuality: 50);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
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

  @override
  Widget build(BuildContext context) {
    log('awl extra secreen');
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: true,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth / 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: screenHeight / screenWidth * 80,
                      height: screenHeight / screenWidth * 80,
                    ),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    InkWell(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: PickPhotoContainer(_photo),
                    ),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    customTextField(
                        (String) {},
                        TextInputType.emailAddress,
                        false,
                        _bioController,
                        'Bio',
                        Icon(Icons.flash_on_outlined),
                        screenWidth,
                        Color.fromRGBO(9, 77, 61, 1),
                        Color.fromRGBO(135, 182, 151, 1)),
                    SizedBox(
                      height: screenHeight * 0.06,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customButton(Color.fromRGBO(149, 153, 152, 1),
                              Colors.white, "Skip", () async {
                            if (_bioController.text.isEmpty) {
                              AppConstants.userBio = '';
                              CacheManager.setValue(userBioCacheKey, '');
                              await FirestoreDatabase.updateUser(
                                  AppConstants.userId!, {'bio': ''});
                              // await FirestoreDatabase.getAllChats();
                              context.read<ChatsBloc>().add(GetAllChatsEvent());
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  'homeScreen', (route) => false);
                            } else {
                              AppConstants.userBio = _bioController.text;
                              CacheManager.setValue(
                                  userBioCacheKey, _bioController.text);
                              await FirestoreDatabase.updateUser(
                                  AppConstants.userId!, {'bio': ''});
                              // await FirestoreDatabase.getAllChats();
                              log('before bloc call');

                              context.read<ChatsBloc>().add(GetAllChatsEvent());
                              log('after bloc call');

                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  'homeScreen', (route) => false);
                            }
                          }, screenWidth / 6, screenHeight),
                          BlocConsumer<BasicAuthProviderBloc,
                                  BasicAuthProviderState>(
                              builder: ((context, state) {
                            if (state is SaveUserExtraDataLodaingState) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Color.fromRGBO(9, 77, 61, 1),
                                ),
                              );
                            } else {
                              return customButton(Color.fromRGBO(9, 77, 61, 1),
                                  Colors.white, "Save", () async {
                                log('before updaate info bloc call');
                                context.read<BasicAuthProviderBloc>().add(
                                    SaveUserExtraDataEvent(_photo, _photoPath,
                                        _bioController.text));
                                log('after updaate info bloc call');
                              }, screenWidth / 6, screenHeight);
                            }
                          }), listener: ((context, state) async {
                            if (state is SaveUserExtraDataSuccessState) {
                              log('before updaate user bio  call');

                              log('after updaate user bio  call');
                              // await FirestoreDatabase.getAllChats();
                              log('before get allchats  bloc call');
                              context.read<ChatsBloc>().add(GetAllChatsEvent());
                              log('before get allchats  bloc call');

                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  'homeScreen', (route) => false);
                            } else if (state is SaveUserExtraDataErrorState) {
                              ToastManager.show(context, state.errorMessage,
                                  Color.fromARGB(255, 136, 38, 31));
                            }
                          }))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget PickPhotoContainer(File? _photo) => CircleAvatar(
      radius: 55,
      backgroundColor: Color.fromRGBO(9, 77, 61, 1),
      child: _photo != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.file(
                _photo!,
                width: 100,
                height: 100,
                fit: BoxFit.fitHeight,
              ),
            )
          : Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(50)),
              width: 100,
              height: 100,
              child: Icon(
                Icons.camera_alt,
                size: 50,
                color: Colors.grey[800],
              ),
            ),
    );
