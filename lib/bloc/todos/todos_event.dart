part of 'todos_bloc.dart';

abstract class TodosEvent {}

class GetTodosEvent extends TodosEvent {
  BuildContext context;
  GetTodosEvent({required this.context});
}

class CreateTodosEvent extends TodosEvent {
  TodosModel? todos;
  CreateTodosEvent({this.todos});
}

class CompleteTodoEvent extends TodosEvent {
  int? index;
  CompleteTodoEvent({this.index});
}

class EditTodosEvent extends TodosEvent {
  int? index;
  TodosModel? todos;
  EditTodosEvent({this.index, this.todos});
}

class SortTodosEvent extends TodosEvent {
  int? sort;
  SortTodosEvent({this.sort});
}

class DeleteTodosEvent extends TodosEvent {
  int? index;
  DeleteTodosEvent({this.index});
}
