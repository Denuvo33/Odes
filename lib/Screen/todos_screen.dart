import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_with_nodejs/Screen/edit_todos_scree.dart';
import 'package:todo_with_nodejs/Screen/full_todos_screen.dart';
import 'package:todo_with_nodejs/bloc/todos_bloc.dart';

class TodosScreen extends StatelessWidget {
  const TodosScreen({super.key});
  final List<Color> colors = const [
    Color.fromARGB(108, 248, 153, 11),
    Color.fromARGB(100, 208, 76, 231),
    Color.fromARGB(123, 244, 67, 54),
    Color.fromARGB(123, 76, 175, 79),
    Color.fromARGB(153, 33, 149, 243),
    Color.fromARGB(94, 105, 240, 175),
    Color.fromARGB(78, 255, 235, 59),
    Color.fromARGB(153, 68, 137, 255),
    Color.fromARGB(101, 255, 255, 0)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create');
        },
      ),
      appBar: AppBar(
        title: const Text('Todos'),
      ),
      body: BlocBuilder<TodosBloc, TodosState>(
        builder: (context, state) {
          return state.todos.isEmpty
              ? const Center(child: Text('You dont have any todos'))
              : Column(
                  children: [
                    Row(
                      children: [
                        PopupMenuButton(
                            icon: Icon(Icons.sort_rounded),
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  value: 1,
                                  onTap: () {
                                    context
                                        .read<TodosBloc>()
                                        .add(SortTodosEvent(sort: 1));
                                  },
                                  child: Text('Latest'),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  onTap: () {
                                    context
                                        .read<TodosBloc>()
                                        .add(SortTodosEvent(sort: 2));
                                  },
                                  child: Text('Newest'),
                                ),
                                PopupMenuItem(
                                  value: 3,
                                  onTap: () {
                                    context
                                        .read<TodosBloc>()
                                        .add(SortTodosEvent(sort: 3));
                                  },
                                  child: Text('Completed'),
                                ),
                                PopupMenuItem(
                                  value: 4,
                                  onTap: () {
                                    context
                                        .read<TodosBloc>()
                                        .add(SortTodosEvent(sort: 4));
                                  },
                                  child: Text('Uncompleted'),
                                ),
                              ];
                            }),
                        Text(state.sortType)
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.todos.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(state.todos[index].dateCreated.toString()),
                            onDismissed: (direction) {
                              context
                                  .read<TodosBloc>()
                                  .add(DeleteTodosEvent(index: index));
                            },
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FullTodosScreen(
                                              title:
                                                  '${state.todos[index].title}',
                                              id: index,
                                            )));
                              },
                              child: Card(
                                color: state.todos[index].completed ?? false
                                    ? Colors.grey
                                    : colors[index % colors.length],
                                child: ListTile(
                                    leading: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (builder) =>
                                                    EditTodosScreen(
                                                        index: index)));
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: Text(
                                      softWrap: true,
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                      state.todos[index].title!,
                                      style: TextStyle(
                                          color: Colors.black,
                                          decoration: TextDecoration.combine([
                                            state.todos[index].completed ??
                                                    false
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none
                                          ])),
                                    ),
                                    trailing: Checkbox(
                                        value: state.todos[index].completed ??
                                            false,
                                        onChanged: (newValue) {
                                          context.read<TodosBloc>().add(
                                              CompleteTodoEvent(index: index));
                                        })),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
