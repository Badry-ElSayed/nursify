import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nursify/BottomNavBar/Dashboard/patient-statusRow.dart';
import 'package:nursify/BottomNavBar/Dashboard/dash-stat-card.dart';
import 'package:nursify/Firebase/firebaseAuth.dart';
import 'package:nursify/Firebase/firebaseDatabase.dart';
import 'package:nursify/cubit/theme_cubit.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
    return Scaffold(
      //AppBar with dynamic background color based on theme
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        title: const Text(
          "Nursify Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Orbitron"),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Section
            Text(
              "Good Evening, Dr. ${FirebaseAuthService().currentUser?.displayName ?? "Doctor"}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              "Here’s your hospital overview",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // Stats Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 14,
              childAspectRatio: 1.2,
              children: [
                DashStatCard(
                  title: "Total Patients",
                  value: StreamBuilder<QuerySnapshot>(
                    stream: FireBaseDatabaseService().getPatients(
                      FirebaseAuthService().currentUser!.uid,
                    ),
                    builder: (context, snapshot) {
                      int patientCounter = snapshot.data?.size ?? 0;
                      return Text(
                        patientCounter > 0 ? patientCounter.toString() : "0",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                  icon: Icons.people,
                ),
                DashStatCard(
                  title: "Pending Tasks",
                  value: StreamBuilder<QuerySnapshot>(
                    stream: FireBaseDatabaseService().getTasks(
                      FirebaseAuthService().currentUser!.uid,
                    ),
                    builder: (context, snapshot) {
                      int pendingTasksCount =
                          snapshot.data?.docs
                              .where((doc) => doc['isCompleted'] == false)
                              .length ??
                          0;

                      return Text(
                        pendingTasksCount.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                  icon: Icons.list,
                ),
                DashStatCard(
                  title: "Emergency",
                  value: StreamBuilder<QuerySnapshot>(
                    stream: FireBaseDatabaseService().getPatients(
                      FirebaseAuthService().currentUser!.uid,
                    ),
                    builder: (context, snapshot) {
                      int EmergencyCounter =
                          snapshot.data?.docs
                              .where((doc) => doc['status'] == "Critical")
                              .length ??
                          0;

                      return Text(
                        EmergencyCounter.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                  icon: Icons.warning,
                ),
                DashStatCard(
                  title: "Rooms",
                  value: Text(
                    "500",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  icon: Icons.bed,
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              "Patient Status",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            // Status Breakdown Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.watch<ThemeCubit>().state == ThemeMode.dark
                    ? Colors.grey[800]
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  StatusRow(
                    label: "Recovered",
                    value: StreamBuilder<QuerySnapshot>(
                      stream: FireBaseDatabaseService().getPatients(
                        FirebaseAuthService().currentUser!.uid,
                      ),
                      builder: (context, snapshot) {
                        int counter =
                            snapshot.data?.docs
                                .where((doc) => doc['status'] == "Recovered")
                                .length ??
                            0;

                        return Text(
                          counter.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                    color: Colors.green,
                  ),
                  SizedBox(height: 8),
                  StatusRow(
                    label: "In Treatment",
                    value: StreamBuilder<QuerySnapshot>(
                      stream: FireBaseDatabaseService().getPatients(
                        FirebaseAuthService().currentUser!.uid,
                      ),
                      builder: (context, snapshot) {
                        int counter =
                            snapshot.data?.docs
                                .where((doc) => doc['status'] == "In Treatment")
                                .length ??
                            0;

                        return Text(
                          counter.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                    color: Colors.orange,
                  ),
                  SizedBox(height: 8),
                  StatusRow(
                    label: "Critical",
                    value: StreamBuilder<QuerySnapshot>(
                      stream: FireBaseDatabaseService().getPatients(
                        FirebaseAuthService().currentUser!.uid,
                      ),
                      builder: (context, snapshot) {
                        int counter =
                            snapshot.data?.docs
                                .where((doc) => doc['status'] == "Critical")
                                .length ??
                            0;

                        return Text(
                          counter.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
