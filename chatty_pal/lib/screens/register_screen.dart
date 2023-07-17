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
                    Text(
                      'Register',
                      style: TextStyle(
                          fontSize: screenHeight / screenWidth * 40,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: screenHeight / 10,
                    ),
                    customTextField((String){},
                        null,
                        false,
                        _nameController,
                        'Name',
                        const Icon(Icons.person),
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
                      listener: (context, state) {
                        if (state is RegisterSuccessState) {
                          ToastManager.show(context,
                              "Register completed successfuly", Colors.green);
                          Navigator.of(context)
                              .pushReplacementNamed('loginScreen');
                        } else if (state is RegisterErrorState) {
                          ToastManager.show(
                              context, state.errorMessage, Colors.redAccent);
                        }
                      },
                      builder: (context, state) {
                        if (state is RegisterLoadingState) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          );
                        } else {
                          return customButton(
                              Colors.black, Colors.white, 'Register', () {
                                
                            FocusScope.of(context).unfocus();
                            context.read<BasicAuthProviderBloc>().add(
                                RegisterEvent(
                                    _emailController.text,
                                    _passwordController.text,
                                    _nameController.text));
                          }, screenWidth, screenHeight);
                        }
                      },
                    ),
                    SizedBox(
                      height: screenHeight / 50,
                    ),
                    customButton(
                        Colors.black, Colors.white, 'Have an account? Login',
                        () {
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
