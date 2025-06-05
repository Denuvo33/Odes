import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_with_nodejs/bloc/todos_bloc.dart';

class FullTodosScreen extends StatelessWidget {
  final String title;
  final int id;
  const FullTodosScreen({super.key, required this.title, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              Text(title),
              ElevatedButton(
                onPressed: () {
                  context.read<TodosBloc>().add(CompleteTodoEvent(index: id));
                },
                child: Text('Mark as Completed'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
