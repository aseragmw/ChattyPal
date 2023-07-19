import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatty_pal/blocs/basic_auth_provider_bloc/basic_auth_provider_bloc.dart';
import 'package:chatty_pal/screens/extra_details_screen.dart';
import 'package:chatty_pal/services/Firestore/firestore_database.dart';
import 'package:chatty_pal/utils/app_constants.dart';
import 'package:chatty_pal/utils/cache_manager.dart';
import 'package:chatty_pal/utils/components.dart';
import 'package:chatty_pal/utils/constants.dart';
import 'package:chatty_pal/utils/toast_manager.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';

import 'package:image_picker/image_picker.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _nameController = TextEditingController()
    ..text = AppConstants.userName!;

  final _emailController = TextEditingController()
    ..text = AppConstants.userEmail!;

  final _bioController = TextEditingController()..text = AppConstants.userBio!;

  FirebaseStorage storage = FirebaseStorage.instance;

  File? _photo;

  String? _photoPath;

  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        context.read<BasicAuthProviderBloc>().add(
            SaveUserExtraDataEvent(_photo, _photoPath, _bioController.text));
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        context.read<BasicAuthProviderBloc>().add(
            SaveUserExtraDataEvent(_photo, _photoPath, _bioController.text));
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
                        imgFromGallery(context);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imgFromCamera(context);
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth / 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () {
                          _showPicker(context);
                        },
                        child: BlocConsumer<BasicAuthProviderBloc,
                            BasicAuthProviderState>(
                          builder: (context, state) {
                            return CircleAvatar(
                                radius: 60,
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
                                    : AppConstants.userProfileImgUrl == null
                                        ? Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            width: 100,
                                            height: 100,
                                            child: Icon(
                                              Icons.camera_alt,
                                              size: 50,
                                              color: Colors.grey[800],
                                            ),
                                          )
                                        : ClipOval(
                                            child: AppConstants
                                                        .userProfileImgUrl !=
                                                    null
                                                ? CachedNetworkImage(
                                                    imageUrl: AppConstants
                                                        .userProfileImgUrl!,
                                                    width: screenHeight /
                                                        screenWidth *
                                                        50,
                                                    height: screenHeight /
                                                        screenWidth *
                                                        50,
                                                  )
                                                : Icon(Icons.person)));
                          },
                          listener: (context, state) {},
                        )),
                    SizedBox(
                      height: screenHeight / 50,
                    ),
                    customTextField(
                        (String) {},
                        TextInputType.text,
                        false,
                        _nameController,
                        'Username',
                        BlocConsumer<BasicAuthProviderBloc,
                            BasicAuthProviderState>(builder: (context, state) {
                          if (state is ChangeUserDisplayNameLodaingState) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            );
                          } else {
                            return InkWell(
                                onTap: () async {
                                  if (_nameController.text !=
                                      AppConstants.userName) {
                                    FocusScope.of(context).unfocus();
                                    context.read<BasicAuthProviderBloc>().add(
                                        ChangeUserDisplayNameEvent(
                                            _nameController.text));
                                  }
                                },
                                child: Icon(Icons.done));
                          }
                        }, listener: (context, state) async {
                          if (state is ChangeUserDisplayNameErrorState) {
                            ToastManager.show(
                                context, state.errorMessage, Colors.redAccent);
                          } else if (state
                              is ChangeUserDisplayNameSuccessState) {
                            AppConstants.userName = _nameController.text;
                            await CacheManager.setValue(
                                userNameCacheKey, _nameController.text);
                            ToastManager.show(context,
                                'Name Changed Successfuly', Colors.green);
                          }
                        }),
                        screenWidth,
                        Color.fromRGBO(9, 77, 61, 1),
                        Color.fromRGBO(135, 182, 151, 1)),
                    SizedBox(
                      height: screenHeight / 50,
                    ),
                    customTextField(
                        (String) {},
                        TextInputType.emailAddress,
                        false,
                        _emailController,
                        'Email',
                        BlocConsumer<BasicAuthProviderBloc,
                            BasicAuthProviderState>(builder: (context, state) {
                          if (state is ChangeUserEmailLodaingState) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            );
                          } else {
                            return InkWell(
                                onTap: () async {
                                  if (_emailController.text !=
                                      AppConstants.userEmail) {
                                    FocusScope.of(context).unfocus();
                                    context.read<BasicAuthProviderBloc>().add(
                                        ChangeUserEmailEvent(
                                            _emailController.text));
                                  }
                                },
                                child: Icon(Icons.done));
                          }
                        }, listener: (context, state) async {
                          if (state is ChangeUserEmailErrorState) {
                            ToastManager.show(
                                context, state.errorMessage, Colors.redAccent);
                          } else if (state is ChangeUserEmailSuccessState) {
                            AppConstants.userEmail = _emailController.text;
                            await CacheManager.setValue(
                                userEmailCacheKey, _emailController.text);
                            ToastManager.show(context,
                                'Email Changed Successfuly', Colors.green);
                          }
                        }),
                        screenWidth,
                        Color.fromRGBO(9, 77, 61, 1),
                        Color.fromRGBO(135, 182, 151, 1)),
                    SizedBox(
                      height: screenHeight / 50,
                    ),
                    customTextField(
                        (String) {},
                        TextInputType.text,
                        false,
                        _bioController,
                        'Bio',
                        BlocConsumer<BasicAuthProviderBloc,
                            BasicAuthProviderState>(builder: (context, state) {
                          if (state is ChangeUserBioLodaingState) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            );
                          } else {
                            return InkWell(
                                onTap: () async {
                                  if (_bioController.text !=
                                      AppConstants.userBio) {
                                    FocusScope.of(context).unfocus();
                                    context.read<BasicAuthProviderBloc>().add(
                                        ChangeUserBioEvent(
                                            _bioController.text));
                                  }
                                },
                                child: Icon(Icons.done));
                          }
                        }, listener: (context, state) async {
                          if (state is ChangeUserBioErrorState) {
                            ToastManager.show(
                                context, state.errorMessage, Colors.redAccent);
                          } else if (state is ChangeUserBioSuccessState) {
                            AppConstants.userBio = _bioController.text;
                            await CacheManager.setValue(
                                userBioCacheKey, _bioController.text);
                            ToastManager.show(context,
                                'Bio Changed Successfuly', Colors.green);
                          }
                        }),
                        screenWidth,
                        Color.fromRGBO(9, 77, 61, 1),
                        Color.fromRGBO(135, 182, 151, 1)),
                    SizedBox(
                      height: screenHeight / 50,
                    ),
                    SizedBox(
                      height: screenHeight / 50,
                    ),
                    customButton(Color.fromRGBO(9, 77, 61, 1), Colors.white,
                        'Change Password', () {
                      Navigator.of(context).pushNamed('changePassowordScreen');
                    }, screenWidth / 2, screenHeight),
                    SizedBox(
                      height: screenHeight / 50,
                    ),
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
