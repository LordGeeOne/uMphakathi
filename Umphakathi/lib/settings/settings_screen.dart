import 'package:flutter/material.dart';
import 'safe_module_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

// Constants matching home page styling
class _SettingsConstants {
  static const Color primaryPurple = Color(0xFF6A1B9A);
  static const Color primaryOrange = Color(0xFFEC7E33);
  static const Color textDark = Color(0xFF212121);
  
  static const double sectionSpacing = 24.0;
  static const double cardSpacing = 12.0;
  static const double borderRadius = 8.0;
  static const double smallBorderRadius = 6.0;
  
  static const EdgeInsets standardPadding = EdgeInsets.all(16);
  static const EdgeInsets cardInternalPadding = EdgeInsets.all(20);
  
  static const TextStyle sectionTitleStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: textDark,
  );
  
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

class _SettingsScreenState extends State<SettingsScreen> {
  // Notification settings - assuming default values for now
  bool _pushEnabled = true;
  bool _meetRemindersEnabled = true;
  bool _newMeetAlertsEnabled = true;
  
  // Theme settings
  String _currentTheme = 'System Default';
  final List<String> _availableThemes = ['Light', 'Dark', 'System Default'];

  // Language settings
  final String _currentLanguage = 'English';
  String _selectedLanguage = 'English';
  final Map<String, String> _availableLanguages = {
    'English': 'English',
    'Afrikaans': 'Afrikaans',
    'Zulu': 'isiZulu',
    'Xhosa': 'isiXhosa',
    'Sotho': 'Sesotho',
    'Tswana': 'Setswana',
    'Pedi': 'Sepedi',
    'Venda': 'Tshivenda',
    'Tsonga': 'Xitsonga',
    'Ndebele': 'isiNdebele',
    'Swazi': 'siSwati',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: _SettingsConstants.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: _SettingsConstants.standardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 8),
              _buildSectionHeader('Appearance', Icons.palette_outlined),
              SizedBox(height: _SettingsConstants.cardSpacing),
              _buildSettingsCard([
                _buildSettingsTile(
                  icon: Icons.palette_outlined,
                  title: 'Theme',
                  subtitle: _currentTheme,
                  onTap: () => _showThemeSelectionDialog(context),
                ),
              ]),
              SizedBox(height: _SettingsConstants.sectionSpacing),
              
              _buildSectionHeader('Language', Icons.language_outlined),
              SizedBox(height: _SettingsConstants.cardSpacing),
              _buildSettingsCard([
                _buildSettingsTile(
                  icon: Icons.language_outlined,
                  title: 'App Language',
                  subtitle: _availableLanguages[_currentLanguage] ?? _currentLanguage,
                  onTap: () => _showLanguageSelectionDialog(context),
                ),
              ]),
              SizedBox(height: _SettingsConstants.sectionSpacing),
              
              _buildSectionHeader('Notifications', Icons.notifications_active_outlined),
              SizedBox(height: _SettingsConstants.cardSpacing),
              _buildSettingsCard([
                _buildSwitchTile(
                  icon: Icons.notifications_active_outlined,
                  title: 'Push Notifications',
                  value: _pushEnabled,
                  onChanged: (value) => setState(() => _pushEnabled = value),
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.event_available_outlined,
                  title: 'Safety Reminders',
                  value: _meetRemindersEnabled,
                  onChanged: (value) => setState(() => _meetRemindersEnabled = value),
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.new_releases_outlined,
                  title: 'Emergency Alerts',
                  value: _newMeetAlertsEnabled,
                  onChanged: (value) => setState(() => _newMeetAlertsEnabled = value),
                ),
              ]),
              SizedBox(height: _SettingsConstants.sectionSpacing),
              
