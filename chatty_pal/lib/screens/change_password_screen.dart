import 'dart:developer';

import 'package:chatty_pal/blocs/basic_auth_provider_bloc/basic_auth_provider_bloc.dart';
import 'package:chatty_pal/utils/app_constants.dart';
import 'package:chatty_pal/utils/cache_manager.dart';
import 'package:chatty_pal/utils/components.dart';
import 'package:chatty_pal/utils/constants.dart';
import 'package:chatty_pal/utils/toast_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _newPasswordConfirmationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth / 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: screenHeight / screenWidth * 120,
                      height: screenHeight / screenWidth * 120,
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    customTextField(
                        (String) {},
                        TextInputType.visiblePassword,
                        true,
                        _currentPasswordController,
                        'Current password',
                        Icon(Icons.password_sharp),
                        screenWidth,
                        Color.fromRGBO(9, 77, 61, 1),
                        Color.fromRGBO(135, 182, 151, 1)),
                    SizedBox(
                      height: screenHeight / 50,
                    ),
                    customTextField(
                        (String) {},
                        TextInputType.visiblePassword,
                        true,
                        _newPasswordController,
                        'New password',
                        Icon(Icons.password_sharp),
                        screenWidth,
                        Color.fromRGBO(9, 77, 61, 1),
                        Color.fromRGBO(135, 182, 151, 1)),
                    SizedBox(
                      height: screenHeight / 50,
                    ),
                    customTextField(
                        (String) {},
                        TextInputType.visiblePassword,
                        true,
                        _newPasswordConfirmationController,
                        'Confirm new password',
                        Icon(Icons.password_sharp),
                        screenWidth,
                        Color.fromRGBO(9, 77, 61, 1),
                        Color.fromRGBO(135, 182, 151, 1)),
                    SizedBox(
                      height: screenHeight / 50,
                    ),
                    BlocConsumer<BasicAuthProviderBloc, BasicAuthProviderState>(
                        builder: ((context, state) {
                      if (state is ChangeUserPasswordLodaingState) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        );
                      } else {
                        return customButton(
                            Color.fromRGBO(9, 77, 61, 1), Colors.white, 'Save',
                            () {
                          if (_currentPasswordController.text ==
                                  AppConstants.userPassword &&
                              _newPasswordController.text !=
                                  _newPasswordConfirmationController.text) {
                            ToastManager.show(
                                context,
                                'Wrong password confirmation',
                                Colors.redAccent);
                          } else if (_currentPasswordController.text !=
                              AppConstants.userPassword) {
                            ToastManager.show(context, 'Wrong Current Password',
                                Color.fromARGB(255, 174, 48, 48));
                          } else if (_newPasswordController.text ==
                              _newPasswordConfirmationController.text) {
                            context.read<BasicAuthProviderBloc>().add(
                                ChangeUserPasswordEvent(
                                    _newPasswordController.text));
                          }
                        }, screenWidth / 3, screenHeight);
                      }
                    }), listener: ((context, state) async {
                      if (state is ChangeUserPasswordSuccessState) {
                        ToastManager.show(context,
                            'Password Changed Successfuly', Colors.green);
                        AppConstants.userPassword = _newPasswordController.text;
                        await CacheManager.setValue(
                            userPasswordCacheKey, _newPasswordController.text);
                        Navigator.of(context).pop();
                      } else if (state is ChangeUserPasswordErrorState) {
                        ToastManager.show(
                            context, state.errorMessage, Colors.redAccent);
                        if (state.errorMessage == 'Requires relogin') {
                          context
                              .read<BasicAuthProviderBloc>()
                              .add(LogoutEvent());
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              'loginScreen', (Route<dynamic> route) => false);
                        }
                      }
                    }))
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
