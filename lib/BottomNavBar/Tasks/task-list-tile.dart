import 'package:flutter/material.dart';
import 'package:nursify/BottomNavBar/Tasks/edit-task.dart';
import 'package:nursify/BottomNavBar/Tasks/task-model.dart';

class TaskTile extends StatelessWidget {
  final String title;
  final String patient;
  final String room;
  final String priority;
  final bool isDone;
  final ValueChanged<bool?> onChanged;
  final TaskModel task;
  final int taskIndex;

  const TaskTile({
    super.key,
    required this.title,
    required this.patient,
    required this.room,
    required this.priority,
    required this.isDone,
    required this.onChanged,
    required this.task,
    required this.taskIndex,
  });

  Color getPriorityColor() {
    switch (priority) {
      case "high":
        return Colors.red;
      case "medium":
        return Colors.orange;
      case "low":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EditTaskPage(task: task, taskIndex: taskIndex),
            ),
          );
        },
        leading: Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: getPriorityColor(),
            shape: BoxShape.circle,
          ),
        ),

        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: isDone
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Text(
          "$patient  •  Room $room  •  Priority: $priority",
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Checkbox(
          value: isDone,
          onChanged: onChanged,
          activeColor: Color(0xFF2D9CDB),
        ),
      ),
    );
  }
}
