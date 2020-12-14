part of 'todos_bloc.dart';

abstract class TodosState extends Equatable {
  const TodosState();

  @override
  List<Object> get props => [];
}

class TodosLoadInProgress extends TodosState {}

class TodosLoadInSuccess extends TodosState {
  const TodosLoadInSuccess([this.todos = const []]);

  final List<Todo> todos;

  List<Object> get props => [todos];

  @override
  String toString() {
    return 'Todos Loaded Successfully ${todos}';
  }
}

class TodosLoadFailure extends TodosState {}
