part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginUsernameChange extends LoginEvent {
  const LoginUsernameChange(this.username);

  final String username;
}

class LoginPasswordChange extends LoginEvent {
  const LoginPasswordChange(this.password);

  final String password;
}

class LoginSubmit extends LoginEvent {
  const LoginSubmit();
}
