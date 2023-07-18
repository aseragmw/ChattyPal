import 'package:chatty_pal/services/Firestore/firestore_constants.dart';

class User {
  final String userName;
  final String userId;
  final String userEmail;
  final String userProfileImage;
  final String userBio;

  User(this.userName, this.userId, this.userEmail, this.userProfileImage,this.userBio);
  factory User.fromJson(Map<String,dynamic>userData) => User(userData[userDocUserName],userData[userDocUserId], userData[userDocUserEmail], userData[userDocUserImgUrl],userData['bio']);
}
