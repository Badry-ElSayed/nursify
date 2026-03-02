import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:nursify/BottomNavBar/Patients/patient-model.dart';
import 'package:nursify/Firebase/firebaseAuth.dart';
import 'package:nursify/Firebase/firebaseDatabase.dart';

class EditPatientPage extends StatefulWidget {
  const EditPatientPage({super.key, required this.patient});
  final PatientModel patient;

  @override
  State<EditPatientPage> createState() => _EditPatientState();
}

class _EditPatientState extends State<EditPatientPage> {
  late TextEditingController nameController;
  late TextEditingController roomController;
  String status = "In Treatment";

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.patient.name);
    roomController = TextEditingController(
      text: widget.patient.room.toString(),
    );
    status = widget.patient.status;
  }

  @override
  void dispose() {
    nameController.dispose();
    roomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Patient Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_rounded, color: Colors.red, size: 30),
            onPressed: () {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.warning,
                animType: AnimType.scale,
                title: 'Warning!',
                desc: 'Are you sure you want to delete this patient?',
                btnCancelOnPress: () {},
                btnOkOnPress: () {
                  FireBaseDatabaseService().deletePatient(
                    FirebaseAuthService().currentUser!.uid,
                    widget.patient.patientId,
                  );
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
                "Patient Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              /// Name Field
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  labelText: "Patient Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              /// Room Field
              TextField(
                controller: roomController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.bed),
                  labelText: "Room Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              /// Status Section
              const Text(
                "Status",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  statusButton("Recovered", Colors.green),
                  statusButton("In Treatment", Colors.orange),
                  statusButton("Critical", Colors.red),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      // Save Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: () {
              String name = nameController.text.trim();
              String room = roomController.text.trim();

              if (name.isEmpty || room.isEmpty) {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.infoReverse,
                  animType: AnimType.bottomSlide,
                  title: 'Warning!',
                  desc: 'please fill in all fields',
                  btnOkColor: Colors.blueAccent,
                  btnOkOnPress: () {},
                ).show();
                return;
              }

              try {
                FireBaseDatabaseService().updatePatient(
                  uid: FirebaseAuthService().currentUser!.uid,
                  patientId: widget.patient.patientId,
                  newName: name,
                  newRoom: room,
                  newStatus: status,
                );

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Patient updated successfully!"),
                    ),
                  );
                }
              } catch (e) {
                debugPrint("Update error: $e");
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              "Save Changes",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget statusButton(String value, Color color) {
    final bool isSelected = status == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => status = value),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
