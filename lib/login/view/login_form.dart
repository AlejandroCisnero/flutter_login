import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/login/bloc/bloc/login_bloc.dart';
import 'package:formz/formz.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                const SnackBar(content: Text('Authentication Failure')));
        }
      },
      child: Align(
        alignment: const Alignment(0, 1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            _usernameInput(),
            Padding(
              padding: EdgeInsets.all(12),
            ),
            _passwordInput(),
            Padding(
              padding: EdgeInsets.all(12),
            ),
            _loginButton(),
          ],
        ),
      ),
    );
  }
}

class _usernameInput extends StatelessWidget {
  const _usernameInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) {
        //To only build when the old value its different from the new one
        return previous.username.value != current.username.value;
      },
      builder: (context, state) {
        return TextFormField(
          key: const Key('loginForm_usernameInput_textField'),
          decoration: InputDecoration(
            labelText: 'username',
            errorText: state.username.invalid ? 'invalid username' : null,
          ),
          onChanged: (username) {
            context.read<LoginBloc>().add(LoginUsernameChange(
                username)); //to trigger an event in the LoginBloc
          },
        );
      },
    );
  }
}

class _passwordInput extends StatelessWidget {
  const _passwordInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) {
        return previous.password.value != current.password.value;
      },
      builder: (context, state) {
        return TextFormField(
          key: const Key('loginForm_passwordInput_textField'),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'password',
            errorText: state.password.invalid ? 'invalid password' : null,
          ),
          onChanged: (password) {
            context.read<LoginBloc>().add(LoginPasswordChange(password));
          },
        );
      },
    );
  }
}

class _loginButton extends StatelessWidget {
  const _loginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                onPressed: state.status.isValid
                    ? () {
                        context.read<LoginBloc>().add(const LoginSubmit());
                      }
                    : null,
                child: const Text('Login'),
              );
      },
    );
  }
}
