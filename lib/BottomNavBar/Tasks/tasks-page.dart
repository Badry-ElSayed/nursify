import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nursify/BottomNavBar/Tasks/add-task.dart';
import 'package:nursify/BottomNavBar/Tasks/task-list-tile.dart';
import 'package:nursify/BottomNavBar/Tasks/task-model.dart';
import 'package:nursify/Firebase/firebaseDatabase.dart';
import 'package:nursify/cubit/theme_cubit.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Tasks",
          style: TextStyle(fontFamily: "Orbitron", fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: isDark ? Colors.grey[800] : Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskPage()),
          );
        },
        child: const Icon(Icons.add, size: 45, color: Color(0xFF2D9CDB)),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF2D9CDB),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FireBaseDatabaseService().getTasks(
            FirebaseAuth.instance.currentUser!.uid,
          ),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (!asyncSnapshot.hasData || asyncSnapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No tasks yet",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            }

            final tasksDocs = asyncSnapshot.data!.docs;

            return ListView.builder(
              itemCount: tasksDocs.length,
              itemBuilder: (context, index) {
                final data = tasksDocs[index].data() as Map<String, dynamic>;

                final task = TaskModel(
                  taskID: tasksDocs[index].id,
                  title: data['title'] ?? '',
                  patient: data['patient'] ?? '',
                  room: data['room']?.toString() ?? '',
                  priority: data['priority'] ?? 'low',
                  isDone: data['isCompleted'] ?? false,
                );

                return TaskTile(
                  title: task.title,
                  patient: task.patient,
                  room: task.room,
                  priority: task.priority,
                  isDone: task.isDone,
                  taskIndex: index,
                  task: task,
                  onChanged: (value) async {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('tasks')
                        .doc(tasksDocs[index].id)
                        .update({'isCompleted': value});
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
