import 'package:chatty_pal/blocs/basic_auth_provider_bloc/basic_auth_provider_bloc.dart';
import 'package:chatty_pal/services/Auth/basic_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                    Image.asset(
                      'assets/images/logo.png',
                      width: screenHeight / screenWidth * 120,
                      height: screenHeight / screenWidth * 120,
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    optionButton(screenWidth, screenHeight, () {
                      Navigator.of(context).pushNamed('accountScreen');
                    }, Icons.vpn_key, 'Account',
                        Color.fromRGBO(135, 182, 151, 1)),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    optionButton(screenWidth, screenHeight, () async {
                      context.read<BasicAuthProviderBloc>().add(LogoutEvent());
                     //  await BasicAuthProvider.logout();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          'loginScreen', (Route<dynamic> route) => false);
                    }, Icons.logout, 'Logout',
                        Color.fromRGBO(135, 182, 151, 1)),
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

Widget optionButton(
  double screenWidth,
  double screenHeight,
  Function() onPressed,
  IconData icon,
  String title,
  Color buttonColor,
) =>
    InkWell(
      onTap: onPressed,
      child: Container(
          height: screenHeight / 15,
          width: screenWidth,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: buttonColor),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: screenHeight / screenWidth * 20,
                ),
                SizedBox(
                  width: screenWidth * 0.07,
                ),
                Text(
                  title,
                  style: TextStyle(
                      color: Color.fromRGBO(9, 77, 61, 1),
                      fontSize: screenHeight / screenWidth * 13,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          )),
    );

// TextButton(
//         onPressed: onPressed,
//         child: Text(
//           title,
//           style: TextStyle(color: Colors.white),
//         ),
//       ),