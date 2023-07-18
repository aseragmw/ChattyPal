part of 'basic_auth_provider_bloc.dart';

@immutable
abstract class BasicAuthProviderState {}

class BasicAuthProviderInitial extends BasicAuthProviderState {}

class LoginLoadingState extends BasicAuthProviderState {}

class LoginSuccessState extends BasicAuthProviderState {}

class LoginErrorState extends BasicAuthProviderState {
  final String errorMeessage;
  LoginErrorState(this.errorMeessage);
}

class RegisterLoadingState extends BasicAuthProviderState {}

class RegisterSuccessState extends BasicAuthProviderState {}

class RegisterErrorState extends BasicAuthProviderState {
  final String errorMessage;
  RegisterErrorState(this.errorMessage);
}

class LogoutLoadingState extends BasicAuthProviderState {}

class LogoutSuccessState extends BasicAuthProviderState {}

class LogoutErrorState extends BasicAuthProviderState {
  final String errorMessage;
  LogoutErrorState(this.errorMessage);
}

class ChangeUserDisplayNameLodaingState extends BasicAuthProviderState {}

class ChangeUserDisplayNameSuccessState extends BasicAuthProviderState {}

class ChangeUserDisplayNameErrorState extends BasicAuthProviderState {
  final String errorMessage;
  ChangeUserDisplayNameErrorState(this.errorMessage);
}


class ChangeUserEmailLodaingState extends BasicAuthProviderState {}

class ChangeUserEmailSuccessState extends BasicAuthProviderState {}

class ChangeUserEmailErrorState extends BasicAuthProviderState {
  final String errorMessage;
  ChangeUserEmailErrorState(this.errorMessage);
}


class ChangeUserPasswordLodaingState extends BasicAuthProviderState {}

class ChangeUserPasswordSuccessState extends BasicAuthProviderState {}

class ChangeUserPasswordErrorState extends BasicAuthProviderState {
  final String errorMessage;
  ChangeUserPasswordErrorState(this.errorMessage);
}

class ChangeUserBioLodaingState extends BasicAuthProviderState {}

class ChangeUserBioSuccessState extends BasicAuthProviderState {}

class ChangeUserBioErrorState extends BasicAuthProviderState {
  final String errorMessage;
  ChangeUserBioErrorState(this.errorMessage);
}


class SaveUserExtraDataLodaingState extends BasicAuthProviderState {}

class SaveUserExtraDataSuccessState extends BasicAuthProviderState {}

class SaveUserExtraDataErrorState extends BasicAuthProviderState {
  final String errorMessage;
  SaveUserExtraDataErrorState(this.errorMessage);
}

