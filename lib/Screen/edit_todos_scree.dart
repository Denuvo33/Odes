import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_with_nodejs/Model/todos_model.dart';
import 'package:todo_with_nodejs/bloc/todos_bloc.dart';

// ignore: must_be_immutable
class EditTodosScreen extends StatefulWidget {
  int index;
  EditTodosScreen({super.key, required this.index});

  @override
  State<EditTodosScreen> createState() => _EditTodosScreenState();
}

class _EditTodosScreenState extends State<EditTodosScreen> {
  DateTime? selectedDateTime;
  final TextEditingController titleController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(8),
          child: Form(
            key: formKey,
            child: Column(
              spacing: 20,
              children: [
                TextFormField(
                  controller: titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: 'Title', border: OutlineInputBorder()),
                ),
                Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: CupertinoButton(
                          child: Text('Remind Me? ${selectedDateTime ?? ''}'),
                          onPressed: () => _selectDateTime(context)),
                    ),
                    if (selectedDateTime != null)
                      IconButton(
                          onPressed: () {
                            selectedDateTime = null;
                            setState(() {});
                          },
                          icon: Icon(Icons.close))
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      context.read<TodosBloc>().add(
                            EditTodosEvent(
                              index: widget.index,
                              todos: TodosModel(
                                title: titleController.text,
                                dateCreated: DateTime.now().toString(),
                                completed: false,
                                alarmDate: selectedDateTime.toString(),
                              ),
                            ),
                          );
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Update Todos'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        final combined = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        setState(() {
          selectedDateTime = combined;
        });
        debugPrint('Alarm set for $combined');
      }
    }
  }
}
