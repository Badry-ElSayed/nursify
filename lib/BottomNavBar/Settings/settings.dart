import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nursify/BottomNavBar/Settings/darkmode.dart';
import 'package:nursify/Firebase/firebaseAuth.dart';
import 'package:nursify/Firebase/firebaseDatabase.dart';
import 'package:nursify/Login/get-start.dart';
import 'package:nursify/cubit/theme_cubit.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with dynamic background and text color based on theme
      appBar: AppBar(
        backgroundColor: context.watch<ThemeCubit>().state == ThemeMode.dark
            ? Colors.black
            : Colors.white,
        title: Text(
          "Settings",
          style: TextStyle(fontFamily: "Orbitron", fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    SectionTitle(title: "Account"),
                    // Edit Name Tile
                    AccountSettingsTile(
                      icon: Icons.person,
                      title: "Edit Name",
                      onTap: () {
                        nameController.text =
                            FirebaseAuth.instance.currentUser?.displayName ??
                            "";

                        AwesomeDialog(
                          context: context,
                          animType: AnimType.scale,
                          dialogType: DialogType.noHeader,
                          title: 'Update Name',
                          body: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const Text(
                                  "Enter your new name",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: nameController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Full Name",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          btnOkText: "Update",
                          btnCancelOnPress: () {},
                          btnOkOnPress: () async {
                            String newName = nameController.text.trim();
                            if (newName.isNotEmpty) {
                              try {
                                User? user = FirebaseAuth.instance.currentUser;

                                if (user != null) {
                                  await user.updateDisplayName(newName);

                                  await FireBaseDatabaseService.instance
                                      .updateUserName(user.uid, newName);

                                  await user.reload();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(
                                        "Name updated successfully!",
                                      ),
                                    ),
                                  );
                                } else {
                                  throw "No user logged in";
                                }
                              } catch (e) {
                                throw "Failed to update name: $e";
                              }
                            }
                          },
                        ).show();
                      },
                    ),
                    const SizedBox(height: 5),

                    // Change Password Tile
                    AccountSettingsTile(
                      icon: Icons.lock,
                      title: "Change Password",
                      onTap: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.infoReverse,
                          title: 'Alert',
                          desc: 'Are you sure about changing your Password?',
                          btnCancelOnPress: () {},
                          btnOkText: 'Yes',
                          btnOkOnPress: () async {
                            final userEmail =
                                FirebaseAuthService.instance.currentUser?.email;

                            if (userEmail != null) {
                              try {
                                await FirebaseAuthService.instance
                                    .forgetPasswordEmail(userEmail);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Reset link sent! Check your inbox.",
                                    ),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Error: ${e.toString()}"),
                                  ),
                                );
                              }
                            } else {
                              print("No user email found");
                            }
                          },
                        ).show();
                      },
                    ),

                    const SizedBox(height: 20),

                    // App Preferences Section
                    const SectionTitle(title: "App Preferences"),
                    // Dark Mode Toggle
                    DarkModeTile(),
                  ],
                ),
              ),

              // Logout Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      AwesomeDialog(
                        width: 400,
                        context: context,
                        dialogType: DialogType.infoReverse,
                        animType: AnimType.scale,
                        title: 'Logout',
                        desc: 'Are you sure you want to logout?',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {
                          FirebaseAuthService.instance.signOutFromFireBase();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GetStart(),
                            ),
                            (route) => false,
                          );
                        },
                      ).show();
                    },
                    child: const Text(
                      "Logout",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Reusable Widgets for Settings Page
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class AccountSettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const AccountSettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF2D9CDB)),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
