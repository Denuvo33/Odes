// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:todo_with_nodejs/Model/todos_model.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:todo_with_nodejs/services/notif_services.dart';

part 'todos_event.dart';
part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  TodosBloc() : super(const TodosState()) {
    DatabaseReference db = FirebaseDatabase.instance
        .ref('users/${FirebaseAuth.instance.currentUser!.uid}');
    on<GetTodosEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        await db.once().then((value) {
          var data = value.snapshot.value;
          if (data != null && data is Map) {
            var todosMap = data['todos'];
            if (todosMap != null && todosMap is Map) {
              List<TodosModel> todosList = [];

              todosMap.forEach((key, value) {
                var todo =
                    TodosModel().fromMap(Map<String, dynamic>.from(value));
                todosList.add(todo);
              });
              emit(state.copyWith(todos: todosList, isLoading: false));
            }
          }
          emit(state.copyWith(isLoading: false));
        });
      } catch (e) {
        state.copyWith(isLoading: false);
        if (!event.context.mounted) return;
        ScaffoldMessenger.of(event.context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    on<CreateTodosEvent>((event, emit) async {
      var id = DateTime.now().millisecondsSinceEpoch;
      if (event.todos != null) {
        final updateTodos = List<TodosModel>.from(state.todos)
          ..add(event.todos!);
        emit(state.copyWith(todos: updateTodos));

        if (event.todos!.alarmDate != null) {
          // Parse String alarmDate
          final parsedDate = DateTime.tryParse(event.todos!.alarmDate!);
          if (parsedDate != null && parsedDate.isAfter(DateTime.now())) {
            final tzDate = tz.TZDateTime.from(parsedDate, tz.local);

            await NotifServices().scheduledNotification(
              id: event.todos!.dateCreated.hashCode,
              title: "Reminder: ${event.todos!.title}",
              body: "Don't forget to complete this task.",
              scheduledDate: tzDate,
            );
          }
        }
        db.child('todos/$id').update(event.todos!.toMap(id));
      }
    });

    on<CompleteTodoEvent>((event, emit) {
      final updateTodos = List<TodosModel>.from(state.todos);
      var todo = updateTodos[event.index!];
      updateTodos[event.index!] = TodosModel(
        title: todo.title,
        dateCreated: todo.dateCreated,
        completed: !(todo.completed ?? false),
      );
      emit(state.copyWith(todos: updateTodos));
      db
          .child('todos/${todo.id}')
          .update(updateTodos[event.index!].toMap(todo.id!));
      if (updateTodos[event.index!].completed == true) {
        NotifServices().cancelNotification(todo.dateCreated.hashCode);
      } else {
        if (todo.alarmDate != null) {
          final alarmDate = DateTime.tryParse(todo.alarmDate!);
          if (alarmDate != null) {
            final tzDate = tz.TZDateTime.from(alarmDate, tz.local);
            NotifServices().scheduledNotification(
              id: todo.dateCreated.hashCode,
              title: "Reminder: ${todo.title}",
              body: "Don't forget to complete this task.",
              scheduledDate: tzDate,
            );
          }
        }
      }
    });

    on<EditTodosEvent>((event, emit) async {
      final updateTodos = List<TodosModel>.from(state.todos);
      final oldTodo = updateTodos[event.index!];
      final newTodo = event.todos!;

      updateTodos[event.index!] = newTodo;
      emit(state.copyWith(todos: updateTodos));
      db
          .child('todos/${oldTodo.id}')
          .update(updateTodos[event.index!].toMap(oldTodo.id!));

      if (newTodo.alarmDate != null) {
        final alarmDate = DateTime.tryParse(newTodo.alarmDate!);
        if (alarmDate != null) {
          final tzDate = tz.TZDateTime.from(alarmDate, tz.local);
          NotifServices().scheduledNotification(
            id: newTodo.dateCreated.hashCode,
            title: "Reminder: ${newTodo.title}",
            body: "Don't forget to complete this task.",
            scheduledDate: tzDate,
          );
          NotifServices().cancelNotification(oldTodo.dateCreated.hashCode);
        }
      }
    });

    on<DeleteTodosEvent>((event, emit) {
      final updateTodos = List<TodosModel>.from(state.todos);
      NotifServices()
          .cancelNotification(updateTodos[event.index!].dateCreated.hashCode);
      db.child('todos/${updateTodos[event.index!].id}').remove();
      updateTodos.removeAt(event.index!);
      emit(state.copyWith(todos: updateTodos));
    });

    on<SortTodosEvent>((event, emit) {
      final updateTodos = List<TodosModel>.from(state.todos);

      if (event.sort == 1) {
        updateTodos.sort((a, b) => a.dateCreated!.compareTo(b.dateCreated!));
      } else if (event.sort == 2) {
        updateTodos.sort((a, b) => b.dateCreated!.compareTo(a.dateCreated!));
      } else if (event.sort == 3) {
        updateTodos.sort((a, b) => (b.completed == true ? 1 : 0)
            .compareTo(a.completed == true ? 1 : 0));
      } else if (event.sort == 4) {
        updateTodos.sort((a, b) => (a.completed == true ? 1 : 0)
            .compareTo(b.completed == true ? 1 : 0));
      }

      switch (event.sort) {
        case 1:
          emit(state.copyWith(sortType: 'Latest'));
          break;
        case 2:
          emit(state.copyWith(sortType: 'Newest'));
          break;
        case 3:
          emit(state.copyWith(sortType: 'Completed'));
          break;
        case 4:
          emit(state.copyWith(sortType: 'Uncompleted'));
          break;
      }

      emit(state.copyWith(todos: updateTodos));
    });
  }
}
