class TaskModel {
  final String? taskID;
  final String title;
  final String patient;
  final String room;
  final String priority;
  final bool isDone;

  TaskModel({
    this.taskID,
    required this.title,
    required this.patient,
    required this.room,
    required this.priority,
    required this.isDone,
  });
}
