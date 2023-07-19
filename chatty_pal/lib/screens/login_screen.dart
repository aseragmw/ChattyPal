import 'package:chatty_pal/blocs/basic_auth_provider_bloc/basic_auth_provider_bloc.dart';
import 'package:chatty_pal/blocs/chats_bloc/chats_bloc.dart';
import 'package:chatty_pal/services/Firestore/firestore_database.dart';
import 'package:chatty_pal/utils/app_constants.dart';
import 'package:chatty_pal/utils/toast_manager.dart';
import 'package:flutter/material.dart';
import 'package:chatty_pal/utils/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
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
                      width: screenHeight / screenWidth * 120,
                      height: screenHeight / screenWidth * 120,
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
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
                        builder: ((context, state) {
                      if (state is LoginLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        );
                      } else {
                        return customButton(
                            Color.fromRGBO(9, 77, 61, 1), Colors.white, 'Login',
                            () async {
                          FocusScope.of(context).unfocus();
                          context.read<BasicAuthProviderBloc>().add(LoginEvent(
                              _emailController.text, _passwordController.text));
                        }, screenWidth / 3, screenHeight);
                      }
                    }), listener: (context, state) async {
                      if (state is LoginSuccessState) {
                        ToastManager.show(context, 'Login Done Successfuly',
                            Color.fromRGBO(19, 141, 113, 1));
                        await FirestoreDatabase.updateUser(
                            AppConstants.userId!, {'bio': ''});
                        // await FirestoreDatabase.getAllChats();
                        context.read<ChatsBloc>().add(GetAllChatsEvent());
                        Navigator.of(context)
                            .pushReplacementNamed('homeScreen');
                      } else if (state is LoginErrorState) {
                        ToastManager.show(context, state.errorMeessage,
                            Color.fromARGB(255, 129, 28, 21));
                      }
                    }),
                    SizedBox(
                      height: screenHeight / 50,
                    ),
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontSize: screenHeight / screenWidth * 10,
                        color: Color.fromRGBO(9, 77, 61, 1),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight / 50,
                    ),
                    customButton(
                        Color.fromRGBO(9, 77, 61, 1), Colors.white, "Register",
                        () {
                      Navigator.of(context)
                          .pushReplacementNamed('registerScreen');
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
