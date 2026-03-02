import 'package:flutter/material.dart';
import 'package:nursify/BottomNavBar/Patients/edit-patient.dart';
import 'package:nursify/BottomNavBar/Patients/patient-model.dart';

class PatientTile extends StatelessWidget {
  final String name;
  final String room;
  final String status;
  final String patientId;

  const PatientTile({
    super.key,
    required this.name,
    required this.room,
    required this.status,
    required this.patientId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF2D9CDB),
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : "?",
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Room: $room  •  Status: $status"),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditPatientPage(
                patient: PatientModel(
                  name: name,
                  room: room,
                  status: status,
                  patientId: patientId,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
