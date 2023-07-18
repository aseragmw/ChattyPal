import 'dart:developer';

import 'package:chatty_pal/blocs/basic_auth_provider_bloc/basic_auth_provider_bloc.dart';
import 'package:chatty_pal/utils/toast_manager.dart';
import 'package:flutter/material.dart';
import 'package:chatty_pal/utils/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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
                padding: EdgeInsets.symmetric(horizontal: screenWidth / 40),
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
                        null,
                        false,
                        _nameController,
                        'Name',
                        const Icon(Icons.person),
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
                        const Icon(Icons.email_outlined),
                        screenWidth,
                        Color.fromRGBO(9, 77, 61, 1),
                        Color.fromRGBO(135, 182, 151, 1)),
                    SizedBox(
                      height: screenHeight / 50,
                    ),
                    customTextField(
                        (String) {},
                        null,
                        true,
                        _passwordController,
                        'Password',
                        const Icon(Icons.password_rounded),
                        screenWidth,
                        Color.fromRGBO(9, 77, 61, 1),
                        Color.fromRGBO(135, 182, 151, 1)),
                    SizedBox(
                      height: screenHeight / 50,
                    ),
                    BlocConsumer<BasicAuthProviderBloc, BasicAuthProviderState>(
                      listener: (context, state) {
                        if (state is RegisterSuccessState) {
                          ToastManager.show(
                              context,
                              "Register completed successfuly",
                              Color.fromRGBO(19, 141, 113, 1));
                          log('abl navigate fe register screen');
                          Navigator.of(context)
                              .pushReplacementNamed('extraDetailsScreen');
                        } else if (state is RegisterErrorState) {
                          ToastManager.show(context, state.errorMessage,
                              Color.fromARGB(255, 129, 28, 21));
                        }
                      },
                      builder: (context, state) {
                        if (state is RegisterLoadingState) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color.fromRGBO(9, 77, 61, 1),
                            ),
                          );
                        } else {
                          return customButton(Color.fromRGBO(9, 77, 61, 1),
                              Colors.white, 'Register', () {
                            FocusScope.of(context).unfocus();
                            context.read<BasicAuthProviderBloc>().add(
                                RegisterEvent(
                                    _emailController.text,
                                    _passwordController.text,
                                    _nameController.text));
                          }, screenWidth / 3, screenHeight);
                        }
                      },
                    ),
                    SizedBox(
                      height: screenHeight / 50,
                    ),
                    Text(
                      "Do you have an account?",
                      style: TextStyle(
                        fontSize: screenHeight / screenWidth * 10,
                        color: Color.fromRGBO(9, 77, 61, 1),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight / 50,
                    ),
                    customButton(
                        Color.fromRGBO(9, 77, 61, 1), Colors.white, 'Login',
                        () {
                      Navigator.of(context).pushReplacementNamed('loginScreen');
                    }, screenWidth / 3, screenHeight)
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
