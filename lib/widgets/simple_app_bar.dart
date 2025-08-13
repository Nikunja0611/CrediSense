import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/theme_provider.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showThemeToggle;

  const SimpleAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showThemeToggle = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = _maybeThemeProvider(context);

    return AppBar(
      backgroundColor: theme.brightness == Brightness.dark
          ? AppColors.darkPrimary
          : AppColors.primary,
      elevation: 0,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 22,
          letterSpacing: 0.2,
        ),
      ),
      centerTitle: false,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        if (showThemeToggle && themeProvider != null)
          IconButton(
            tooltip: themeProvider.isDarkMode ? 'Light mode' : 'Dark mode',
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: themeProvider.toggleTheme,
          ),
        ...?actions,
        const SizedBox(width: 8),
      ],
    );
  }

  ThemeProvider? _maybeThemeProvider(BuildContext context) {
    try {
      return Provider.of<ThemeProvider>(context);
    } catch (_) {
      return null;
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
