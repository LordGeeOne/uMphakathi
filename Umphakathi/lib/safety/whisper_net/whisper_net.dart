import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/safety_provider.dart';
import 'widgets/evidence_recorder.dart';
import 'widgets/vault_setup.dart';

class WhisperNetPage extends StatefulWidget {
  const WhisperNetPage({super.key});

  @override
  State<WhisperNetPage> createState() => _WhisperNetPageState();
}

// Constants for styling consistency with home page
class _WhisperNetConstants {
  static const Color primaryPurple = Color(0xFF6A1B9A);
  static const Color secondaryPurple = Color(0xFF8E24AA);
  static const Color primaryOrange = Color(0xFFEC7E33);
  static const Color textDark = Color(0xFF212121);
  
  static const double sectionSpacing = 24.0;
  static const double cardSpacing = 12.0;
  static const double borderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  
  static const EdgeInsets standardPadding = EdgeInsets.all(16);
  static const EdgeInsets cardPadding = EdgeInsets.all(20);
  
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

class _WhisperNetPageState extends State<WhisperNetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'WhisperNet',
          style: GoogleFonts.dancingScript(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
        backgroundColor: _WhisperNetConstants.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _WhisperNetConstants.primaryPurple,
                _WhisperNetConstants.secondaryPurple,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.security),
            onPressed: () => _showSecurityInfo(),
          ),
        ],
      ),
      body: Consumer<SafetyProvider>(
        builder: (context, safetyProvider, child) {
          return SingleChildScrollView(
            padding: _WhisperNetConstants.standardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSecurityBanner(),
                SizedBox(height: _WhisperNetConstants.sectionSpacing),
                _buildSectionHeader('Document Evidence', Icons.security),
                SizedBox(height: _WhisperNetConstants.cardSpacing),
                const EvidenceRecorder(),
                SizedBox(height: _WhisperNetConstants.sectionSpacing),
                _buildSectionHeader('Emergency Protocols', Icons.shield_rounded),
                SizedBox(height: _WhisperNetConstants.cardSpacing),
                const VaultSetup(),
                SizedBox(height: _WhisperNetConstants.sectionSpacing),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: _WhisperNetConstants.primaryOrange,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(title, style: _WhisperNetConstants.sectionTitleStyle),
        const SizedBox(width: 12),
        Icon(icon, color: _WhisperNetConstants.primaryOrange, size: 20),
      ],
    );
  }

  Widget _buildSecurityBanner() {
    return Container(
      width: double.infinity,
      padding: _WhisperNetConstants.cardPadding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_WhisperNetConstants.borderRadius),
        border: Border.all(
          color: _WhisperNetConstants.primaryPurple.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          _WhisperNetConstants.primaryShadow,
          _WhisperNetConstants.secondaryShadow,
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  _WhisperNetConstants.primaryPurple,
                  _WhisperNetConstants.primaryOrange,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(_WhisperNetConstants.smallBorderRadius),
            ),
            child: const Icon(
              Icons.shield_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'End-to-End Encrypted',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _WhisperNetConstants.primaryPurple,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Nothing leaves your phone without your command',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.verified_user_rounded,
            color: _WhisperNetConstants.primaryPurple,
            size: 24,
          ),
        ],
      ),
    );
  }

  void _showSecurityInfo() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_WhisperNetConstants.borderRadius),
        ),
        elevation: 24,
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(_WhisperNetConstants.borderRadius),
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
                      _WhisperNetConstants.primaryPurple,
                      _WhisperNetConstants.secondaryPurple,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(_WhisperNetConstants.borderRadius),
                    topRight: Radius.circular(_WhisperNetConstants.borderRadius),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(_WhisperNetConstants.smallBorderRadius),
                      ),
                      child: const Icon(
                        Icons.security,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Security Information',
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
                    // Security Features
                    _buildSecurityFeature(
                      Icons.lock_rounded,
                      'End-to-End Encryption',
                      'All your data is encrypted with military-grade security before leaving your device.',
                    ),
                    const SizedBox(height: 16),
                    _buildSecurityFeature(
                      Icons.phone_android_rounded,
                      'Local Storage',
                      'Evidence is stored securely on your device and only shared when you choose.',
                    ),
                    const SizedBox(height: 16),
                    _buildSecurityFeature(
                      Icons.schedule_rounded,
                      'Auto-Timestamping',
                      'All evidence is automatically timestamped and geo-tagged for authenticity.',
                    ),
                    const SizedBox(height: 16),
                    _buildSecurityFeature(
                      Icons.verified_user_rounded,
                      'Privacy First',
                      'Nothing leaves your phone without your explicit command and consent.',
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Action Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _WhisperNetConstants.primaryPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(_WhisperNetConstants.smallBorderRadius),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Got it',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
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

  Widget _buildSecurityFeature(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _WhisperNetConstants.primaryPurple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(_WhisperNetConstants.smallBorderRadius),
          ),
          child: Icon(
            icon,
            color: _WhisperNetConstants.primaryPurple,
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
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _WhisperNetConstants.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