              _buildSectionHeader('Safety', Icons.security),
              SizedBox(height: _SettingsConstants.cardSpacing),
              _buildSettingsCard([
                _buildSettingsTile(
                  icon: Icons.shield_outlined,
                  title: 'Safe Module',
                  subtitle: 'Configure emergency safety features',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SafeModuleScreen()),
                  ),
                ),
                _buildDivider(),
                _buildSettingsTile(
                  icon: Icons.security,
                  title: 'Privacy & Security',
                  subtitle: 'Manage your privacy settings',
                  onTap: () => _showComingSoon(context, 'Privacy & Security'),
                ),
              ]),
              SizedBox(height: _SettingsConstants.sectionSpacing),
              
              _buildSectionHeader('Account', Icons.person_outline),
              SizedBox(height: _SettingsConstants.cardSpacing),
              _buildSettingsCard([
                _buildSettingsTile(
                  icon: Icons.person_outline,
                  title: 'Profile',
                  subtitle: 'Manage your profile information',
                  onTap: () => _showComingSoon(context, 'Profile Management'),
                ),
                _buildDivider(),
                _buildSettingsTile(
                  icon: Icons.backup_outlined,
                  title: 'Backup & Sync',
                  subtitle: 'Manage your data backup',
                  onTap: () => _showComingSoon(context, 'Backup & Sync'),
                ),
              ]),
              SizedBox(height: _SettingsConstants.sectionSpacing),
              
              _buildSectionHeader('Help & Support', Icons.help_outline),
              SizedBox(height: _SettingsConstants.cardSpacing),
              _buildSettingsCard([
                _buildSettingsTile(
                  icon: Icons.help_outline,
                  title: 'Help Center',
                  onTap: () => _showHelpSupportDialog(context, 'Help Center', 'FAQs and support articles coming soon.'),
                ),
                _buildDivider(),
                _buildSettingsTile(
                  icon: Icons.feedback_outlined,
                  title: 'Send Feedback',
                  onTap: () => _showHelpSupportDialog(context, 'Send Feedback', 'Report an issue or suggest a feature.'),
                ),
                _buildDivider(),
                _buildSettingsTile(
                  icon: Icons.info_outline,
                  title: 'About',
                  onTap: () => _showHelpSupportDialog(context, 'About uMphakathi', 'Version 1.0.0\n© 2024 uMphakathi Safety App\n\nYour safety network in your pocket.'),
                ),
              ]),
              SizedBox(height: _SettingsConstants.sectionSpacing),
              
              Center(
                child: Text(
                  '© uMphakathi Safety App',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12.0,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper methods matching home page styling
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: _SettingsConstants.primaryOrange,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(title, style: _SettingsConstants.sectionTitleStyle),
        const SizedBox(width: 12),
        Icon(icon, color: _SettingsConstants.primaryOrange, size: 20),
      ],
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_SettingsConstants.borderRadius),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          _SettingsConstants.primaryShadow,
          _SettingsConstants.secondaryShadow,
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_SettingsConstants.borderRadius),
        child: Padding(
          padding: _SettingsConstants.cardInternalPadding,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _SettingsConstants.primaryPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(_SettingsConstants.smallBorderRadius),
                ),
                child: Icon(icon, color: _SettingsConstants.primaryPurple, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _SettingsConstants.textDark,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: _SettingsConstants.primaryPurple,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: _SettingsConstants.cardInternalPadding,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _SettingsConstants.primaryPurple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(_SettingsConstants.smallBorderRadius),
            ),
            child: Icon(icon, color: _SettingsConstants.primaryPurple, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _SettingsConstants.textDark,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: _SettingsConstants.primaryPurple,
            activeTrackColor: _SettingsConstants.primaryPurple.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[200],
      indent: 16,
      endIndent: 16,
    );
  }

  void _showThemeSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_SettingsConstants.borderRadius),
          ),
          title: Text(
            'Select Theme',
            style: TextStyle(
              color: _SettingsConstants.primaryPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _availableThemes.map((theme) {
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _currentTheme = theme;
                      });
                      Navigator.of(dialogContext).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Theme changed to $theme'),
                          backgroundColor: _SettingsConstants.primaryPurple,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(_SettingsConstants.smallBorderRadius),
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(_SettingsConstants.smallBorderRadius),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: Row(
                        children: [
                          Radio<String>(
                            value: theme,
                            groupValue: _currentTheme,
                            activeColor: _SettingsConstants.primaryPurple,
                            onChanged: (String? value) {
                              if (value != null) {
                                setState(() {
                                  _currentTheme = value;
                                });
                                Navigator.of(dialogContext).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Theme changed to $value'),
                                    backgroundColor: _SettingsConstants.primaryPurple,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(_SettingsConstants.smallBorderRadius),
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          Text(
                            theme,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: _SettingsConstants.primaryPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_SettingsConstants.smallBorderRadius),
                ),
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showLanguageSelectionDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_SettingsConstants.borderRadius),
          ),
          title: Text(
            'Select Language',
            style: TextStyle(
              color: _SettingsConstants.primaryPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: _availableLanguages.entries.map((entry) {
                return ListTile(
                  title: Text(entry.value),
                  leading: Radio<String>(
                    value: entry.key,
                    groupValue: _selectedLanguage,
                    onChanged: (String? value) {
                      if (value != null) {
                        Navigator.of(dialogContext).pop();
                        _showLanguageChangeConfirmation(context, entry.key, entry.value);
                      }
                    },
                    activeColor: _SettingsConstants.primaryPurple,
                  ),
                  onTap: () {
                    Navigator.of(dialogContext).pop();
                    _showLanguageChangeConfirmation(context, entry.key, entry.value);
                  },
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: _SettingsConstants.primaryPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_SettingsConstants.smallBorderRadius),
                ),
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showLanguageChangeConfirmation(BuildContext context, String languageCode, String languageName) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_SettingsConstants.borderRadius),
          ),
          title: Text(
            'Change Language',
            style: TextStyle(
              color: _SettingsConstants.primaryPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Change app language to $languageName?\n\nThe app will restart to apply the new language.',
            style: const TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_SettingsConstants.smallBorderRadius),
                ),
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _SettingsConstants.primaryPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_SettingsConstants.smallBorderRadius),
                ),
              ),
              child: const Text('Change'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                setState(() {
                  _selectedLanguage = languageCode;
                });
                // TODO: Implement actual language change logic here
                // This would typically involve updating shared preferences
                // and restarting the app with the new locale
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Language changed to $languageName'),
                    backgroundColor: _SettingsConstants.primaryPurple,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_SettingsConstants.smallBorderRadius),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon!'),
        backgroundColor: _SettingsConstants.primaryPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_SettingsConstants.smallBorderRadius),
        ),
      ),
    );
  }

  void _showHelpSupportDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_SettingsConstants.borderRadius),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: _SettingsConstants.primaryPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.4,
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: _SettingsConstants.primaryPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_SettingsConstants.smallBorderRadius),
                ),
              ),
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}