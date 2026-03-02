import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nursify/BottomNavBar/Dashboard/dashboard.dart';
import 'package:nursify/BottomNavBar/Patients/patients-page.dart';
import 'package:nursify/BottomNavBar/Profile/profile.dart';
import 'package:nursify/BottomNavBar/Settings/settings.dart';
import 'package:nursify/BottomNavBar/Tasks/tasks-page.dart';
import 'package:nursify/cubit/theme_cubit.dart';

class Bottomnavbar extends StatefulWidget {
  const Bottomnavbar({super.key});

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  int selectedIndex = 2;
  final PageController _pageController = PageController(initialPage: 2);

  final List<Widget> listNavigation = const [
    SettingsPage(),
    ProfilePage(),
    DashboardPage(),
    TasksPage(),
    PatientsPage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        children: listNavigation,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue,
        backgroundColor: Colors.grey[500],
        unselectedItemColor: isDark ? Colors.white : Colors.black,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: "Tasks"),
          BottomNavigationBarItem(icon: Icon(Icons.sick), label: "Patients"),
        ],
      ),
    );
  }
}
