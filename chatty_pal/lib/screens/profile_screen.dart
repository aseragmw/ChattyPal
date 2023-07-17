import 'package:chatty_pal/blocs/basic_auth_provider_bloc/basic_auth_provider_bloc.dart';
import 'package:chatty_pal/utils/app_constants.dart';
import 'package:chatty_pal/utils/cache_manager.dart';
import 'package:chatty_pal/utils/components.dart';
import 'package:chatty_pal/utils/constants.dart';
import 'package:chatty_pal/utils/toast_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final _nameController = TextEditingController()
    ..text = AppConstants.userName!;
  final _emailController = TextEditingController()
    ..text = AppConstants.userEmail!;

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
                    customTextField((String){},
                        TextInputType.text,
                        false,
                        _nameController,
                        'Your Name',
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
                        Colors.black,
                        Colors.black45),
                    SizedBox(
                      height: screenHeight / 50,
                    ),
                    customTextField((String){},
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
                        Colors.black,
                        Colors.black45),
                    SizedBox(
                      height: screenHeight / 50,
                    ),
                    SizedBox(
                      height: screenHeight / 50,
                    ),
                    customButton(Colors.black, Colors.white, 'Change Password',
                        () {
                      Navigator.of(context).pushNamed('changePassowordScreen');
                    }, screenWidth, screenHeight),
                    SizedBox(
                      height: screenHeight / 50,
                    ),
                    customButton(Colors.black, Colors.white, 'Logout', () {
                      context.read<BasicAuthProviderBloc>().add(LogoutEvent());
                      Navigator.of(context).pushReplacementNamed('loginScreen');
                    }, screenWidth, screenHeight)
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
