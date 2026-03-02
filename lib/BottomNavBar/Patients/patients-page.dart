import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nursify/BottomNavBar/Patients/add-patient.dart';
import 'package:nursify/BottomNavBar/Patients/patient-list-tile.dart';
import 'package:nursify/Firebase/firebaseDatabase.dart';
import 'package:nursify/cubit/theme_cubit.dart';

class PatientsPage extends StatefulWidget {
  const PatientsPage({super.key});

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Patients",
          style: TextStyle(fontFamily: "Orbitron", fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: isDark ? Colors.grey[800] : Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPatientPage()),
          );
        },
        child: const Icon(Icons.person_add, size: 35, color: Color(0xFF2D9CDB)),
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
          stream: FireBaseDatabaseService.instance.getPatients(user!.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  "Error loading patients",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No patients added yet",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            }

            final patientDocs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: patientDocs.length,
              itemBuilder: (context, index) {
                final data = patientDocs[index].data() as Map<String, dynamic>;

                return PatientTile(
                  patientId: patientDocs[index].id,
                  name: data['name'] ?? 'Unknown',
                  room: data['room']?.toString() ?? 'N/A',
                  status: data['status'] ?? 'In Treatment',
                );
              },
            );
          },
        ),
      ),
    );
  }
}
