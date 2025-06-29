part of 'login_bloc.dart';

class LoginState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  const LoginState({
    this.errorMessage,
    this.isLoading = false,
  });

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) =>
      LoginState(
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage,
      );
  @override
  List<Object?> get props => [isLoading, errorMessage];
}
