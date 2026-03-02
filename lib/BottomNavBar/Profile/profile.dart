import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nursify/BottomNavBar/Profile/profile-statcard.dart';
import 'package:nursify/Firebase/firebaseAuth.dart';
import 'package:nursify/Firebase/firebaseDatabase.dart';
import 'package:nursify/cubit/theme_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
    final username = FirebaseAuth.instance.currentUser?.displayName ?? "Doctor";
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              isDark ? "images/profile-bg-dark.jpg" : "images/profile-bg.png",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Center(
            child: Align(
              alignment: Alignment(0, 0.8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Display the username
                  Text(
                    "Dr. $username",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Orbitron",
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Grid of profile statistics
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.3,
                      children: [
                        // Each ProfStatCard will listen to the tasks stream and calculate the respective statistics
                        ProfStatCard(
                          title: "Completed",
                          value: StreamBuilder<QuerySnapshot>(
                            stream: FireBaseDatabaseService().getTasks(
                              FirebaseAuthService().currentUser!.uid,
                            ),
                            builder: (context, snapshot) {
                              int completedTasks =
                                  snapshot.data?.docs
                                      .where(
                                        (doc) => doc['isCompleted'] == true,
                                      )
                                      .length ??
                                  0;
                              return Text(
                                completedTasks.toString(),
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                        ProfStatCard(
                          title: "Remaining",
                          value: StreamBuilder<QuerySnapshot>(
                            stream: FireBaseDatabaseService().getTasks(
                              FirebaseAuthService().currentUser!.uid,
                            ),
                            builder: (context, snapshot) {
                              int remainingTasks =
                                  snapshot.data?.docs
                                      .where(
                                        (doc) => doc['isCompleted'] == false,
                                      )
                                      .length ??
                                  0;
                              return Text(
                                remainingTasks.toString(),
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                        ProfStatCard(
                          title: "Total Tasks",
                          value: StreamBuilder<QuerySnapshot>(
                            stream: FireBaseDatabaseService().getTasks(
                              FirebaseAuthService().currentUser!.uid,
                            ),
                            builder: (context, snapshot) {
                              int totalTasks = snapshot.data?.docs.length ?? 0;
                              return Text(
                                totalTasks.toString(),
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                        ProfStatCard(
                          title: "Completion %",
                          value: StreamBuilder<QuerySnapshot>(
                            stream: FireBaseDatabaseService().getTasks(
                              FirebaseAuthService().currentUser!.uid,
                            ),
                            builder: (context, snapshot) {
                              int completedTasks =
                                  snapshot.data?.docs
                                      .where(
                                        (doc) => doc['isCompleted'] == true,
                                      )
                                      .length ??
                                  0;
                              int totaltasks = snapshot.data?.docs.length ?? 0;
                              double completionRate = totaltasks > 0
                                  ? (completedTasks / totaltasks) * 100
                                  : 0.0;

                              return Text(
                                "${completionRate.toStringAsFixed(0)}%",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
