import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nursify/BottomNavBar/bottomNavBar.dart';
import 'package:nursify/Firebase/firebaseDatabase.dart';
import 'package:nursify/Login/sign-up.dart';
import 'package:nursify/Firebase/firebaseAuth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final auth = FirebaseAuthService.instance.currentUser;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/login-bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.black,
                    size: 36,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  'Login to Your Account',
                  style: TextStyle(
                    fontSize: 36,
                    fontFamily: 'Orbitron',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: 20),

                Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Email",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: emailController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Enter your E-mail",
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        "Password",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Password",
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () async {
                            String email = emailController.text.trim();

                            if (email.isEmpty) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                title: 'Missing Email',
                                desc: 'Please enter your email address first.',
                                btnOkOnPress: () {},
                              ).show();
                              return;
                            }

                            try {
                              await FirebaseAuthService.instance
                                  .forgetPasswordEmail(email);

                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                title: 'Email Sent',
                                desc:
                                    'If this email exists in our records, you will receive a reset link.',
                                btnOkOnPress: () {},
                                btnOkColor: Colors.green,
                              ).show();
                            } on FirebaseAuthException catch (e) {
                              String msg = "An error occurred";
                              if (e.code == 'user-not-found') {
                                msg =
                                    "This email is not registered in our system.";
                              }
                              if (e.code == 'invalid-email') {
                                msg = "The email address is badly formatted.";
                              }

                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                title: 'Error',
                                desc: msg,
                                btnOkOnPress: () {},
                              ).show();
                            } catch (e) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                title: 'Error',
                                desc:
                                    "Check your internet connection or try again.",
                                btnOkOnPress: () {},
                              ).show();
                            }
                          },
                          child: const Text(
                            "Forgot password?",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4285F4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () async {
                            String email = emailController.text.trim();
                            String password = passwordController.text.trim();

                            if (email.isEmpty || password.isEmpty) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                animType: AnimType.scale,
                                title: 'Missing Data',
                                desc:
                                    'Please enter both email and password to continue.',
                                btnOkOnPress: () {},
                                btnOkText: 'OK',
                                btnOkColor: CupertinoColors.systemYellow,
                              ).show();
                              return;
                            }

                            try {
                              await FirebaseAuthService.instance
                                  .signInWithEmailAndPassword(email, password);
                              await FireBaseDatabaseService.instance
                                  .addUserData(
                                    auth!.uid,
                                    auth.displayName ?? "No Name",
                                    auth.email ?? "",
                                  );

                              if (context.mounted) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Bottomnavbar(),
                                  ),
                                  (route) => false,
                                );
                              }
                            } on FirebaseAuthException catch (e) {
                              String errorMessage =
                                  'An error occurred while trying to log in';

                              if (e.code == 'user-not-found' ||
                                  e.code == 'invalid-credential') {
                                errorMessage =
                                    'This account does not exist or the password is incorrect';
                              } else if (e.code == 'wrong-password') {
                                errorMessage =
                                    'The password you entered is incorrect.';
                              } else if (e.code == 'invalid-email') {
                                errorMessage =
                                    'The email format is invalid. Please check and try again.';
                              }

                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                title: 'Login Error',
                                desc: errorMessage,
                                btnOkOnPress: () {},
                                btnOkText: 'Try Again',
                              ).show();
                            } catch (e) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.info,
                                title: 'Alert',
                                desc: e.toString(),
                                btnOkOnPress: () {},
                              ).show();
                            }
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontFamily: 'Orbitron',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(color: Colors.grey.shade400),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "OR",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(color: Colors.grey.shade400),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFEA4335),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () async {
                            try {
                              final user = await FirebaseAuthService.instance
                                  .signInWithGoogle();

                              if (user != null) {
                                await FireBaseDatabaseService.instance
                                    .addUserData(
                                      user.uid,
                                      user.displayName ?? "No Name",
                                      user.email ?? "",
                                    );

                                if (context.mounted) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const Bottomnavbar(),
                                    ),
                                    (route) => false,
                                  );
                                }
                              }
                            } catch (e) {
                              print("Error: $e");
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Image.asset(
                                  'images/google-logo.png',
                                  fit: BoxFit.contain,
                                ),
                              ),

                              const SizedBox(width: 12),

                              const Text(
                                "Login with Google",
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontFamily: 'Orbitron',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Color(0xFF4285F4),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
