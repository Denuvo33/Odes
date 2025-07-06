import 'package:equatable/equatable.dart' show Equatable;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState()) {
    DatabaseReference db = FirebaseDatabase.instance.ref('users');
    on<LoginButtonPressed>((event, emit) async {
      emit(state.copyWith(
        isLoading: true,
      ));
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: event.email, password: event.password);
        emit(state.copyWith(isLoading: false));
        Navigator.pushNamedAndRemoveUntil(
            event.context!, '/home', (_) => false);
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
        db
            .child(FirebaseAuth.instance.currentUser!.uid)
            .update({'username': event.username});
        Navigator.pushNamedAndRemoveUntil(
            event.context!, '/home', (_) => false);
      } on FirebaseAuthException catch (e) {
        print('error e:$e');
        emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
      }
    });

    on<LoginLogoutButtonPressed>((event, emit) async {
      try {
        await FirebaseAuth.instance.signOut();
        Navigator.pushNamedAndRemoveUntil(
            event.context!, '/login', (_) => false);
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(event.context!).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
            ),
          ),
        );
      }
    });

    on<FetchUserData>((event, emit) async {
      await db
          .child(FirebaseAuth.instance.currentUser!.uid)
          .once()
          .then((value) {
        var data = value.snapshot.value;
        if (data != null && data is Map) {
          emit(state.copyWith(username: data['username']));
        }
      });
    });
  }
}
