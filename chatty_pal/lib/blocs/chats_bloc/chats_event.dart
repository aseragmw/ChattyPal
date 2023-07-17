part of 'chats_bloc.dart';

@immutable
abstract class ChatsEvent {}

class GetChatStreamEvent extends ChatsEvent {
  final User reciverUser;

  GetChatStreamEvent(this.reciverUser);
}

class GetAllChatsEvent extends ChatsEvent {}

class GetSearchedChatsEvent extends ChatsEvent {
  final String userName;

  GetSearchedChatsEvent(this.userName);
}
