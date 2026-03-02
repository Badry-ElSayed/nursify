import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:nursify/BottomNavBar/Tasks/task-model.dart';
import 'package:nursify/Firebase/firebaseDatabase.dart';

class EditTaskPage extends StatefulWidget {
  const EditTaskPage({super.key, required this.task, required this.taskIndex});

  final TaskModel task;
  final int taskIndex;

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late TextEditingController titleController;
  late TextEditingController roomController;
  late TextEditingController patientController;
  String selectedPriority = "low";

  @override
  void initState() {
    super.initState();
    patientController = TextEditingController(text: widget.task.patient);
    titleController = TextEditingController(text: widget.task.title);
    roomController = TextEditingController(text: widget.task.room);
    selectedPriority = widget.task.priority;
  }

  @override
  void dispose() {
    titleController.dispose();
    roomController.dispose();
    patientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Task"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_rounded, color: Colors.red, size: 30),
            onPressed: () {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.warning,
                animType: AnimType.scale,
                title: 'Confirm Delete',
                desc: 'Are you sure you want to delete this task?',
                btnCancelOnPress: () {},
                btnOkOnPress: () async {
                  await FireBaseDatabaseService().deleteTask(
                    widget.task.taskID!,
                  );
                  if (mounted) Navigator.pop(context);
                },
              ).show();
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Task Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Patient Name Field
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

              // Task Title Field
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

              // Room Number Field
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
              const SizedBox(height: 20),

              const Text(
                "Priority",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),

              // Priority Selection Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  priorityButton("low", "Low", Colors.green),
                  priorityButton("medium", "Medium", Colors.orange),
                  priorityButton("high", "High", Colors.red),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      // Save Changes Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2D9CDB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () {
              if (titleController.text.isEmpty ||
                  roomController.text.isEmpty ||
                  patientController.text.isEmpty) {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  title: 'Empty Fields',
                  desc: 'Please fill all fields before saving.',
                  btnOkOnPress: () {},
                ).show();
                return;
              }

              FireBaseDatabaseService().updateTask(
                TaskModel(
                  taskID: widget.task.taskID,
                  title: titleController.text.trim(),
                  patient: patientController.text.trim(),
                  room: roomController.text.trim(),
                  priority: selectedPriority,
                  isDone: widget.task.isDone,
                ),
              );

              if (mounted) Navigator.pop(context);
            },
            child: const Text(
              "Save Changes",
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
            border: isSelected
                ? Border.all(color: Colors.black26, width: 1)
                : null,
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
