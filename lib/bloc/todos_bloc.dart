import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_with_nodejs/Model/todos_model.dart';

part 'todos_event.dart';
part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  TodosBloc() : super(const TodosState()) {
    _init();
    on<CreateTodosEvent>((event, emit) {
      if (event.todos != null) {
        final updateTodos = List<TodosModel>.from(state.todos)
          ..add(event.todos!);
        emit(state.copyWith(todos: updateTodos));
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
    });

    on<EditTodosEvent>((event, emit) {
      final updateTodos = List<TodosModel>.from(state.todos);
      updateTodos[event.index!] = event.todos!;
      emit(state.copyWith(todos: updateTodos));
    });

    on<DeleteTodosEvent>((event, emit) {
      final updateTodos = List<TodosModel>.from(state.todos);
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

  void _init() {
    for (var i = 0; i < 9; i++) {
      final upTodos = List<TodosModel>.from(state.todos)
        ..add(TodosModel(
            title: 'title $i', dateCreated: DateTime.now().toString()));
      emit(state.copyWith(todos: upTodos));
    }
  }
}
