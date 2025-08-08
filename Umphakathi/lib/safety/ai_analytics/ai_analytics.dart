import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../whisper_net/widgets/ai_chat_widget.dart';
import '../whisper_net/widgets/wellbeing_tracker.dart';
import '../whisper_net/widgets/ai_nudge_toggle.dart';

// Constants for styling consistency
class _AiAnalyticsConstants {
  static const Color primaryPurple = Color(0xFF6A1B9A);
  static const Color secondaryPurple = Color(0xFF8E24AA);
  static const Color primaryOrange = Color(0xFFEC7E33);
  static const Color textDark = Color(0xFF212121);
  
  static const double sectionSpacing = 24.0;
  static const double cardSpacing = 12.0;
  static const double borderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  
  static const EdgeInsets standardPadding = EdgeInsets.all(16);
  
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

class AiAnalyticsPage extends StatelessWidget {
  const AiAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AI & Analytics',
          style: GoogleFonts.dancingScript(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
        backgroundColor: _AiAnalyticsConstants.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _AiAnalyticsConstants.primaryPurple,
                _AiAnalyticsConstants.secondaryPurple,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showAiInfo(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // AI Companion Chat - Full Screen
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: const AiChatWidget(),
            ),
          ),
          
          // Expandable bottom sheet for other content
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6, // Max 60% of screen height
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: ExpansionTile(
              leading: Icon(
                Icons.analytics_rounded,
                color: _AiAnalyticsConstants.primaryPurple,
              ),
              title: Text(
                'Analytics & Insights',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _AiAnalyticsConstants.textDark,
                ),
              ),
              subtitle: Text(
                'View your wellbeing trends and settings',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5, // Fixed height for scrollable content
                  child: SingleChildScrollView(
                    padding: _AiAnalyticsConstants.standardPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Privacy Notice
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(_AiAnalyticsConstants.smallBorderRadius),
                            border: Border.all(
                              color: _AiAnalyticsConstants.primaryPurple.withValues(alpha: 0.3),
                            ),
                            boxShadow: [
                              _AiAnalyticsConstants.secondaryShadow,
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _AiAnalyticsConstants.primaryPurple.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(_AiAnalyticsConstants.smallBorderRadius),
                                ),
                                child: Icon(
                                  Icons.lock_rounded,
                                  color: _AiAnalyticsConstants.primaryPurple,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'All conversations and data remain private on your device',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _AiAnalyticsConstants.primaryPurple,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: _AiAnalyticsConstants.sectionSpacing),
                        
                        // AI Safety Check-ins Section
                        _buildSectionHeader('AI Safety Check-ins', Icons.psychology_rounded),
                        SizedBox(height: _AiAnalyticsConstants.cardSpacing),
                        const AiNudgeToggle(),
                        
                        SizedBox(height: _AiAnalyticsConstants.sectionSpacing),
                        
                        // Wellbeing Analytics Section
                        _buildSectionHeader('Wellbeing Analytics', Icons.analytics_rounded),
                        SizedBox(height: _AiAnalyticsConstants.cardSpacing),
                        const WellbeingTracker(),
                        
                        SizedBox(height: _AiAnalyticsConstants.sectionSpacing),
                        
                        // Wellbeing Visual Chart
                        _buildSectionHeader('Wellbeing Trends', Icons.trending_up_rounded),
                        SizedBox(height: _AiAnalyticsConstants.cardSpacing),
                        _buildWellbeingChart(),
                        
                        SizedBox(height: _AiAnalyticsConstants.sectionSpacing),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, [IconData? icon]) {
    return Row(
      children: [
        Container(
          height: 3,
          width: 30,
          decoration: BoxDecoration(
            color: _AiAnalyticsConstants.primaryOrange,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        if (icon != null) ...[
          Icon(
            icon,
            color: _AiAnalyticsConstants.primaryPurple,
            size: 20,
          ),
          const SizedBox(width: 8),
        ],
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _AiAnalyticsConstants.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildWellbeingChart() {
    final List<WellbeingData> chartData = [
      WellbeingData('Mon', 6),
      WellbeingData('Tue', 7),
      WellbeingData('Wed', 5),
      WellbeingData('Thu', 8),
      WellbeingData('Fri', 7),
      WellbeingData('Sat', 9),
      WellbeingData('Sun', 8),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_AiAnalyticsConstants.borderRadius),
        boxShadow: [
          _AiAnalyticsConstants.primaryShadow,
          _AiAnalyticsConstants.secondaryShadow,
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _AiAnalyticsConstants.primaryPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(_AiAnalyticsConstants.smallBorderRadius),
                ),
                child: Icon(
                  Icons.show_chart_rounded,
                  color: _AiAnalyticsConstants.primaryPurple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Past 7 Days',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _AiAnalyticsConstants.textDark,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(_AiAnalyticsConstants.smallBorderRadius),
                ),
                child: const Text(
                  '7.1 avg',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Chart visualization
          SizedBox(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: chartData.map((data) => _buildChartBar(data)).toList(),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Chart legend and insights
          Row(
            children: [
              _buildLegendItem('Excellent', Color(0xFF4CAF50), '8-10'),
              const SizedBox(width: 16),
              _buildLegendItem('Good', Color(0xFF8BC34A), '6-7'),
              const SizedBox(width: 16),
              _buildLegendItem('Low', Color(0xFFFFA726), '3-5'),
              const SizedBox(width: 16),
              _buildLegendItem('Poor', Color(0xFFE57373), '1-2'),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF6A1B9A).withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.trending_up,
                  color: Color(0xFF4CAF50),
                  size: 16,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Your wellbeing has improved 15% this week. Keep up the great work!',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6A1B9A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(WellbeingData data) {
    final double maxHeight = 140;
    final double barHeight = (data.value / 10) * maxHeight;
    final Color barColor = _getColorForValue(data.value);
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          data.value.toString(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: barColor,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 24,
          height: barHeight,
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          data.day,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, String range) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$label ($range)',
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Color _getColorForValue(int value) {
    if (value >= 8) return const Color(0xFF4CAF50); // Green
    if (value >= 6) return const Color(0xFF8BC34A); // Light green
    if (value >= 3) return const Color(0xFFFFA726); // Amber (darker yellow)
    return const Color(0xFFE57373); // Red
  }

  void _showAiInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.psychology_rounded, color: Color(0xFF6A1B9A)),
            SizedBox(width: 8),
            Text('About AI Companion'),
          ],
        ),
        content: const Text(
          'Your AI Companion uses advanced natural language processing to provide personalized support and insights. All conversations are processed locally on your device and never shared externally. The AI learns from your interactions to provide better, more relevant support over time.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Understood'),
          ),
        ],
      ),
    );
  }
}

class WellbeingData {
  final String day;
  final int value;

  WellbeingData(this.day, this.value);
}
