import 'package:chatty_pal/utils/cache_manager.dart';
import 'package:chatty_pal/utils/constants.dart';

class AppConstants {
  static late bool? userIsLoggedIn;
  static late String? userName;
  static late String? userId;
  static late String? userEmail;
  static late String? userPassword;
  static late String? userProfileImgUrl;
  static late String? userBio;

  static void initAppConstants() async {
    userName = await CacheManager.getValue(userNameCacheKey);
    userId = await CacheManager.getValue(userIdCacheKey);
    userIsLoggedIn = await CacheManager.getValue(userIsLoggedInCacheKey);
    userEmail = await CacheManager.getValue(userEmailCacheKey);
    userPassword = await CacheManager.getValue(userPasswordCacheKey);
    userProfileImgUrl = await CacheManager.getValue(userProfileImgUrlCacheKey);
    userBio = await CacheManager.getValue(userBioCacheKey);
  }
}
