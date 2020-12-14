part of 'todos_bloc.dart';

abstract class TodosEvent extends Equatable {
  const TodosEvent();

  @override
  List<Object> get props => [];
}

class TodosLoadSuccess extends TodosEvent {}

class TodoAdded extends TodosEvent {
  final Todo todo;

  TodoAdded(this.todo);
  @override
  List<Object> get props => [todo];
}

class TodoUpdated extends TodosEvent {
  final Todo todo;

  TodoUpdated(this.todo);
  @override
  List<Object> get props => [todo];
}

class TodoDeleted extends TodosEvent {
  final Todo todo;

  TodoDeleted(this.todo);

  @override
  List<Object> get props => [todo];
}

class ClearCompleted extends TodosEvent {}

class ToggleAll extends TodosEvent {}
