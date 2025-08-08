import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/safe_button_provider.dart';
import '../../themes/providers/themes_provider.dart';
import '../../widgets/safe_module_widgets/timed_animation.dart';
import 'widgets/button_manager_widget.dart';

class ModuleSetupScreen extends StatefulWidget {
  const ModuleSetupScreen({super.key});

  @override
  State<ModuleSetupScreen> createState() => _ModuleSetupScreenState();
}

class _ModuleSetupScreenState extends State<ModuleSetupScreen> {
  // Helper method to get shadow color from theme
  Color _getShadowColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final customTheme = themeProvider.currentCustomTheme;
    
    // Get primary color from theme or use fallback
    Color primaryColor;
    
    if (customTheme?.colorCategories?['Primary Colors']?['Primary Color'] != null) {
      primaryColor = customTheme!.colorCategories!['Primary Colors']!['Primary Color']!;
    } else {
      primaryColor = Theme.of(context).primaryColor;
    }
    
    return primaryColor.withOpacity(0.3);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SafeButtonProvider>(
      builder: (context, provider, child) {
        final buttonCount = provider.safeButtons.length;
        final canAddMore = buttonCount < 3;  // Limit to 3 buttons
        
        return Column(
          children: [
            // Button manager widget at the top
            Container(
              padding: const EdgeInsets.all(16),
              child: Card(
                color: Colors.grey[50],
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: ButtonManagerWidget(),
                ),
              ),
            ),
            // Main content area - scrollable
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 200,
                  child: Stack(
                    children: [
                      // Background animation
                      Positioned.fill(
                        child: TimedAnimation(
                          isActive: provider.isRecordingButton,
                          onTimerComplete: () {
                            if (provider.isRecordingButton) {
                              provider.stopRecording();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Recording timed out'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      
                      // Main content
                      if (canAddMore) ...[
                        // Title and instructions
                        Positioned(
                          top: 50,
                          left: 20,
                          right: 20,
                          child: Column(
                            children: [
                              Text(
                                provider.isRecordingButton
                                    ? 'Press the button you want to assign...'
                                    : 'Add a new safe button',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                provider.isRecordingButton
                                    ? 'The app is listening for button presses'
                                    : 'Tap the + button below to start setup',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        
                        // Plus button
                        Positioned(
                          top: 200,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: () => _startButtonSetup(provider),
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      _getShadowColor(context),
                                      _getShadowColor(context).withOpacity(0.7)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: _getShadowColor(context).withOpacity(0.3),
                                      blurRadius: 15,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  provider.isRecordingButton
                                      ? Icons.motion_photos_on
                                      : Icons.add,
                                  size: 48,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        // Quick setup options
                        if (provider.isRecordingButton)
                          Positioned(
                            bottom: 50,
                            left: 16,
                            right: 16,
                            child: Card(
                              color: Colors.blue.shade50,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.speed,
                                          size: 20,
                                          color: Colors.blue.shade700,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Quick Setup',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Can\'t press the physical button? Use these options:',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.blue.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: () => _forceCompleteRecording(provider, "volume_up", "volume"),
                                            icon: const Icon(Icons.volume_up, size: 18),
                                            label: const Text("Volume Up"),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue.shade600,
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.symmetric(vertical: 12),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: () => _forceCompleteRecording(provider, "volume_down", "volume"),
                                            icon: const Icon(Icons.volume_down, size: 18),
                                            label: const Text("Volume Down"),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue.shade600,
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.symmetric(vertical: 12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                      
                      // All buttons configured message
                      if (!canAddMore)
                        Positioned(
                          top: 100,
                          left: 16,
                          right: 16,
                          child: Card(
                            color: Colors.green.shade50,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green.shade700,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'All buttons configured!',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green.shade700,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'You can manage your buttons using the icons above.',
                                          style: TextStyle(
                                            color: Colors.green.shade600,
                                            fontSize: 13,
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _startButtonSetup(SafeButtonProvider provider) async {
    try {
      await provider.startRecording('Detecting...');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to start recording: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _forceCompleteRecording(SafeButtonProvider provider, String action, String type) {
    if (!provider.isRecordingButton || provider.recordingName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not currently recording a button'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    try {
      provider.simulateButtonPress(action, type);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Simulated $action button press'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to simulate button press: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}