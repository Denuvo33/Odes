import 'package:equatable/equatable.dart' show Equatable;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(state.copyWith(
        isLoading: true,
      ));
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: event.email, password: event.password);
        emit(state.copyWith(isLoading: false));
        print('Succes login');
        // Navigator.pushNamed(event.context!, '/home');
      } on FirebaseAuthException {
        emit(state.copyWith(
            errorMessage: 'email or password is wrong', isLoading: false));
      }
    });

    on<CreateAccount>((event, emit) async {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: event.email, password: event.password);
        emit(state.copyWith(isLoading: false));
        print('Succes Create Account');
        // Navigator.pushNamed(event.context!, '/home');
      } on FirebaseAuthException catch (e) {
        print('error e:$e');
        emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
      }
    });

    on<LoginLogoutButtonPressed>((event, emit) {});
  }
}
