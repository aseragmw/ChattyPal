import 'package:chatty_pal/blocs/basic_auth_provider_bloc/basic_auth_provider_bloc.dart';
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
                    Text(
                      'Login',
                      style: TextStyle(
                          fontSize: screenHeight / screenWidth * 40,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: screenHeight / 10,
                    ),
                    customTextField(
                        (String) {},
                        TextInputType.emailAddress,
                        false,
                        _emailController,
                        'Email',
                        const Icon(Icons.email_outlined),
                        screenWidth,
                        Colors.black,
                        Colors.black45),
                    SizedBox(
                      height: screenHeight / 50,
                    ),
                    customTextField((String){},
                        null,
                        true,
                        _passwordController,
                        'Password',
                        const Icon(Icons.password_rounded),
                        screenWidth,
                        Colors.black,
                        Colors.black45),
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
                        return customButton(Colors.black, Colors.white, 'Login',
                            () async {
                          FocusScope.of(context).unfocus();
                          context.read<BasicAuthProviderBloc>().add(LoginEvent(
                              _emailController.text, _passwordController.text));
                        }, screenWidth, screenHeight);
                      }
                    }), listener: (context, state) {
                      if (state is LoginSuccessState) {
                        ToastManager.show(
                            context, 'Login Done Successfuly', Colors.green);
                        Navigator.of(context)
                            .pushReplacementNamed('homeScreen');
                      } else if (state is LoginErrorState) {
                        ToastManager.show(
                            context, state.errorMeessage, Colors.red);
                      }
                    }),
                    SizedBox(
                      height: screenHeight / 50,
                    ),
                    customButton(Colors.black, Colors.white,
                        "Don't have an account? Register", () {
                      Navigator.of(context)
                          .pushReplacementNamed('registerScreen');
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
