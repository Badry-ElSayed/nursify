import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nursify/cubit/theme_cubit.dart';

class DarkModeTile extends StatelessWidget {
  const DarkModeTile({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        tileColor: Colors.transparent,
        activeThumbColor:  Colors.blue,
        // activeTrackColor: const Color(0xFF009445).withOpacity(0.4),
        inactiveThumbColor: Colors.grey.shade400,
        inactiveTrackColor: Colors.grey.shade200,

        secondary: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, anim) =>
              RotationTransition(turns: anim, child: child),
          child: isDark
              ? const Icon(
                  Icons.nightlight_round,
                  color: Colors.amber,
                  key: ValueKey('dark'),
                )
              : const Icon(
                  Icons.wb_sunny_rounded,
                  color: Colors.orange,
                  key: ValueKey('light'),
                ),
        ),

        title: Text(
          "Dark Mode",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),

        subtitle: Text(
          isDark ? "Activated" : "Not Activated",
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),

        value: isDark,
        onChanged: (value) {
          context.read<ThemeCubit>().changeTheme(value);
        },
      ),
    );
  }
}
