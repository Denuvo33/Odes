import 'package:flutter/material.dart';
import 'package:todo_with_nodejs/Screen/create_todos_screen.dart';
import 'package:todo_with_nodejs/Screen/home_screen.dart';
import 'package:todo_with_nodejs/Screen/login_screen.dart';
import 'package:todo_with_nodejs/Screen/todos_screen.dart';
import 'package:todo_with_nodejs/bloc/todos_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_with_nodejs/services/notif_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotifServices().init();
  runApp(BlocProvider(
    create: (context) => TodosBloc(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const LoginScreen(),
        '/yourtodos': (context) => const TodosScreen(),
        '/create': (context) => const CreateTodosScreen(),
        '/home': (context) => const HomeScreen(),
      },
      initialRoute: '/',
    );
  }
}
