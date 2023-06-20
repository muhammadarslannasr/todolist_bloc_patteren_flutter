import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_todo_list/bloc/todos_bloc.dart';
import 'package:flutter_bloc_todo_list/screens/add_to_do_screen.dart';
import 'package:flutter_bloc_todo_list/models/todos_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloc Pattern - Todos'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddToDoScreen(),
              ),
            ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _todos('Pending to Dos'),
    );
  }

  BlocBuilder<TodosBloc, TodosState> _todos(String title) {
    return BlocBuilder<TodosBloc, TodosState>(
      builder: (context, state) {
        if (state is TodosLoading) {
          return const CircularProgressIndicator();
        }

        if (state is TodosLoaded) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.todos.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _todoCard(
                      context,
                      state.todos[index],
                    );
                  },
                ),
              ],
            ),
          );
        } else {
          return const Text('Something went wrong!');
        }
      },
    );
  }

  Card _todoCard(BuildContext context, Todo todo) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '@${todo.id}: ${todo.task}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () => context.read<TodosBloc>().add(
                        UpdateTodo(
                          todo: todo.copyWith(
                            isCompleted: true,
                          ),
                        ),
                      ),
                  icon: const Icon(
                    Icons.add_task,
                  ),
                ),
                IconButton(
                  onPressed: () => context.read<TodosBloc>().add(
                        DeleteTodo(todo: todo),
                      ),
                  icon: const Icon(
                    Icons.cancel,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
