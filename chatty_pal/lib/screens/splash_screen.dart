import 'dart:async';
import 'package:chatty_pal/blocs/chats_bloc/chats_bloc.dart';
import 'package:chatty_pal/utils/app_constants.dart';
import 'package:chatty_pal/utils/cache_manager.dart';
import 'package:chatty_pal/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    Timer(const Duration(seconds: 1, milliseconds: 500), () async {
      final isLoggedIn = await CacheManager.getValue(userIsLoggedInCacheKey);
      if (context.mounted) {
        if (isLoggedIn != null && isLoggedIn) {
          AppConstants.initAppConstants();
          context.read<ChatsBloc>().add(GetAllChatsEvent());
          Navigator.of(context).pushReplacementNamed('homeScreen');
        } else {
          Navigator.of(context).pushReplacementNamed('loginScreen');
        }
      }
    });
    return Scaffold(
      backgroundColor: Color.fromRGBO(9, 77, 61, 1),
      body: Center(
          child: Image.asset(
                      'assets/images/logo2.png',
                      width: screenHeight / screenWidth * 120,
                      height: screenHeight / screenWidth * 120,
                    )),
    );
  }
}
