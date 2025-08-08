import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/safety_provider.dart';

// Constants for styling consistency
class _VaultSetupConstants {
  static const Color primaryPurple = Color(0xFF6A1B9A);
  static const Color secondaryPurple = Color(0xFF8E24AA);
  static const Color primaryOrange = Color(0xFFEC7E33);
  static const Color emergencyRed = Color(0xFFF44336);
  static const Color successGreen = Color(0xFF4CAF50);
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

class VaultSetup extends StatelessWidget {
  const VaultSetup({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SafetyProvider>(
      builder: (context, safetyProvider, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(_VaultSetupConstants.borderRadius),
            border: Border.all(
              color: safetyProvider.emergencyProtocolSet 
                  ? _VaultSetupConstants.successGreen.withValues(alpha: 0.3)
                  : _VaultSetupConstants.emergencyRed.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: [
              _VaultSetupConstants.primaryShadow,
              _VaultSetupConstants.secondaryShadow,
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
                      gradient: LinearGradient(
                        colors: safetyProvider.emergencyProtocolSet 
                            ? [_VaultSetupConstants.successGreen, _VaultSetupConstants.successGreen.withValues(alpha: 0.8)]
                            : [_VaultSetupConstants.emergencyRed, _VaultSetupConstants.primaryOrange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(_VaultSetupConstants.smallBorderRadius),
                    ),
                    child: Icon(
                      safetyProvider.emergencyProtocolSet 
                          ? Icons.shield_rounded
                          : Icons.security_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Emergency Protocol',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: safetyProvider.emergencyProtocolSet 
                                ? _VaultSetupConstants.successGreen
                                : _VaultSetupConstants.emergencyRed,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Dead man\'s switch & data release',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: safetyProvider.emergencyProtocolSet 
                          ? _VaultSetupConstants.successGreen.withValues(alpha: 0.1)
                          : _VaultSetupConstants.emergencyRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(_VaultSetupConstants.smallBorderRadius),
                    ),
                    child: Icon(
                      safetyProvider.emergencyProtocolSet 
                          ? Icons.check_circle_rounded 
                          : Icons.warning_rounded,
                      color: safetyProvider.emergencyProtocolSet 
                          ? _VaultSetupConstants.successGreen 
                          : _VaultSetupConstants.emergencyRed,
                      size: 24,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              if (!safetyProvider.emergencyProtocolSet) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _VaultSetupConstants.emergencyRed.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(_VaultSetupConstants.smallBorderRadius),
                    border: Border.all(
                      color: _VaultSetupConstants.emergencyRed.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: _VaultSetupConstants.emergencyRed.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.priority_high_rounded,
                          color: _VaultSetupConstants.emergencyRed,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Emergency protocol not configured. This ensures your evidence reaches trusted contacts if something happens.',
                          style: TextStyle(
                            fontSize: 14,
                            color: _VaultSetupConstants.textDark,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
              
              // Protocol Options
              Column(
                children: [
                  _buildProtocolOption(
                    context,
                    icon: Icons.access_time,
                    title: 'Check-in Timer',
                    subtitle: safetyProvider.emergencyProtocolSet 
                        ? 'Every 24 hours' 
                        : 'Not set',
                    isConfigured: safetyProvider.emergencyProtocolSet,
                    onTap: () => _showTimerSettings(context),
                  ),
                  const SizedBox(height: 8),
                  _buildProtocolOption(
                    context,
                    icon: Icons.contacts,
                    title: 'Trusted Contacts',
                    subtitle: '3 contacts configured',
                    isConfigured: true,
                    onTap: () => _showTrustedContacts(context),
                  ),
                  const SizedBox(height: 8),
                  _buildProtocolOption(
                    context,
                    icon: Icons.gavel,
                    title: 'Legal Contacts',
                    subtitle: 'NGOs & Legal aid configured',
                    isConfigured: true,
                    onTap: () => _showLegalContacts(context),
                  ),
                  const SizedBox(height: 8),
                  _buildProtocolOption(
                    context,
                    icon: Icons.cloud_upload,
                    title: 'Data Release Rules',
                    subtitle: 'Auto-share conditions set',
                    isConfigured: true,
                    onTap: () => _showDataReleaseRules(context),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Enhanced Trusted Contacts Section
              if (safetyProvider.emergencyProtocolSet) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _VaultSetupConstants.successGreen.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(_VaultSetupConstants.smallBorderRadius),
                    border: Border.all(
                      color: _VaultSetupConstants.successGreen.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: _VaultSetupConstants.successGreen.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.verified_user_rounded,
                              color: _VaultSetupConstants.successGreen,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Protocol Active',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _VaultSetupConstants.successGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildTrustedContactsList(safetyProvider),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 16),
              
              // Single Setup/Edit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _setupProtocol(context),
                  icon: Icon(
                    safetyProvider.emergencyProtocolSet 
                        ? Icons.edit 
                        : Icons.add,
                    size: 18,
                  ),
                  label: Text(
                    safetyProvider.emergencyProtocolSet 
                        ? 'Edit Protocol' 
                        : 'Setup Protocol',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: safetyProvider.emergencyProtocolSet 
                        ? _VaultSetupConstants.primaryPurple
                        : _VaultSetupConstants.emergencyRed,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_VaultSetupConstants.smallBorderRadius),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTrustedContactsList(SafetyProvider safetyProvider) {
    // Sample trusted contacts (in a real app, this would come from safetyProvider)
    final List<Map<String, String>> trustedContacts = [
      {'name': 'Sarah Johnson', 'relation': 'Sister', 'initials': 'SJ'},
      {'name': 'Mike Chen', 'relation': 'Best Friend', 'initials': 'MC'},
      {'name': 'Dr. Emma Wilson', 'relation': 'Family Doctor', 'initials': 'EW'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trusted Contacts (${trustedContacts.length})',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _VaultSetupConstants.textDark,
          ),
        ),
        const SizedBox(height: 12),
        ...trustedContacts.map((contact) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _VaultSetupConstants.primaryPurple,
                      _VaultSetupConstants.secondaryPurple,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    contact['initials']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact['name']!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _VaultSetupConstants.textDark,
                      ),
                    ),
                    Text(
                      contact['relation']!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _VaultSetupConstants.successGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  Icons.verified_user_rounded,
                  color: _VaultSetupConstants.successGreen,
                  size: 16,
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildProtocolOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isConfigured,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isConfigured 
                  ? const Color(0xFF4CAF50) 
                  : const Color(0xFF757575),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF212121),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFF212121).withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isConfigured ? Icons.check_circle : Icons.arrow_forward_ios,
              color: isConfigured 
                  ? const Color(0xFF4CAF50) 
                  : const Color(0xFF757575),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showTimerSettings(BuildContext context) {
    int selectedHours = 24;
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_VaultSetupConstants.borderRadius),
          ),
          elevation: 24,
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(_VaultSetupConstants.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _VaultSetupConstants.primaryPurple,
                        _VaultSetupConstants.secondaryPurple,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(_VaultSetupConstants.borderRadius),
                      topRight: Radius.circular(_VaultSetupConstants.borderRadius),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(_VaultSetupConstants.smallBorderRadius),
                        ),
                        child: const Icon(
                          Icons.access_time,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Check-in Timer',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Content Section
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _VaultSetupConstants.primaryOrange.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(_VaultSetupConstants.smallBorderRadius),
                          border: Border.all(
                            color: _VaultSetupConstants.primaryOrange.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_rounded,
                              color: _VaultSetupConstants.primaryOrange,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'How often should the app check if you\'re safe? If you miss a check-in, your emergency protocol activates.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Timer Options
                      _buildTimerOption(
                        context,
                        setState,
                        selectedHours,
                        12,
                        'Every 12 hours',
                        'More frequent check-ins for high-risk situations',
                        (value) => selectedHours = value,
                      ),
                      _buildTimerOption(
                        context,
                        setState,
                        selectedHours,
                        24,
                        'Every 24 hours',
                        'Recommended for most users',
                        (value) => selectedHours = value,
                      ),
                      _buildTimerOption(
                        context,
                        setState,
                        selectedHours,
                        48,
                        'Every 48 hours',
                        'Less frequent for lower-risk environments',
                        (value) => selectedHours = value,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey[400]!),
                                foregroundColor: Colors.grey[600],
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(_VaultSetupConstants.smallBorderRadius),
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Provider.of<SafetyProvider>(context, listen: false)
                                    .setEmergencyProtocol(true);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Check-in timer set to $selectedHours hours'),
                                    backgroundColor: _VaultSetupConstants.successGreen,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _VaultSetupConstants.primaryPurple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(_VaultSetupConstants.smallBorderRadius),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Save Timer',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
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

  Widget _buildTimerOption(
    BuildContext context,
    StateSetter setState,
    int selectedHours,
    int value,
    String title,
    String subtitle,
    Function(int) onChanged,
  ) {
    final bool isSelected = selectedHours == value;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          setState(() {
            onChanged(value);
          });
        },
        borderRadius: BorderRadius.circular(_VaultSetupConstants.smallBorderRadius),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected 
                ? _VaultSetupConstants.primaryPurple.withValues(alpha: 0.05)
                : Colors.white,
            borderRadius: BorderRadius.circular(_VaultSetupConstants.smallBorderRadius),
            border: Border.all(
              color: isSelected 
                  ? _VaultSetupConstants.primaryPurple
                  : Colors.grey.withValues(alpha: 0.3),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected 
                        ? _VaultSetupConstants.primaryPurple 
                        : Colors.grey[400]!,
                    width: 2,
                  ),
                  color: isSelected 
                      ? _VaultSetupConstants.primaryPurple 
                      : Colors.transparent,
                ),
                child: isSelected 
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 14,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected 
                            ? _VaultSetupConstants.primaryPurple 
                            : _VaultSetupConstants.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTrustedContacts(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_VaultSetupConstants.borderRadius),
        ),
        elevation: 24,
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(_VaultSetupConstants.borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _VaultSetupConstants.primaryPurple,
                      _VaultSetupConstants.secondaryPurple,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(_VaultSetupConstants.borderRadius),
                    topRight: Radius.circular(_VaultSetupConstants.borderRadius),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(_VaultSetupConstants.smallBorderRadius),
                      ),
                      child: const Icon(
                        Icons.contacts,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Trusted Contacts',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content Section
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _VaultSetupConstants.primaryPurple.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(_VaultSetupConstants.smallBorderRadius),
                          border: Border.all(
                            color: _VaultSetupConstants.primaryPurple.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_rounded,
                              color: _VaultSetupConstants.primaryPurple,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'These people will receive your evidence and location if the emergency protocol activates. Choose people you trust completely.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Current Trusted Contacts:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildContactItem('Sarah Johnson', 'Sister', 'Primary Contact', true),
                      _buildContactItem('Mike Chen', 'Best Friend', 'Secondary Contact', true),
                      _buildContactItem('Dr. Emma Wilson', 'Family Doctor', 'Medical Contact', true),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _VaultSetupConstants.successGreen.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(_VaultSetupConstants.smallBorderRadius),
                          border: Border.all(
                            color: _VaultSetupConstants.successGreen.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: _VaultSetupConstants.successGreen.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.check_circle_rounded,
                                color: _VaultSetupConstants.successGreen,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'All contacts verified and ready',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _VaultSetupConstants.successGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Action Buttons
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey[400]!),
                          foregroundColor: Colors.grey[600],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(_VaultSetupConstants.smallBorderRadius),
                          ),
                        ),
                        child: const Text(
                          'Close',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Contact management opened'),
                              backgroundColor: _VaultSetupConstants.primaryPurple,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text(
                          'Manage Contacts',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _VaultSetupConstants.primaryPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(_VaultSetupConstants.smallBorderRadius),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(String name, String relation, String role, bool isVerified) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_VaultSetupConstants.smallBorderRadius),
        border: Border.all(
          color: isVerified 
              ? _VaultSetupConstants.successGreen.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _VaultSetupConstants.primaryPurple,
                  _VaultSetupConstants.secondaryPurple,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Text(
                name.split(' ').map((e) => e[0]).join(''),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$relation • $role',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isVerified 
                  ? _VaultSetupConstants.successGreen.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              isVerified ? Icons.verified_user : Icons.person,
              color: isVerified 
                  ? _VaultSetupConstants.successGreen 
                  : Colors.grey,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _showLegalContacts(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_VaultSetupConstants.borderRadius),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _VaultSetupConstants.primaryOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(_VaultSetupConstants.smallBorderRadius),
              ),
              child: Icon(
                Icons.gavel,
                color: _VaultSetupConstants.primaryOrange,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Legal & NGO Contacts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _VaultSetupConstants.primaryOrange.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(_VaultSetupConstants.smallBorderRadius),
                  border: Border.all(
                    color: _VaultSetupConstants.primaryOrange.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  'Connected legal aid organizations and NGOs who can help if needed. They can receive your evidence with your permission.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Connected Organizations:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              _buildLegalContactItem(
                'Women\'s Legal Centre',
                'Legal Aid & Support',
                'Primary Legal Contact',
                Icons.balance,
              ),
              _buildLegalContactItem(
                'Lifeline Crisis Support',
                '24/7 Crisis Counseling',
                'Emergency Hotline',
                Icons.phone,
              ),
              _buildLegalContactItem(
                'Human Rights Commission',
                'Rights Protection',
                'Documentation Support',
                Icons.security,
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _VaultSetupConstants.successGreen.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(_VaultSetupConstants.smallBorderRadius),
                  border: Border.all(
                    color: _VaultSetupConstants.successGreen.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      color: _VaultSetupConstants.successGreen,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '3 organizations connected and verified',
                        style: TextStyle(
                          fontSize: 14,
                          color: _VaultSetupConstants.successGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('NGO directory opened'),
                  backgroundColor: _VaultSetupConstants.primaryOrange,
                ),
              );
            },
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Browse More'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _VaultSetupConstants.primaryOrange,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalContactItem(String name, String description, String role, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_VaultSetupConstants.smallBorderRadius),
        border: Border.all(
          color: _VaultSetupConstants.primaryOrange.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _VaultSetupConstants.primaryOrange,
                  _VaultSetupConstants.primaryOrange.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$description • $role',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _VaultSetupConstants.successGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              Icons.verified_rounded,
              color: _VaultSetupConstants.successGreen,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _showDataReleaseRules(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_VaultSetupConstants.borderRadius),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _VaultSetupConstants.primaryPurple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(_VaultSetupConstants.smallBorderRadius),
              ),
              child: Icon(
                Icons.cloud_upload,
                color: _VaultSetupConstants.primaryPurple,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Data Release Rules',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _VaultSetupConstants.primaryPurple.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(_VaultSetupConstants.smallBorderRadius),
                  border: Border.all(
                    color: _VaultSetupConstants.primaryPurple.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  'Your evidence and location will be automatically shared when these conditions are met. All sharing is encrypted and secure.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Current Rules:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              _buildRuleItem(
                'Missed Check-in',
                'Share evidence if check-in missed for 48+ hours',
                Icons.schedule,
                true,
              ),
              _buildRuleItem(
                'Emergency Trigger',
                'Share immediately when emergency button pressed',
                Icons.emergency,
                true,
              ),
              _buildRuleItem(
                'Location Alert',
                'Share if device remains at risk location too long',
                Icons.location_on,
                true,
              ),
              _buildRuleItem(
                'SOS Signal',
                'Share when triple-tap power button detected',
                Icons.touch_app,
                true,
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _VaultSetupConstants.successGreen.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(_VaultSetupConstants.smallBorderRadius),
                  border: Border.all(
                    color: _VaultSetupConstants.successGreen.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.shield_rounded,
                      color: _VaultSetupConstants.successGreen,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'All rules configured and active',
                        style: TextStyle(
                          fontSize: 14,
                          color: _VaultSetupConstants.successGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Rule configuration opened'),
                  backgroundColor: _VaultSetupConstants.primaryPurple,
                ),
              );
            },
            icon: const Icon(Icons.settings, size: 16),
            label: const Text('Configure'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _VaultSetupConstants.primaryPurple,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleItem(String title, String description, IconData icon, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_VaultSetupConstants.smallBorderRadius),
        border: Border.all(
          color: isActive 
              ? _VaultSetupConstants.successGreen.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isActive 
                  ? _VaultSetupConstants.primaryPurple.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              icon,
              color: isActive 
                  ? _VaultSetupConstants.primaryPurple
                  : Colors.grey,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isActive 
                  ? _VaultSetupConstants.successGreen.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              isActive ? Icons.check_circle : Icons.circle_outlined,
              color: isActive 
                  ? _VaultSetupConstants.successGreen 
                  : Colors.grey,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _setupProtocol(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_VaultSetupConstants.borderRadius),
        ),
        elevation: 24,
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(_VaultSetupConstants.borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _VaultSetupConstants.emergencyRed,
                      _VaultSetupConstants.primaryOrange,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(_VaultSetupConstants.borderRadius),
                    topRight: Radius.circular(_VaultSetupConstants.borderRadius),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(_VaultSetupConstants.smallBorderRadius),
                      ),
                      child: const Icon(
                        Icons.shield_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Emergency Protocol Setup',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content Section
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Important Notice
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _VaultSetupConstants.emergencyRed.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(_VaultSetupConstants.smallBorderRadius),
                        border: Border.all(
                          color: _VaultSetupConstants.emergencyRed.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _VaultSetupConstants.emergencyRed.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.priority_high_rounded,
                              color: _VaultSetupConstants.emergencyRed,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Important for Your Safety',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _VaultSetupConstants.emergencyRed,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'This ensures someone knows if you\'re in danger and can help.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Setup Steps
                    const Text(
                      'Setup includes:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildSetupStep(
                      Icons.schedule_rounded,
                      'Check-in Timer',
                      'Set how often you need to confirm you\'re safe',
                    ),
                    _buildSetupStep(
                      Icons.contacts_rounded,
                      'Trusted Contacts',
                      'Choose people who will receive your evidence',
                    ),
                    _buildSetupStep(
                      Icons.gavel_rounded,
                      'Legal Contacts',
                      'Connect with NGOs and legal aid organizations',
                    ),
                    _buildSetupStep(
                      Icons.rule_rounded,
                      'Release Rules',
                      'Define when evidence should be shared automatically',
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey[400]!),
                              foregroundColor: Colors.grey[600],
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(_VaultSetupConstants.smallBorderRadius),
                              ),
                            ),
                            child: const Text(
                              'Maybe Later',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              Provider.of<SafetyProvider>(context, listen: false)
                                  .setEmergencyProtocol(true);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Emergency protocol setup completed'),
                                  backgroundColor: _VaultSetupConstants.successGreen,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.security_rounded, size: 18),
                            label: const Text(
                              'Start Setup',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _VaultSetupConstants.emergencyRed,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(_VaultSetupConstants.smallBorderRadius),
                              ),
                              elevation: 0,
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
    );
  }

  Widget _buildSetupStep(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _VaultSetupConstants.primaryPurple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(_VaultSetupConstants.smallBorderRadius),
            ),
            child: Icon(
              icon,
              color: _VaultSetupConstants.primaryPurple,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
