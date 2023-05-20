import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_login/login/models/password.dart';
import 'package:flutter_login/login/models/username.dart';
import 'package:formz/formz.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const LoginState()) {
    on<LoginUsernameChange>(onUsernameChange);
    on<LoginPasswordChange>(onPasswordChange);
    on<LoginSubmit>(onLoginSubmit);
  }
  final AuthenticationRepository _authenticationRepository;

  void onUsernameChange(LoginUsernameChange event, Emitter emitter) {
    final username =
        Username.dirty(event.username); //Get the current username text
    //Emit a new state but with the new username text
    emitter(state.copyWith(
        username: username,
        status: Formz.validate([state.password, username])));
  }

  void onPasswordChange(LoginPasswordChange event, Emitter emitter) {
    final password = Password.dirty(event.password);
    emitter(state.copyWith(
        password: password,
        status: Formz.validate([state.username, password])));
  }

  Future<void> onLoginSubmit(LoginSubmit event, Emitter emitter) async {
    if (state.status.isValidated) {
      //If the form is valid?
      emitter(state.copyWith(status: FormzStatus.submissionInProgress));
      try {
        await _authenticationRepository.logIn(
            username: state.username.value, password: state.password.value);
        emitter(state.copyWith(status: FormzStatus.submissionSuccess));
      } catch (e) {
        emitter(state.copyWith(status: FormzStatus.submissionFailure));
      }
    } else {}
  }
}
