// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:chatty_pal/models/user.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

// class RecieverProfile extends StatelessWidget {
//   RecieverProfile({super.key, required this.user});
//   final User user;

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     return GestureDetector(
//         onTap: () {
//           FocusScope.of(context).unfocus();
//         },
//         child: Scaffold(
//             body: SingleChildScrollView(
//           child: Column(
//             children: [
//               // Container(
//               //   color: Color.fromRGBO(9, 77, 61, 1),
//               //   height: screenHeight * 0.2,
//               // ),
//               Stack(children: <Widget>[
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: <Widget>[
//                     Container(
//                       width: MediaQuery.of(context).size.width,
//                       height: 300,
//                       color: Colors.grey,
//                     ),
//                   ],
//                 ),
//                 Positioned(
//                   top: 280,
//                   left: 50,
//                   right: 50,
//                   child: TextButton(
//                     child: Text("Your Button"),
//                     onPressed: () {},
//                   ),
//                 )
//               ]),
//               Stack(
//                 children: <Widget>[
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: <Widget>[
//                       Container(
//                         width: screenWidth,
//                         height: 300,
//                         color: Colors.grey,
//                       ),
//                     ],
//                   ),
//                   Positioned(
//                     top: 280,
//                     left: 50,
//                     right: 50,
//                     child: CircleAvatar(
//                       child: ClipOval(
//                           child: (user.userProfileImage != null ||
//                                   user.userProfileImage != '')
//                               ? CachedNetworkImage(
//                                   imageUrl: user.userProfileImage,
//                                   width: screenHeight / screenWidth * 50,
//                                   height: screenHeight / screenWidth * 50,
//                                 )
//                               : Icon(Icons.person)),
//                     ),
//                   )
//                 ],
//               ),
//               // Stack(
//               //   children: [
//               //     Positioned(
//               //       top: 30,
//               //       child:
//               //     )
//               //   ],
//               // )
//             ],
//           ),
//         )));
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatty_pal/models/user.dart';
import 'package:chatty_pal/utils/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class RecieverProfileScreen extends StatelessWidget {
  RecieverProfileScreen({super.key, required this.recieverUser});
  final User recieverUser;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Color.fromRGBO(9, 77, 61, 1),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth / 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: screenHeight / screenHeight * 150,
                      child: ClipOval(
                          child: (recieverUser.userProfileImage != null ||
                                  recieverUser.userProfileImage != '')
                              ? CachedNetworkImage(
                                  imageUrl: recieverUser.userProfileImage,
                                  width: screenHeight / screenWidth * 150,
                                  height: screenHeight / screenWidth * 150,
                                )
                              : Icon(Icons.person)),
                    ),
                    SizedBox(
                      height: screenHeight / 50,
                    ),
                    Text(
                      recieverUser.userName,
                      style: TextStyle(
                          color: Colors.white54,
                          fontSize: screenHeight / screenWidth * 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: screenHeight / 50,
                    ),
                    Text(
                      recieverUser.userBio,
                      style: TextStyle(
                          color: Colors.white54,
                          fontSize: screenHeight / screenWidth * 20,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: screenHeight / 50,
                    ),
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
