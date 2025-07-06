part of 'login_bloc.dart';

class LoginState extends Equatable {
  final bool isLoading;
  final String? errorMessage, username;
  const LoginState({this.errorMessage, this.isLoading = false, this.username});

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    username,
  }) =>
      LoginState(
          isLoading: isLoading ?? this.isLoading,
          errorMessage: errorMessage,
          username: username ?? this.username);
  @override
  List<Object?> get props => [isLoading, errorMessage, username];
}
