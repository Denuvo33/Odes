part of 'login_bloc.dart';

abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final BuildContext? context;
  final bool isLoading;
  final String email;
  final String password;
  LoginButtonPressed(
      {required this.email,
      required this.password,
      this.context,
      this.isLoading = false});
}

class LoginLogoutButtonPressed extends LoginEvent {
  final BuildContext? context;
  LoginLogoutButtonPressed({this.context});
}

class CreateAccount extends LoginEvent {
  final BuildContext? context;
  final String email, password;
  CreateAccount({
    this.context,
    required this.email,
    required this.password,
  });
}
