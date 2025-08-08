import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/safety_provider.dart';

// Constants for styling consistency
class _AiNudgeConstants {
  static const Color primaryPurple = Color(0xFF6A1B9A);
  static const Color secondaryPurple = Color(0xFF8E24AA);
  static const Color primaryOrange = Color(0xFFEC7E33);
  static const Color textDark = Color(0xFF212121);
  
  static const double borderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  
  static BoxShadow get primaryShadow => BoxShadow(
    color: primaryOrange.withValues(alpha: 0.1),
    blurRadius: 8,
    offset: const Offset(0, 2),
  );
  
  static BoxShadow get secondaryShadow => BoxShadow(
    color: Colors.black.withValues(alpha: 0.05),
    blurRadius: 8,
    offset: const Offset(0, 2),
  );
}

class AiNudgeToggle extends StatelessWidget {
  const AiNudgeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SafetyProvider>(
      builder: (context, safetyProvider, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(_AiNudgeConstants.borderRadius),
            border: Border.all(
              color: _AiNudgeConstants.secondaryPurple.withValues(alpha: 0.2),
            ),
            boxShadow: [
              _AiNudgeConstants.primaryShadow,
              _AiNudgeConstants.secondaryShadow,
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _AiNudgeConstants.secondaryPurple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(_AiNudgeConstants.smallBorderRadius),
                    ),
                    child: Icon(
                      Icons.psychology_rounded,
                      color: _AiNudgeConstants.secondaryPurple,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Safety Check-ins',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _AiNudgeConstants.secondaryPurple,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Gentle nudges to document patterns',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Transform.scale(
                    scale: 1.2,
                    child: Switch(
                      value: safetyProvider.aiNudgeEnabled,
                      onChanged: (value) {
                        safetyProvider.toggleAiNudge(value);
                        if (value) {
                          _showAiNudgeInfo(context);
                        }
                      },
                      activeColor: _AiNudgeConstants.secondaryPurple,
                      activeTrackColor: _AiNudgeConstants.secondaryPurple.withValues(alpha: 0.3),
                      inactiveThumbColor: Colors.grey[400],
                      inactiveTrackColor: Colors.grey[300],
                    ),
                  ),
                ],
              ),
              
              if (safetyProvider.aiNudgeEnabled) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _AiNudgeConstants.secondaryPurple.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(_AiNudgeConstants.smallBorderRadius),
                    border: Border.all(
                      color: _AiNudgeConstants.secondaryPurple.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 18,
                            color: _AiNudgeConstants.secondaryPurple,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'AI will check on you:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _AiNudgeConstants.textDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildNudgeItem('Daily wellness check', Icons.favorite_rounded),
                      _buildNudgeItem('Pattern recognition alerts', Icons.trending_up_rounded),
                      _buildNudgeItem('Safety reminders', Icons.shield_rounded),
                      _buildNudgeItem('Evidence documentation prompts', Icons.note_add_rounded),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _showNudgeSettings(context),
                                borderRadius: BorderRadius.circular(_AiNudgeConstants.smallBorderRadius),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: _AiNudgeConstants.secondaryPurple.withValues(alpha: 0.3),
                                    ),
                                    borderRadius: BorderRadius.circular(_AiNudgeConstants.smallBorderRadius),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.settings_rounded,
                                        size: 18,
                                        color: _AiNudgeConstants.secondaryPurple,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Settings',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: _AiNudgeConstants.secondaryPurple,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _testNudge(context),
                                borderRadius: BorderRadius.circular(_AiNudgeConstants.smallBorderRadius),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: _AiNudgeConstants.secondaryPurple,
                                    borderRadius: BorderRadius.circular(_AiNudgeConstants.smallBorderRadius),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _AiNudgeConstants.secondaryPurple.withValues(alpha: 0.3),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.play_arrow_rounded,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Test',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildNudgeItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _AiNudgeConstants.secondaryPurple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              icon,
              size: 16,
              color: _AiNudgeConstants.secondaryPurple,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAiNudgeInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.psychology, color: Color(0xFF9C27B0)),
            SizedBox(width: 8),
            Text('AI Safety Check-ins'),
          ],
        ),
        content: const Text(
          'AI will send gentle, private notifications to help you:\n\n'
          '• Document patterns in difficult situations\n'
          '• Remember to record evidence\n'
          '• Check in on your wellbeing\n'
          '• Provide safety reminders\n\n'
          'All AI interactions are private and encrypted. You can turn this off anytime.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showNudgeSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI Nudge Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Check-in Frequency'),
              subtitle: const Text('Daily at 8 PM'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Implement frequency settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.volume_up),
              title: const Text('Notification Sound'),
              subtitle: const Text('Gentle chime'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Implement sound settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.mood),
              title: const Text('Wellness Prompts'),
              subtitle: const Text('Enabled'),
              trailing: Switch(
                value: true,
                onChanged: (value) {
                  // TODO: Implement wellness toggle
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _testNudge(BuildContext context) {
    // Show a sample AI nudge
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFC5CAE9),
        title: const Row(
          children: [
            Icon(Icons.psychology, color: Color(0xFF9C27B0)),
            SizedBox(width: 8),
            Text(
              'AI Check-in',
              style: TextStyle(color: Color(0xFF212121)),
            ),
          ],
        ),
        content: const Text(
          'Hi there! 🌸\n\n'
          'I noticed you haven\'t documented anything today. '
          'How are you feeling? Would you like to record a quick note about your day?\n\n'
          'Remember, I\'m here to help you stay safe and document important moments.',
          style: TextStyle(color: Color(0xFF212121)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('This is how AI nudges will appear'),
                  backgroundColor: Color(0xFF9C27B0),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9C27B0),
            ),
            child: const Text('Record now'),
          ),
        ],
      ),
    );
  }
}
