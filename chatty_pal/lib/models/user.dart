import 'package:chatty_pal/services/Firestore/firestore_constants.dart';

class User {
  final String userName;
  final String userId;
  final String userEmail;
  final String userProfileImage;

  User(this.userName, this.userId, this.userEmail, this.userProfileImage);
  factory User.fromJson(Map<String,dynamic>userData) => User(userData[userDocUserName],userData[userDocUserId], userData[userDocUserEmail], userData[userDocUserImgUrl]);
}
