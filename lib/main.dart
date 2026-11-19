import 'package:material_ui/material_ui.dart';
import 'package:reorderable_list_demo/screens/home_shell.dart';

void main() {
  runApp(const ReorderableListApp());
}

class ReorderableListApp extends StatelessWidget {
  const ReorderableListApp({super.key});

  static const Color _orange = Color(0xFFFF6D00);
  static const Color _black = Color(0xFF000000);
  static const Color _charcoal = Color(0xFF1A1A1A);
  static const Color _graphite = Color(0xFF2B2B2B);

  static ThemeData _blackAndOrangeTheme() {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: _orange,
      brightness: Brightness.dark,
    ).copyWith(
      primary: _orange,
      onPrimary: _black,
      secondary: _orange,
      onSecondary: _black,
      surface: _black,
      onSurface: Colors.white,
      surfaceContainerLowest: _black,
      surfaceContainerLow: _charcoal,
      surfaceContainer: _charcoal,
      surfaceContainerHigh: _graphite,
      surfaceContainerHighest: _graphite,
      onSurfaceVariant: const Color(0xFFBDBDBD),
      secondaryContainer: _graphite,
      onSecondaryContainer: _orange,
      tertiaryContainer: _orange,
      onTertiaryContainer: _black,
      outline: _orange,
    );
    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: _black,
      appBarTheme: const AppBarTheme(
        backgroundColor: _black,
        foregroundColor: _orange,
        surfaceTintColor: Colors.transparent,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _black,
        indicatorColor: _orange.withValues(alpha: 0.25),
      ),
      useMaterial3: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReorderableListView',
      debugShowCheckedModeBanner: false,
      theme: _blackAndOrangeTheme(),
      darkTheme: _blackAndOrangeTheme(),
      themeMode: ThemeMode.dark,
      home: const HomeShell(),
    );
  }
}
