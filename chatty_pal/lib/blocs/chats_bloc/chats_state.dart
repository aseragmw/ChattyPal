part of 'chats_bloc.dart';

@immutable
abstract class ChatsState {}

class ChatsInitial extends ChatsState {}

class GettingChatStreamLoadingState extends ChatsState {}

class GettingChatStreamSuccessState extends ChatsState {
  final Stream<QuerySnapshot<Map<String, dynamic>>> chatStream;

  GettingChatStreamSuccessState(this.chatStream);
}

class GettingChatStreamErrorState extends ChatsState {}

class GettingAllChatsLoadingState extends ChatsState {}

class GettingAllChatsSuccessState extends ChatsState {
  final Stream<List<User>> allChats;

  GettingAllChatsSuccessState(this.allChats);
}

class GettingAllChatsErrorState extends ChatsState {}

class GettingSearchedChatsLoadingState extends ChatsState {}

class GettingSearchedChatsSuccessState extends ChatsState {
  final List<User> searchResult;

  GettingSearchedChatsSuccessState(this.searchResult);

}

class GettingSearchedChatsErrorState extends ChatsState {}
