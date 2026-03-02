import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nursify/BottomNavBar/Tasks/task-model.dart';
import 'package:nursify/cubit/tasks-state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TasksState(tasks: []));

  void addTask(TaskModel task) {
    final updatedTasks = List<TaskModel>.from(state.tasks)..add(task);
    emit(TasksState(tasks: updatedTasks));
  }

  void updateTaskAt(int index, TaskModel newTask) {
    final updatedTasks = List<TaskModel>.from(state.tasks);
    updatedTasks[index] = newTask;
    emit(TasksState(tasks: updatedTasks));
  }

  void removeTask(TaskModel task) {
    final updatedTasks = List<TaskModel>.from(state.tasks)..remove(task);
    emit(TasksState(tasks: updatedTasks));
  }
}
