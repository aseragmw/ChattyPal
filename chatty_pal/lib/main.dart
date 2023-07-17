import 'dart:developer';
import 'package:chatty_pal/blocs/basic_auth_provider_bloc/basic_auth_provider_bloc.dart';
import 'package:chatty_pal/blocs/chats_bloc/chats_bloc.dart';
import 'package:chatty_pal/firebase_options.dart';
import 'package:chatty_pal/screens/change_password_screen.dart';
import 'package:chatty_pal/screens/chat_screen.dart';
import 'package:chatty_pal/screens/home_screen.dart';
import 'package:chatty_pal/screens/login_screen.dart';
import 'package:chatty_pal/screens/register_screen.dart';
import 'package:chatty_pal/screens/splash_screen.dart';
import 'package:chatty_pal/services/Firestore/firestore_database.dart';
import 'package:chatty_pal/utils/app_constants.dart';
import 'package:chatty_pal/utils/cache_manager.dart';
import 'package:chatty_pal/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatty_pal/screens/profile_screen.dart';

void main() async {
  //test
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final name = await CacheManager.getValue(userNameCacheKey);
  final id = await CacheManager.getValue(userIdCacheKey);
  final isLoggedIn = await CacheManager.getValue(userIsLoggedInCacheKey);
  final emial = await CacheManager.getValue(userEmailCacheKey);
  final password = await CacheManager.getValue(userPasswordCacheKey);
  final imgUrl = await CacheManager.getValue(userProfileImgUrlCacheKey);
  log(isLoggedIn.toString());
  log(name.toString());
  log(id.toString());
  log(emial.toString());
  log(password.toString());
  log(imgUrl.toString());
  //TODO remove this later
  AppConstants.initAppConstants();
  await FirestoreDatabase.getAllUsers();
  runApp(ChattyPal());
}

class ChattyPal extends StatelessWidget {
  const ChattyPal({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BasicAuthProviderBloc(),
        ),
         BlocProvider(
          create: (context) => ChatsBloc(),
        ),
      ],
      child: MaterialApp(
        useInheritedMediaQuery: true,
        debugShowCheckedModeBanner: false,
        routes: {
          "loginScreen": (context) => LoginScreen(),
          "registerScreen": (context) => RegisterScreen(),
          "homeScreen": (context) => HomeScreen(),
          "profileScreen": (context) => ProfileScreen(),
          "changePassowordScreen": (context) => ChangePasswordScreen(),
         // "searchScreen": (context) => SearchScreen(),
        },
        home: SplashScreen(),
      ),
    );
  }
}
