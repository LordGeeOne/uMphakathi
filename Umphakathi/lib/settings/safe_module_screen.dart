import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/safe_button_provider.dart';
import '../themes/providers/themes_provider.dart';
import 'module_setup_screen.dart';

class SafeModuleScreen extends StatefulWidget {
  const SafeModuleScreen({super.key});

  @override
  State<SafeModuleScreen> createState() => _SafeModuleScreenState();
}

class _SafeModuleScreenState extends State<SafeModuleScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SafeButtonProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Module Setup'),
          backgroundColor: const Color(0xFF6A1B9A),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: const ModuleSetupScreen(),
      ),
    );
  }
}
