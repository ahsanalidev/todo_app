import 'dart:async';
import 'package:meta/meta.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_todos/models/todo.dart';
import 'package:todos_repository_simple/todos_repository_simple.dart';

part 'todos_event.dart';
part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  TodosBloc({@required this.todoRepository}) : super(TodosLoadInProgress());
  final TodosRepositoryFlutter todoRepository;
  @override
  Stream<TodosState> mapEventToState(
    TodosEvent event,
  ) async* {
    if (event is TodosLoadSuccess) {
      _mapTodosLoadedToState();
    } else if (event is TodoAdded) {
      _mapTodoAddedToState(event);
    } else if (event is TodoDeleted) {
      _mapTodoDeletedToState(event);
    } else if (event is TodoUpdated) {
      _mapTodoUpdatedToState(event);
    } else if (event is TodoDeleted) {
      _mapTodoDeletedToState(event);
    } else if (event is ToggleAll) {
      _mapToggleAllToState();
    } else if (event is ClearCompleted) {
      _mapClearCompletedToState();
    }
  }

  Stream<TodosState> _mapTodosLoadedToState() async* {
    try {
      final todos = await todoRepository.loadTodos();
      yield TodosLoadInSuccess(todos.map(Todo.fromEntity).toList());
    } catch (_) {
      yield TodosLoadFailure();
    }
  }

  Stream<TodosState> _mapTodoAddedToState(TodoAdded event) async* {
    if (state is TodosLoadInSuccess) {
      final List<Todo> updatedTodos =
          List.from((state as TodosLoadInSuccess).todos)..add(event.todo);
      yield TodosLoadInSuccess(updatedTodos);
    }
  }

  Stream<TodosState> _mapTodoDeletedToState(TodoDeleted event) async* {
    if (state is TodosLoadSuccess) {
      final updatedTodos = (state as TodosLoadInSuccess)
          .todos
          .where((todo) => todo.id != event.todo.id)
          .toList();
      yield TodosLoadInSuccess(updatedTodos);
    }
  }

  Stream<TodosState> _mapTodoUpdatedToState(TodoUpdated event) async* {
    if (state is TodosLoadInSuccess) {
      final List<Todo> updatedTodos =
          (state as TodosLoadInSuccess).todos.map((todo) {
        return todo.id == event.todo.id ? event.todo : todo;
      }).toList();
      yield TodosLoadInSuccess(updatedTodos);
      _saveTodos(updatedTodos);
    }
  }

  Stream<TodosState> _mapToggleAllToState() async* {
    if (state is TodosLoadInSuccess) {
      final allComplete =
          (state as TodosLoadInSuccess).todos.every((todo) => todo.complete);
      final List<Todo> updatedTodos = (state as TodosLoadInSuccess)
          .todos
          .map((todo) => todo.copyWith(complete: !allComplete));
      yield TodosLoadInSuccess(updatedTodos);
      _saveTodos(updatedTodos);
    }
  }

  Stream<TodosState> _mapClearCompletedToState() async* {
    if (state is TodosLoadInSuccess) {
      final List<Todo> mytodos = (state as TodosLoadInSuccess).todos;
      mytodos.removeWhere((todo) => todo.complete == true);
    }
  }

  Future<void> _saveTodos(List<Todo> todos) {
    return todoRepository.saveTodos(
      todos.map((todo) => todo.toEntity()).toList(),
    );
  }
}
