import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../forum_list/forum_list.dart';
import '../vault/vault.dart';
import '../safety/whisper_net/whisper_net.dart';
import '../safety/circle_safe/circle_safe.dart';
import '../safety/ai_analytics/ai_analytics.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentImageIndex = 0;
  
  final List<String> _backgroundImages = [
    'lib/assets/picture1.jpg',
    'lib/assets/picture2.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    // Auto-slide images every 4 seconds
    _startAutoSlide();
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 4), () {
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
      appBar: AppBar(
        title: Text(
          'uMphakathi',
          style: GoogleFonts.dancingScript(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6A1B9A), // Deep Purple
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section with Background Images
            SizedBox(
              width: double.infinity,
              height: 300,
              child: Stack(
                children: [
                  // Background Images PageView
                  PageView.builder(
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
                                const Color(0xFF6A1B9A).withValues(alpha: 0.7),
                                const Color(0xFF8E24AA).withValues(alpha: 0.7),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  // Overlay Content
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.shield_rounded,
                            size: 64,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Stay Safe, Stay Connected',
                            style: TextStyle(
                              fontSize: 28,
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
                          const SizedBox(height: 8),
                          Text(
                            'Your safety network in your pocket',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              shadows: const [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Page Indicators
                  Positioned(
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
                  ),
                ],
              ),
            ),
            
            // Main Features
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  
                  // Emergency Features - Most Important
                  const Text(
                    'Emergency Safety',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildPrimaryFeatureCard(
                          context,
                          icon: Icons.security,
                          title: 'WhisperNet',
                          subtitle: 'Document evidence',
                          color: const Color(0xFF6A1B9A),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const WhisperNetPage()),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildPrimaryFeatureCard(
                          context,
                          icon: Icons.people_rounded,
                          title: 'CircleSafe',
                          subtitle: 'Trusted contacts',
                          color: const Color(0xFF6A1B9A),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CircleSafePage()),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // AI Analytics Feature Card
                  _buildSecondaryFeatureCard(
                    context,
                    icon: Icons.psychology_rounded,
                    title: 'AI & Analytics',
                    subtitle: 'Personal AI companion and wellbeing insights',
                    color: const Color(0xFF6A1B9A),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AiAnalyticsPage()),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Community Features
                  const Text(
                    'Community & Support',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  _buildSecondaryFeatureCard(
                    context,
                    icon: Icons.forum_rounded,
                    title: 'SpeakHub',
                    subtitle: 'Connect and share experiences safely',
                    color: const Color(0xFF8E24AA),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SpeakHubListPage()),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _buildSecondaryFeatureCard(
                    context,
                    icon: Icons.lock_rounded,
                    title: 'Secure Vault',
                    subtitle: 'Store photos, videos, and documents privately',
                    color: const Color(0xFF8E24AA),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const VaultPage()),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Quick Actions
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildQuickAction(
                          context,
                          icon: Icons.camera_alt_rounded,
                          label: 'Quick\nPhoto',
                          color: const Color(0xFF6A1B9A),
                          onTap: () => _showComingSoon(context, 'Quick Photo'),
                        ),
                        _buildQuickAction(
                          context,
                          icon: Icons.mic_rounded,
                          label: 'Voice\nNote',
                          color: const Color(0xFF6A1B9A),
                          onTap: () => _showComingSoon(context, 'Voice Note'),
                        ),
                        _buildQuickAction(
                          context,
                          icon: Icons.my_location_rounded,
                          label: 'Share\nLocation',
                          color: const Color(0xFF6A1B9A),
                          onTap: () => _showComingSoon(context, 'Location Sharing'),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for showing coming soon features
  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon!'),
        backgroundColor: const Color(0xFF6A1B9A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }

  // Primary feature cards for safety features
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
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Secondary feature cards for community features
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
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
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
              Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Quick action buttons
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
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 28,
                color: color,
              ),
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
}
