import 'dart:async';
import 'package:chatty_pal/blocs/chats_bloc/chats_bloc.dart';
import 'package:chatty_pal/utils/app_constants.dart';
import 'package:chatty_pal/utils/cache_manager.dart';
import 'package:chatty_pal/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
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
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.message_outlined,
            size: screenHeight / screenWidth * 130,
            color: Colors.white30,
          ),
          Text(
            'ChattyPal',
            style: TextStyle(
              fontSize: screenHeight / screenWidth * 18,
              color: Colors.white38,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      )),
    );
  }
}
// SizedBox(
//         child: TextLiquidFill(
//           loadDuration: Duration(seconds: 2),
//           loadUntil: 0.6,
//           text: 'ChattyPal',
//           waveColor: Colors.grey,
//           boxBackgroundColor: Colors.black,
//           textStyle: const TextStyle(
//             fontSize: 80.0,
//             fontWeight: FontWeight.bold,
//           ),
//           boxHeight: 300.0,
//         ),
//       )