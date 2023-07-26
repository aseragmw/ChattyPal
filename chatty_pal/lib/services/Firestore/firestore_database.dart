import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:chatty_pal/models/user.dart';
import 'package:chatty_pal/services/Firestore/firestore_constants.dart';
import 'package:chatty_pal/utils/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreDatabase {
  static final _firestoreDatabase = FirebaseFirestore.instance;
  static List<User> allUsers = [];

  static Future<void> addUser(User user) async {
    try {
      await _firestoreDatabase
          .collection(usersCollectionPath)
          .doc(user.userId)
          .set({
        userDocUserName: user.userName,
        userDocUserId: user.userId,
        userDocUserEmail: user.userEmail,
        userDocUserImgUrl: user.userProfileImage,
        'recordsCount': 0
      });
    } catch (e) {}
  }

  static Future<void> updateUser(
      String userId, Map<String, dynamic> newData) async {
    try {
      await _firestoreDatabase
          .collection(usersCollectionPath)
          .doc(userId)
          .update(newData);
    } catch (e) {}
  }

  static Future<void> getAllUsers() async {
    try {
      final result = await _firestoreDatabase
          .collection(usersCollectionPath)
          .get()
          .then((value) {
        for (var docSnapshot in value.docs) {
          final user = User.fromJson(docSnapshot.data());
          bool found = false;
          for (var element in allUsers) {
            if (user.userId == element.userId) {
              found = true;
            }
          }
          if (!found) {
            allUsers.add(user);
          }
        }
      });
    } catch (e) {}
  }

  // static Future<void> sendMessage(
  //     String fromId, String toId, String content, DateTime timeStamp) async {
  //   try {
  //     await _firestoreDatabase.collection('messages').add({
  //       'fromId': fromId,
  //       'toId': toId,
  //       'content': content,
  //       'timeStamp': timeStamp
  //     });
  //   } catch (e) {}
  // }

  static Future<void> sendAMessage(String fromId, String toId, dynamic content,
      DateTime timeStamp, String type) async {
    try {
      _firestoreDatabase
          .collection('chats')
          .where('fromId', isEqualTo: fromId)
          .where('toId', isEqualTo: toId)
          .count()
          .get()
          .then((value) async {
        if (value.count != 0) {
          _firestoreDatabase
              .collection('chats')
              .where('fromId', isEqualTo: fromId)
              .where('toId', isEqualTo: toId)
              .get()
              .then((value) {
            final ref = value.docs[0].reference.collection('messages').add({
              'fromId': fromId,
              'toId': toId,
              'content': content,
              'timeStamp': timeStamp,
              'type': type
            });
          });
        } else {
          _firestoreDatabase.collection('chats').add({
            'fromId': fromId,
            'toId': toId,
          }).then((value) {
            value.collection('messages').add({
              'fromId': fromId,
              'toId': toId,
              'content': content,
              'timeStamp': timeStamp,
              'type': type
            });
          });
        }
      }).onError((error, stackTrace) {});
      if (fromId != toId) {
        _firestoreDatabase
            .collection('chats')
            .where('fromId', isEqualTo: toId)
            .where('toId', isEqualTo: fromId)
            .count()
            .get()
            .then((value) {
          if (value.count != 0) {
            _firestoreDatabase
                .collection('chats')
                .where('fromId', isEqualTo: toId)
                .where('toId', isEqualTo: fromId)
                .get()
                .then((value) {
              value.docs[0].reference.collection('messages').add({
                'fromId': fromId,
                'toId': toId,
                'content': content,
                'timeStamp': timeStamp,
                'type': type
              });
            });
          } else {
            _firestoreDatabase.collection('chats').add({
              'fromId': toId,
              'toId': fromId,
            }).then((value) {
              value.collection('messages').add({
                'fromId': fromId,
                'toId': toId,
                'content': content,
                'timeStamp': timeStamp,
                'type': type
              });
            });
          }
        }).onError((error, stackTrace) {});
      }

      //await _firestoreDatabase.collection('chats').
    } catch (e) {}
  }

  static Future<void> checkChatExist(String fromId, String toId) async {
    await _firestoreDatabase
        .collection('chats')
        .where('fromId', isEqualTo: fromId)
        .where('toId', isEqualTo: toId)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        _firestoreDatabase.collection('chats').add({
          'fromId': toId,
          'toId': fromId,
        });
        _firestoreDatabase.collection('chats').add({
          'fromId': fromId,
          'toId': toId,
        });
      }
    });
  }

  static Future<void> deleteChat(String fromId, String toId) async {
    try {
      await _firestoreDatabase
          .collection('chats')
          .where('fromId', isEqualTo: fromId)
          .where('toId', isEqualTo: toId)
          .get()
          .then((value) {
        value.docs.first.reference.delete();
      });
    } catch (e) {}
  }

  static Future<void> deleteAMessage(
      String fromId, String toId, DateTime timeStamp) async {
    try {
      await _firestoreDatabase
          .collection('chats')
          .where('fromId', isEqualTo: fromId)
          .where('toId', isEqualTo: toId)
          .get()
          .then((value) {
        value.docs.first.reference
            .collection('messages')
            .where('timeStamp', isEqualTo: timeStamp)
            .get()
            .then((value) {
          value.docs.first.reference.delete();
        });
      });
    } catch (e) {}
  }

  static Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getChat(
      String fromId, String toId) async {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> res = Stream.empty();
      await _firestoreDatabase
          .collection('chats')
          .where('fromId', isEqualTo: fromId)
          .where('toId', isEqualTo: toId)
          .get()
          .then((value) async {
        res = value.docs.first.reference
            .collection('messages')
            .orderBy('timeStamp', descending: false)
            .snapshots();
      });
      return res;
    } catch (e) {
      return Stream.empty();
    }
  }

  static Future<Stream<List<User>>> getAllChats() async {
    try {
      return _firestoreDatabase
          .collection('chats')
          .where('fromId', isEqualTo: AppConstants.userId!)
          .snapshots()
          .asyncMap((event) async {
        final List<User> resultList = [];

        for (var element in event.docs) {
          final user = await getUserById(element.data()['toId']).then((value) {
            resultList.add(value);
          });
        }
        for (var element in resultList) {
          log(element.userName);
        }
        return resultList;
      });
    } catch (e) {
      throw e;
    }
  }

  static Future<User> getUserById(String uid) async {
    try {
      final userData = await _firestoreDatabase
          .collection(usersCollectionPath)
          .where('id', isEqualTo: uid)
          .get();
      log(userData.docs.first.data().toString());
      return User.fromJson(userData.docs.first.data());
    } catch (e) {
      log(e.toString());
      throw e;
    }
  }

  static Future<String> getUserProfilePicture(String photoPath) async {
    try {
      final userData = await _firestoreDatabase
          .collection(usersCollectionPath)
          .where('id', isEqualTo: AppConstants.userId)
          .get();
      final user = User.fromJson(userData.docs.first.data());
      log('my url is ${photoPath}');
      final imgUrl =
          await FirebaseStorage.instance.refFromURL(photoPath).getDownloadURL();
      return imgUrl;
    } catch (e) {
      log(e.hashCode.toString());
      log(e.toString());
      log(e.hashCode.toString());
      throw e;
    }
  }

  static Future<String> getAnotherUserProfilePicture(String uid) async {
    try {
      final userData = await _firestoreDatabase
          .collection(usersCollectionPath)
          .where('id', isEqualTo: uid)
          .get();
      final user = User.fromJson(userData.docs.first.data());
      log('another url is ${user.userProfileImage}');
      final imgUrl = await FirebaseStorage.instance
          .refFromURL(user.userProfileImage)
          .getDownloadURL();
      log('ba3do');
      return imgUrl;
    } catch (e) {
      log(e.hashCode.toString());
      log(e.toString());
      log(e.hashCode.toString());
      throw e;
    }
  }
}
