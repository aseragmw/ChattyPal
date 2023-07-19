import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:chatty_pal/models/user.dart' as user;
import 'package:chatty_pal/services/Auth/auth_exceptions.dart';
import 'package:chatty_pal/services/Auth/basic_auth_provider.dart';
import 'package:chatty_pal/services/Firestore/firestore_constants.dart';
import 'package:chatty_pal/services/Firestore/firestore_database.dart';
import 'package:chatty_pal/utils/app_constants.dart';
import 'package:chatty_pal/utils/cache_manager.dart';
import 'package:chatty_pal/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:meta/meta.dart';
part 'basic_auth_provider_event.dart';

part 'basic_auth_provider_state.dart';

class BasicAuthProviderBloc
    extends Bloc<BasicAuthProviderEvent, BasicAuthProviderState> {
  BasicAuthProviderBloc() : super(BasicAuthProviderInitial()) {
    on<BasicAuthProviderEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<LoginEvent>((event, emit) async {
      emit(LoginLoadingState());
      try {
        await BasicAuthProvider.login(event.email, event.password);
       // await FirestoreDatabase.getAllUsers();
        // await FirestoreDatabase.getAllChats();
        emit(LoginSuccessState());
      } on BasicAuthException catch (e) {
        if (e is InvalidEmailAuthException) {
          log('Invalid Email');
          emit(LoginErrorState('Please Enter a valid email'));
        } else if (e is UserNotFoundAuthException) {
          log('User not found');
          emit(LoginErrorState('Wrong Credientials'));
        } else if (e is UserDisabledAuthException) {
          log('user disabled');
          emit(LoginErrorState('Something went wrong, contact us for help'));
        } else if (e is WrongPasswordAuthException) {
          log('wrong password');
          emit(LoginErrorState('Wrong Credientials'));
        } else if (e is OperationErrorAuthException) {
          log('Login operation failed');
          emit(LoginErrorState('Something went wrong'));
        }
      } catch (e) {
        log(e.toString());
        emit(LoginErrorState('Something went wrong'));
      }
    });
    on<RegisterEvent>((event, emit) async {
      emit(RegisterLoadingState());
      try {
        final result = await BasicAuthProvider.register(
            event.name, event.email, event.password);
        final newUser =
            user.User(event.name, result.user!.uid, event.email, '', '');
        await FirestoreDatabase.addUser(newUser);
        await BasicAuthProvider.login(event.email, event.password);
        log('akher register function');
        emit(RegisterSuccessState());
      } on BasicAuthException catch (e) {
        if (e is InvalidEmailAuthException) {
          log('Invalid Email');
          emit(RegisterErrorState('Please enter a valid email'));
        } else if (e is EmailAlreadyInUseAuthException) {
          log('Email already in use');
          emit(RegisterErrorState('Email already in use'));
        } else if (e is WeakPasswordAuthException) {
          log('Weak Password');
          emit(RegisterErrorState('Please enter a stronger password'));
        } else if (e is OperationNotAllowedAuthException) {
          log('Operation not allowed');
          emit(RegisterErrorState('Something went wrong, contact us for help'));
        } else if (e is OperationErrorAuthException) {
          log('Register Operation Failed');
          emit(RegisterErrorState('Something went wrong'));
        }
      } catch (e) {
        log(e.toString());
        emit(RegisterErrorState('Something went wrong'));
      }
    });
    on<LogoutEvent>((event, emit) async {
      emit(LogoutLoadingState());
      try {
        await BasicAuthProvider.logout();
        emit(LogoutSuccessState());
      } on BasicAuthException catch (e) {
        if (e is OperationErrorAuthException) {
          log('Log out failed');
          emit(LogoutErrorState('Something went wrong'));
        }
      } catch (e) {
        log(e.toString());
        emit(LogoutErrorState('Something went wrong'));
      }
    });

    on<ChangeUserDisplayNameEvent>((event, emit) async {
      emit(ChangeUserDisplayNameLodaingState());
      try {
        await BasicAuthProvider.updateUserDisplayName(event.name);
        await FirestoreDatabase.updateUser(
            AppConstants.userId!, {userDocUserName: event.name});
        emit(ChangeUserDisplayNameSuccessState());
      } on BasicAuthException catch (e) {
        if (e is OperationErrorAuthException) {
          log('Changing Display Name failed');
          emit(ChangeUserDisplayNameErrorState('Something went wrong'));
        } else {
          log('Changing Display Name failed');
          emit(ChangeUserDisplayNameErrorState('Something went wrong'));
        }
      } catch (e) {
        log(e.toString());
        emit(ChangeUserDisplayNameErrorState('Something went wrong'));
      }
    });

    on<ChangeUserEmailEvent>((event, emit) async {
      emit(ChangeUserEmailLodaingState());
      try {
        await BasicAuthProvider.updateUserEmail(event.email);
        await FirestoreDatabase.updateUser(
            AppConstants.userId!, {userDocUserEmail: event.email});
        emit(ChangeUserEmailSuccessState());
      } on BasicAuthException catch (e) {
        if (e is InvalidEmailAuthException) {
          log('Invalid Email To Change ');
          emit(ChangeUserEmailErrorState('Invalid Email To Change'));
        } else if (e is EmailAlreadyInUseAuthException) {
          log(' Email already in use  ');
          emit(ChangeUserEmailErrorState('Email Already In Use'));
        } else if (e is RequiresRecentLoginAuthException) {
          log('Requires relogin');
          emit(ChangeUserEmailErrorState(
              'Please relogin to change your info..'));
        } else if (e is OperationErrorAuthException) {
          log('Something went wrong');
          emit(ChangeUserEmailErrorState('Something went wrong'));
        } else {
          log('Something went wrong');
          emit(ChangeUserEmailErrorState('Something went wrong'));
        }
      } catch (e) {
        log(e.toString());
        emit(ChangeUserEmailErrorState('Something went wrong'));
      }
    });

    on<ChangeUserPasswordEvent>((event, emit) async {
      emit(ChangeUserPasswordLodaingState());
      try {
        await BasicAuthProvider.updateUserPassword(event.password);
        emit(ChangeUserPasswordSuccessState());
      } on BasicAuthException catch (e) {
        if (e is WeakPasswordAuthException) {
          log('Please enter a stronger password');
          emit(
              ChangeUserPasswordErrorState('Please enter a stronger password'));
        } else if (e is RequiresRecentLoginAuthException) {
          log('Requires relogin');
          emit(ChangeUserPasswordErrorState(
              'Please relogin to change your info..'));
        } else if (e is OperationErrorAuthException) {
          log('Something went wrong');
          emit(ChangeUserPasswordErrorState('Something went wrong'));
        } else {
          log('Something went wrong');
          emit(ChangeUserPasswordErrorState('Something went wrong'));
        }
      } catch (e) {
        log(e.toString());
        emit(ChangeUserPasswordErrorState('Something went wrong'));
      }
    });

    on<ChangeUserBioEvent>((event, emit) async {
      emit(ChangeUserBioLodaingState());
      try {
        await FirestoreDatabase.updateUser(
            AppConstants.userId!, {'bio': event.bio});
        emit(ChangeUserBioSuccessState());
      } on BasicAuthException catch (e) {
        log('Something went wrong');
        emit(ChangeUserBioErrorState('Something went wrong'));
      } catch (e) {
        log(e.toString());
        emit(ChangeUserPasswordErrorState('Something went wrong'));
      }
    });

    on<SaveUserExtraDataEvent>((event, emit) async {
      emit(SaveUserExtraDataLodaingState());
      
      try {
        if (event.photo != null) {
        final fileName = basename(event.photo!.path);
        final destination = 'files/$fileName';

        try {
          final ref = FirebaseStorage.instance.ref(destination).child('file/');
          final uploadTask = await ref.putFile(event.photo!);
          final url = await uploadTask.ref.getDownloadURL();
          await FirestoreDatabase.updateUser(
              AppConstants.userId!, {'imgUrl': url});
          await FirebaseAuth.instance.currentUser!.updatePhotoURL(url);

          event.photoPath = url;
        } catch (e) {
          log('error occured');
        }
        AppConstants.userProfileImgUrl = event.photoPath;
        CacheManager.setValue(userProfileImgUrlCacheKey, event.photoPath);
      }
      await FirestoreDatabase.updateUser(
          AppConstants.userId!, {'bio': event.bioText});
      if (event.bioText.isEmpty) {
        AppConstants.userBio = '';
        CacheManager.setValue(userBioCacheKey, '');
      } else {
        AppConstants.userBio = event.bioText;
        CacheManager.setValue(userBioCacheKey, event.bioText);
      }
      } catch (e) {
        emit(SaveUserExtraDataErrorState('Something went wrong'));
      }
    });
  }
}
