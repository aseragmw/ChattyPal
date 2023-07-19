part of 'basic_auth_provider_bloc.dart';

@immutable
abstract class BasicAuthProviderEvent {}

class LoginEvent extends BasicAuthProviderEvent {
  final String email;
  final String password;
  LoginEvent(this.email, this.password);
}

class RegisterEvent extends BasicAuthProviderEvent {
  final String name;
  final String email;
  final String password;
  RegisterEvent(this.email, this.password, this.name);
}

class LogoutEvent extends BasicAuthProviderEvent {}

class ChangeUserDisplayNameEvent extends BasicAuthProviderEvent {
  final String name;
  ChangeUserDisplayNameEvent(this.name);
}

class ChangeUserEmailEvent extends BasicAuthProviderEvent {
  final String email;
  ChangeUserEmailEvent(this.email);
}

class ChangeUserPasswordEvent extends BasicAuthProviderEvent {
  final String password;
  ChangeUserPasswordEvent(this.password);
}

class ChangeUserBioEvent extends BasicAuthProviderEvent {
  final String bio;
  ChangeUserBioEvent(this.bio);
}


class SaveUserExtraDataEvent extends BasicAuthProviderEvent {
   File? photo;
   String? photoPath;
   String bioText;

  SaveUserExtraDataEvent( this.photo, this.photoPath, this.bioText);
}
