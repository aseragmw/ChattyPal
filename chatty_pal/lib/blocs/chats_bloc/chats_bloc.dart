import 'package:bloc/bloc.dart';
import 'package:chatty_pal/models/user.dart';
import 'package:chatty_pal/services/Firestore/firestore_database.dart';
import 'package:chatty_pal/utils/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'chats_event.dart';
part 'chats_state.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  static var chatsStream = Stream.empty();
  ChatsBloc() : super(ChatsInitial()) {
    on<ChatsEvent>((event, emit) {});

    on<GetChatStreamEvent>((event, emit) async {
      emit(GettingChatStreamLoadingState());
      try {
        await FirestoreDatabase.checkChatExist(
            AppConstants.userId!, event.reciverUser.userId);
        final chat = await FirestoreDatabase.getChat(
            AppConstants.userId!, event.reciverUser.userId);
        emit(GettingChatStreamSuccessState(chat));
      } catch (e) {
        emit(GettingChatStreamErrorState());
      }
    });

    on<GetAllChatsEvent>((event, emit) async {
      emit(GettingAllChatsLoadingState());
      try {
        final allChats = await FirestoreDatabase.getAllChats();
        chatsStream = allChats;
        emit(GettingAllChatsSuccessState(allChats));
      } catch (e) {
        emit(GettingChatStreamErrorState());
      }
    });

    on<GetSearchedChatsEvent>((event, emit) async {
      emit(GettingSearchedChatsLoadingState());
      try {
        FirestoreDatabase.allUsers = [];
        final allChats = await FirestoreDatabase.getAllUsers();
        List<User> result = [];
        for (var element in FirestoreDatabase.allUsers) {
          if (element.userName.toLowerCase().contains(event.userName) &&
              !result.contains(element)) {
            if (element.userId != AppConstants.userId) result.add(element);
          }
        }

        emit(GettingSearchedChatsSuccessState(result));
      } catch (e) {
        emit(GettingSearchedChatsErrorState());
      }
    });
  }
}
