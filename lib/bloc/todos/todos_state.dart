part of 'todos_bloc.dart';

class TodosState extends Equatable {
  final List<TodosModel> todos;
  final bool isLoading;
  final int sort;
  final String sortType;

  const TodosState(
      {this.todos = const [],
      this.isLoading = false,
      this.sort = 1,
      this.sortType = 'Latest'});

  TodosState copyWith(
      {List<TodosModel>? todos, bool? isLoading, int? sort, String? sortType}) {
    return TodosState(
        todos: todos ?? this.todos,
        isLoading: isLoading ?? this.isLoading,
        sort: sort ?? this.sort,
        sortType: sortType ?? this.sortType);
  }

  @override
  List<Object?> get props => [todos, isLoading, sort, sortType];
}
