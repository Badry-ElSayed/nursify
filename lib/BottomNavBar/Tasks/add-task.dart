import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nursify/BottomNavBar/Tasks/task-model.dart';
import 'package:nursify/Firebase/firebaseAuth.dart';
import 'package:nursify/Firebase/firebaseDatabase.dart';
import 'package:nursify/cubit/tasks-cubit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController roomController = TextEditingController();
  final TextEditingController patientController = TextEditingController();

  String selectedPriority = "low";

  Color getPriorityColor() {
    switch (selectedPriority) {
      case "high":
        return Colors.red;
      case "medium":
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Task"),
        iconTheme: const IconThemeData(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Task Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: patientController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person, color: Colors.blue),
                    labelText: "Patient Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// Title
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.medical_services,
                      color: Colors.blue,
                    ),
                    labelText: "Task Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// Room
                TextField(
                  controller: roomController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.bed, color: Colors.blue),
                    labelText: "Room Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// Priority
                const Text(
                  "Priority",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    priorityButton("low", "Low", Colors.green),
                    priorityButton("medium", "Medium", Colors.orange),
                    priorityButton("high", "High", Colors.red),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      // Add Task Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2D9CDB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () {
              if (patientController.text.isEmpty ||
                  roomController.text.isEmpty ||
                  titleController.text.isEmpty) {
                AwesomeDialog(
                  context: context,
                  animType: AnimType.scale,
                  dialogType: DialogType.info,
                  title: 'Please fill all fields',
                  btnOkOnPress: () {},
                ).show();
                return;
              }
              final task = TaskModel(
                patient: patientController.text,
                title: titleController.text,
                room: roomController.text,
                priority: selectedPriority,
                isDone: false,
              );
              try {
                final String uid = FirebaseAuthService().currentUser!.uid;

                FireBaseDatabaseService().addTaskToFirestore(
                  uid: uid,
                  title: task.title,
                  patient: task.patient,
                  room: task.room,
                  priority: task.priority,
                  isCompleted: task.isDone,
                );

                context.read<TasksCubit>().addTask(task);

                Navigator.pop(context);
              } catch (e) {
                print("Error adding task: $e");
                AwesomeDialog(
                  context: context,
                  animType: AnimType.scale,
                  dialogType: DialogType.error,
                  title: 'Failed to add task',
                  desc: e.toString(),
                  btnOkOnPress: () {},
                ).show();
              }
            },
            child: const Text(
              "Add Task",
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget priorityButton(String value, String text, Color color) {
    final bool isSelected = selectedPriority == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedPriority = value;
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
