import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../forum_list/forum_list.dart';
import '../safety/whisper_net/whisper_net.dart';
import '../safety/circle_safe/circle_safe.dart';
import '../safety/ai_analytics/ai_analytics.dart';
import '../settings/settings_screen.dart';
import '../vault/services/media_service.dart';
import '../audio_record/audio_recording.dart';
import '../safety/providers/safety_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// Constants for styling consistency
class _HomePageConstants {
  static const Color primaryPurple = Color(0xFF6A1B9A);
  static const Color secondaryPurple = Color(0xFF8E24AA);
  static const Color primaryOrange = Color(0xFFEC7E33);
  static const Color textDark = Color(0xFF212121);
  
  static const double sectionSpacing = 32.0;
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

// Data class for quick actions
class _QuickActionData {
  final IconData icon;
  final String label;
  final String featureName;
  
  const _QuickActionData(this.icon, this.label, this.featureName);
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentImageIndex = 0;
  
  final List<String> _backgroundImages = [
    'lib/assets/picture1.jpg',
    'lib/assets/picture2.jpeg',
    'lib/assets/picture3.jpeg',
  ];

  // PIN verification state
  String _enteredPin = '';
  final String _correctPin = '1234'; // For demo purposes
  bool _isPinIncorrect = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    // Auto-slide images every 4 seconds
    _startAutoSlide();
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        setState(() {
          _currentImageIndex = (_currentImageIndex + 1) % _backgroundImages.length;
        });
        _pageController.animateToPage(
          _currentImageIndex,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
        _startAutoSlide();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(),
            Padding(
              padding: _HomePageConstants.standardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildSectionHeader('Emergency Safety', Icons.security),
                  SizedBox(height: _HomePageConstants.cardSpacing),
                  _buildEmergencyFeatures(),
                  SizedBox(height: _HomePageConstants.cardSpacing),
                  _buildAIAnalyticsCard(),
                  SizedBox(height: _HomePageConstants.sectionSpacing),
                  _buildSectionHeader('Community & Support', Icons.people),
                  SizedBox(height: _HomePageConstants.cardSpacing),
                  _buildSpeakHubCard(),
                  SizedBox(height: _HomePageConstants.sectionSpacing),
                  _buildSectionHeader('Quick Actions', Icons.flash_on),
                  SizedBox(height: _HomePageConstants.cardSpacing),
                  _buildQuickActionsSection(),
                  SizedBox(height: _HomePageConstants.sectionSpacing),
                ],
              ),
            ),
          ],
        ),
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
            color: _HomePageConstants.primaryOrange,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(title, style: _HomePageConstants.sectionTitleStyle),
        const SizedBox(width: 12),
        Icon(icon, color: _HomePageConstants.primaryOrange, size: 20),
      ],
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          _buildImageCarousel(),
          _buildHeroContent(),
          _buildPageIndicators(),
          _buildSettingsButton(),
        ],
      ),
    );
  }

  Widget _buildImageCarousel() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentImageIndex = index;
        });
      },
      itemCount: _backgroundImages.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(_backgroundImages[index]),
              fit: BoxFit.cover,
              onError: (exception, stackTrace) {
                // Handle image load error
              },
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _HomePageConstants.primaryPurple.withValues(alpha: 0.3),
                  _HomePageConstants.secondaryPurple.withValues(alpha: 0.3),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroContent() {
    return Positioned.fill(
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_currentImageIndex != 2) ..._buildHeroText(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildHeroText() {
    return [
      Text(
        'uMphakathi',
        style: GoogleFonts.dancingScript(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
          color: Colors.white,
          shadows: const [
            Shadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 16),
      const Icon(Icons.shield_rounded, size: 48, color: Colors.white),
      const SizedBox(height: 12),
      const Text(
        'Stay Safe, Stay Connected',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 6),
      const Text(
        'Your safety network in your pocket',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black26,
              offset: Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    ];
  }

  Widget _buildPageIndicators() {
    return Positioned(
      bottom: 16,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _backgroundImages.asMap().entries.map((entry) {
          return Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentImageIndex == entry.key
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.4),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmergencyFeatures() {
    return Row(
      children: [
        Expanded(
          child: _buildPrimaryFeatureCard(
            context,
            icon: Icons.security,
            title: 'WhisperNet',
            subtitle: 'Document evidence',
            color: _HomePageConstants.primaryPurple,
            onTap: () => _showPinDialog(() => _navigateToPage(const WhisperNetPage())),
          ),
        ),
        SizedBox(width: _HomePageConstants.cardSpacing),
        Expanded(
          child: _buildPrimaryFeatureCard(
            context,
            icon: Icons.people_rounded,
            title: 'SafeCircle',
            subtitle: 'Trusted contacts',
            color: _HomePageConstants.primaryPurple,
            onTap: () => _navigateToPage(const CircleSafePage()),
          ),
        ),
      ],
    );
  }

  Widget _buildAIAnalyticsCard() {
    return _buildSecondaryFeatureCard(
      context,
      icon: Icons.psychology_rounded,
      title: 'AI & Analytics',
      subtitle: 'Personal AI companion and wellbeing insights',
      color: _HomePageConstants.primaryPurple,
      onTap: () => _navigateToPage(const AiAnalyticsPage()),
    );
  }

  Widget _buildSpeakHubCard() {
    return _buildSecondaryFeatureCard(
      context,
      icon: Icons.forum_rounded,
      title: 'SpeakHub',
      subtitle: 'Connect and share experiences safely',
      color: _HomePageConstants.secondaryPurple,
      onTap: () => _navigateToPage(const SpeakHubListPage()),
    );
  }

  Widget _buildQuickActionsSection() {
    final quickActions = [
      _QuickActionData(Icons.camera_alt_rounded, 'Quick\nPhoto', 'Quick Photo'),
      _QuickActionData(Icons.mic_rounded, 'Voice\nNote', 'Voice Note'),
      _QuickActionData(Icons.lock_rounded, 'Screen\nLock', 'Screen Lock'),
      _QuickActionData(Icons.my_location_rounded, 'Share\nLocation', 'Location Sharing'),
    ];

    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(_HomePageConstants.borderRadius),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          spacing: 4,
          runSpacing: 16,
          children: quickActions.map((action) => 
            _buildQuickAction(
              context,
              icon: action.icon,
              label: action.label,
              color: _HomePageConstants.primaryPurple,
              onTap: () {
                switch (action.featureName) {
                  case 'Quick Photo':
                    _quickPhoto();
                    break;
                  case 'Voice Note':
                    _quickVoiceNote();
                    break;
                  case 'Screen Lock':
                    _showScreenLock(context);
                    break;
                  case 'Location Sharing':
                    _shareLocation();
                    break;
                  default:
                    _showComingSoon(context, action.featureName);
                }
              },
            ),
          ).toList(),
        ),
      ),
    );
  }

  void _navigateToPage(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  // PIN verification dialog for WhisperNet access
  void _showPinDialog(VoidCallback onSuccess) {
    setState(() {
      _enteredPin = '';
      _isPinIncorrect = false;
    });

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_HomePageConstants.borderRadius),
              ),
              title: Row(
                children: [
                  Icon(
                    Icons.security_rounded,
                    color: _HomePageConstants.primaryPurple,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'WhisperNet Access',
                    style: TextStyle(
                      color: _HomePageConstants.primaryPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 280,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Enter your 4-digit PIN to access secure evidence documentation',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    
                    // PIN display dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        bool isFilled = index < _enteredPin.length;
                        bool isError = _isPinIncorrect;
                        
                        return Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isError 
                                ? Colors.red
                                : isFilled 
                                    ? _HomePageConstants.primaryPurple 
                                    : Colors.grey[300],
                            border: Border.all(
                              color: isError 
                                  ? Colors.red
                                  : isFilled 
                                      ? _HomePageConstants.primaryPurple 
                                      : Colors.grey[400]!,
                              width: 2,
                            ),
                          ),
                        );
                      }),
                    ),
                    
                    if (_isPinIncorrect) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Incorrect PIN. Please try again.',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 24),
                    
                    // Number pad
                    _buildNumberPad(setDialogState, onSuccess, dialogContext),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_HomePageConstants.smallBorderRadius),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildNumberPad(StateSetter setDialogState, VoidCallback onSuccess, BuildContext dialogContext) {
    return SizedBox(
      width: 240,
      child: Column(
        children: [
          // First row: 1, 2, 3
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumberButton('1', setDialogState, onSuccess, dialogContext),
              _buildNumberButton('2', setDialogState, onSuccess, dialogContext),
              _buildNumberButton('3', setDialogState, onSuccess, dialogContext),
            ],
          ),
          const SizedBox(height: 12),
          
          // Second row: 4, 5, 6
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumberButton('4', setDialogState, onSuccess, dialogContext),
              _buildNumberButton('5', setDialogState, onSuccess, dialogContext),
              _buildNumberButton('6', setDialogState, onSuccess, dialogContext),
            ],
          ),
          const SizedBox(height: 12),
          
          // Third row: 7, 8, 9
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumberButton('7', setDialogState, onSuccess, dialogContext),
              _buildNumberButton('8', setDialogState, onSuccess, dialogContext),
              _buildNumberButton('9', setDialogState, onSuccess, dialogContext),
            ],
          ),
          const SizedBox(height: 12),
          
          // Fourth row: backspace, 0, empty
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBackspaceButton(setDialogState),
              _buildNumberButton('0', setDialogState, onSuccess, dialogContext),
              const SizedBox(width: 60), // Empty space for symmetry
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberButton(String number, StateSetter setDialogState, VoidCallback onSuccess, BuildContext dialogContext) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onNumberPressed(number, setDialogState, onSuccess, dialogContext),
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey[300]!),
            color: Colors.grey[50],
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton(StateSetter setDialogState) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onBackspacePressed(setDialogState),
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey[300]!),
            color: Colors.grey[50],
          ),
          child: const Center(
            child: Icon(
              Icons.backspace_outlined,
              size: 24,
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  void _onNumberPressed(String number, StateSetter setDialogState, VoidCallback onSuccess, BuildContext dialogContext) {
    if (_enteredPin.length < 4) {
      setDialogState(() {
        _enteredPin += number;
        _isPinIncorrect = false;
      });
      
      // Check PIN when 4 digits are entered
      if (_enteredPin.length == 4) {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (_enteredPin == _correctPin) {
            Navigator.of(dialogContext).pop();
            onSuccess();
          } else {
            setDialogState(() {
              _isPinIncorrect = true;
            });
            
            // Reset PIN after a delay
            Future.delayed(const Duration(milliseconds: 1000), () {
              setDialogState(() {
                _enteredPin = '';
                _isPinIncorrect = false;
              });
            });
          }
        });
      }
    }
  }

  void _onBackspacePressed(StateSetter setDialogState) {
    if (_enteredPin.isNotEmpty) {
      setDialogState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        _isPinIncorrect = false;
      });
    }
  }

  // Helper method for showing coming soon features
  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon!'),
        backgroundColor: _HomePageConstants.primaryPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_HomePageConstants.smallBorderRadius),
        ),
      ),
    );
  }

  // WhisperNet Quick Actions
  Future<void> _quickPhoto() async {
    try {
      final file = await MediaService.takePhoto();
      if (file != null) {
        final safetyProvider = Provider.of<SafetyProvider>(context, listen: false);
        final evidence = EvidenceEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: 'photo',
          content: file.path,
          timestamp: DateTime.now(),
        );
        await safetyProvider.addEvidenceEntry(evidence);
        _showSuccessSnackBar('Photo evidence recorded securely');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to take photo: $e');
    }
  }

  Future<void> _quickVoiceNote() async {
    try {
      // Navigate to the dedicated audio recording page
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AudioRecordingPage(),
        ),
      );
    } catch (e) {
      _showErrorSnackBar('Failed to navigate to voice recording: $e');
    }
  }

  void _shareLocation() {
    // For now, show a stub functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.location_on, color: Colors.white, size: 16),
            SizedBox(width: 8),
            Text('Location shared with your SafeCircle'),
          ],
        ),
        backgroundColor: _HomePageConstants.primaryPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_HomePageConstants.smallBorderRadius),
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_HomePageConstants.smallBorderRadius),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFF44336),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_HomePageConstants.smallBorderRadius),
        ),
      ),
    );
  }

  // Method to show screen lock overlay
  void _showScreenLock(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const _StubScreenLockOverlay(),
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        fullscreenDialog: true,
        opaque: true,
      ),
    );
  }

  // Optimized primary feature cards for safety features
  Widget _buildPrimaryFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_HomePageConstants.borderRadius),
        child: Container(
          padding: _HomePageConstants.cardInternalPadding,
          decoration: _buildCardDecoration(
            borderColor: _HomePageConstants.primaryPurple.withValues(alpha: 0.3),
            borderWidth: 2,
          ),
          child: Column(
            children: [
              _buildGradientIconContainer(icon),
              SizedBox(height: _HomePageConstants.cardSpacing),
              _buildCardTitle(title, _HomePageConstants.primaryPurple),
              const SizedBox(height: 4),
              _buildCardSubtitle(subtitle),
            ],
          ),
        ),
      ),
    );
  }

  // Optimized secondary feature cards for community features
  Widget _buildSecondaryFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_HomePageConstants.borderRadius),
        child: Container(
          width: double.infinity,
          padding: _HomePageConstants.cardInternalPadding,
          decoration: _buildCardDecoration(
            borderColor: color.withValues(alpha: 0.2),
            shadows: [
              _HomePageConstants.secondaryShadow,
              _HomePageConstants.primaryShadow.copyWith(blurRadius: 12, offset: const Offset(0, 4)),
            ],
          ),
          child: Row(
            children: [
              _buildColoredIconContainer(icon, color),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCardTitle(title, color, fontSize: 18),
                    const SizedBox(height: 4),
                    _buildCardSubtitle(subtitle, fontSize: 14),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  // Optimized quick action buttons
  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_HomePageConstants.smallBorderRadius),
        child: Container(
          width: 80,
          height: 80,
          decoration: _buildQuickActionDecoration(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: color),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable decoration builders
  BoxDecoration _buildCardDecoration({
    Color? borderColor,
    double borderWidth = 1,
    List<BoxShadow>? shadows,
  }) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(_HomePageConstants.borderRadius),
      border: Border.all(color: borderColor ?? Colors.grey[200]!, width: borderWidth),
      boxShadow: shadows ?? [_HomePageConstants.primaryShadow],
    );
  }

  BoxDecoration _buildQuickActionDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(_HomePageConstants.smallBorderRadius),
      border: Border.all(color: Colors.grey[300]!),
      boxShadow: [
        BoxShadow(
          color: _HomePageConstants.primaryOrange.withValues(alpha: 0.2),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // Reusable component builders
  Widget _buildGradientIconContainer(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_HomePageConstants.primaryPurple, _HomePageConstants.primaryOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(_HomePageConstants.smallBorderRadius),
      ),
      child: Icon(icon, size: 32, color: Colors.white),
    );
  }

  Widget _buildColoredIconContainer(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(_HomePageConstants.smallBorderRadius),
      ),
      child: Icon(icon, size: 32, color: color),
    );
  }

  Widget _buildCardTitle(String title, Color color, {double fontSize = 16}) {
    return Text(
      title,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color,
      ),
      textAlign: fontSize == 16 ? TextAlign.center : TextAlign.start,
    );
  }

  Widget _buildCardSubtitle(String subtitle, {double fontSize = 12}) {
    return Text(
      subtitle,
      style: TextStyle(fontSize: fontSize, color: Colors.grey[600]),
      textAlign: fontSize == 12 ? TextAlign.center : TextAlign.start,
    );
  }

  Widget _buildSettingsButton() {
    return Positioned(
      top: 20,
      right: 16,
      child: SafeArea(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.settings,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Stub Screen Lock Overlay for visual demonstration
class _StubScreenLockOverlay extends StatefulWidget {
  const _StubScreenLockOverlay();

  @override
  State<_StubScreenLockOverlay> createState() => _StubScreenLockOverlayState();
}

class _StubScreenLockOverlayState extends State<_StubScreenLockOverlay> with TickerProviderStateMixin {
  double _sliderPosition = 0.0;
  late AnimationController _animationController;
  late Animation<double> _unlockAnimation;
  bool _hasTriggeredUnlock = false;
  bool _showUnlockHint = false;
  final bool _isAlertActive = false;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _unlockAnimation = Tween<double>(
      begin: 0.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ))..addListener(() {
      if (mounted) {
        setState(() {
          _sliderPosition = _unlockAnimation.value;
        });
      }
    });

    // Show hint briefly when screen first appears
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showUnlockHint = true;
        });
        
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _showUnlockHint = false;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startUnlockAnimation() {
    _unlockAnimation = Tween<double>(
      begin: _sliderPosition,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxSliderDistance = screenWidth * 0.7;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background overlay
          Positioned.fill(
            child: Container(
              color: _isAlertActive 
                  ? Colors.red.withOpacity(0.1) 
                  : Colors.black.withOpacity(0.3),
            ),
          ),
          
          // Time and date display
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: _buildTimeDisplay(),
          ),
          
          // Lock icon indicator
          Positioned(
            top: 40,
            right: 20,
            child: Icon(
              Icons.lock,
              color: Colors.white.withOpacity(0.7),
              size: 24,
            ),
          ),
          
          // SafeWalk status indicator
          Positioned(
            top: 200,
            left: 0,
            right: 0,
            child: _buildSafeWalkStatus(),
          ),
          
          // Close button for demo purposes
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.close,
                color: Colors.white.withOpacity(0.7),
                size: 24,
              ),
            ),
          ),
          
          // Emergency info
          Positioned(
            left: 0,
            right: 0,
            bottom: 40,
            child: Center(
              child: Text(
                "SafeWalk active - Hardware buttons still work for panic",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ),
          ),
          
          // The unlock slider
          Positioned(
            left: 0,
            right: 0,
            bottom: 100, 
            child: _buildUnlockSlider(maxSliderDistance),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeDisplay() {
    final now = DateTime.now();
    final timeString = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final dateString = '${_getWeekday(now.weekday)}, ${_getMonth(now.month)} ${now.day}';
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          timeString,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 68,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          dateString,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
  
  String _getWeekday(int weekday) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekday - 1];
  }
  
  String _getMonth(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  Widget _buildSafeWalkStatus() {
    final Color iconColor = _isAlertActive ? Colors.red : Colors.red.withOpacity(0.7);
    final Color circleColor = _isAlertActive ? Colors.red.withOpacity(0.3) : Colors.red.withOpacity(0.1);
    final String statusText = _isAlertActive ? "ALERT TRIGGERED!" : "SafeWalk Protection Active";
    final String subtitleText = _isAlertActive ? "Emergency services contacted" : "Panic buttons active";
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: circleColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            _isAlertActive ? Icons.warning_amber_rounded : Icons.shield_outlined,
            color: iconColor,
            size: 40,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          statusText,
          style: TextStyle(
            color: _isAlertActive ? Colors.red : Colors.red.withOpacity(0.9),
            fontSize: _isAlertActive ? 22 : 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitleText,
          style: TextStyle(
            color: _isAlertActive ? Colors.white : Colors.white.withOpacity(0.7),
            fontSize: _isAlertActive ? 16 : 14,
            fontWeight: _isAlertActive ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
  
  Widget _buildUnlockSlider(double maxSliderDistance) {
    const double unlockThreshold = 1.0;
    
    return Column(
      children: [
        AnimatedOpacity(
          opacity: _showUnlockHint ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Text(
            "Swipe to unlock",
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.red.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Track with dots
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  5,
                  (index) => Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              
              // "Slide to unlock" hint text
              Center(
                child: AnimatedOpacity(
                  opacity: 1.0 - (_sliderPosition / maxSliderDistance),
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    "Slide →",
                    style: TextStyle(
                      color: Colors.red.withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              
              // Progress indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: _sliderPosition,
                decoration: BoxDecoration(
                  color: _sliderPosition / maxSliderDistance >= unlockThreshold
                      ? Colors.red.withOpacity(0.2)
                      : Colors.redAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              
              // Draggable thumb
              Positioned(
                left: _sliderPosition,
                child: GestureDetector(
                  onHorizontalDragStart: (_) {
                    setState(() {
                      _hasTriggeredUnlock = false;
                      _showUnlockHint = true;
                    });
                  },
                  onHorizontalDragUpdate: (details) {
                    double newPosition = _sliderPosition + details.delta.dx;
                    newPosition = newPosition.clamp(0, maxSliderDistance);
                    
                    setState(() {
                      _sliderPosition = newPosition;
                    });
                    
                    // Check if we've passed the unlock threshold
                    if (!_hasTriggeredUnlock && _sliderPosition / maxSliderDistance >= unlockThreshold) {
                      _hasTriggeredUnlock = true;
                      
                      // Unlock with a slight delay
                      Future.delayed(const Duration(milliseconds: 200), () {
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      });
                    }
                  },
                  onHorizontalDragEnd: (_) {
                    if (!_hasTriggeredUnlock) {
                      _startUnlockAnimation();
                      
                      Future.delayed(const Duration(milliseconds: 500), () {
                        if (mounted) {
                          setState(() {
                            _showUnlockHint = false;
                          });
                        }
                      });
                    }
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _sliderPosition / maxSliderDistance >= unlockThreshold 
                          ? Colors.red 
                          : Colors.redAccent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (_sliderPosition / maxSliderDistance >= unlockThreshold 
                              ? Colors.red 
                              : Colors.redAccent).withOpacity(0.6),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      _sliderPosition / maxSliderDistance >= unlockThreshold 
                          ? Icons.lock_open
                          : Icons.arrow_forward,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
