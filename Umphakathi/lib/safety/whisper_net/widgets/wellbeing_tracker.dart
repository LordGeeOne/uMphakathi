import 'package:flutter/material.dart';

class WellbeingTracker extends StatefulWidget {
  const WellbeingTracker({super.key});

  @override
  State<WellbeingTracker> createState() => _WellbeingTrackerState();
}

class _WellbeingTrackerState extends State<WellbeingTracker> {
  final List<WellbeingEntry> _entries = [
    WellbeingEntry(
      date: DateTime.now().subtract(const Duration(days: 2)),
      mood: 7,
      note: "Feeling positive after a good conversation with AI companion",
    ),
    WellbeingEntry(
      date: DateTime.now().subtract(const Duration(days: 1)),
      mood: 5,
      note: "Discussed anxiety with AI - helpful coping strategies",
    ),
    WellbeingEntry(
      date: DateTime.now(),
      mood: 8,
      note: "Much better today - grateful for the support",
    ),
  ];

  double _currentMoodSliderValue = 5.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF004D40).withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.favorite_rounded,
                color: Color(0xFF004D40),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Wellbeing Insights',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF004D40),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _showFullHistory,
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Mood trend
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Trend',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.trending_up,
                          color: Color(0xFF4CAF50),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Improving',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Average Mood',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '6.7/10',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004D40),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Recent entries
          Text(
            'Recent Check-ins',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          
          ...(_entries.take(2).map((entry) => _buildEntryItem(entry)).toList()),
          
          const SizedBox(height: 12),
          
          // Quick mood check-in
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF004D40).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                Text(
                  'How are you feeling right now?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF004D40),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Mood level indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _getMoodLabel(_currentMoodSliderValue.round()),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _getMoodColor(_currentMoodSliderValue.round()),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getMoodColor(_currentMoodSliderValue.round()).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_currentMoodSliderValue.round()}/10',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _getMoodColor(_currentMoodSliderValue.round()),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Slider
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: const Color(0xFF004D40),
                    inactiveTrackColor: const Color(0xFF004D40).withValues(alpha: 0.2),
                    thumbColor: const Color(0xFF004D40),
                    overlayColor: const Color(0xFF004D40).withValues(alpha: 0.1),
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                  ),
                  child: Slider(
                    value: _currentMoodSliderValue,
                    min: 1.0,
                    max: 10.0,
                    divisions: 9,
                    label: '${_currentMoodSliderValue.round()}',
                    onChanged: (value) {
                      setState(() {
                        _currentMoodSliderValue = value;
                      });
                    },
                  ),
                ),
                
                // Scale labels
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '1 - Very Low',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '10 - Excellent',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Record button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _recordMood(_currentMoodSliderValue.round()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004D40),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Record Mood',
                      style: TextStyle(
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
    );
  }

  Widget _buildEntryItem(WellbeingEntry entry) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _getMoodColor(entry.mood).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                entry.mood.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _getMoodColor(entry.mood),
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
                  _formatDate(entry.date),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  entry.note,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMoodLabel(int mood) {
    if (mood <= 2) return 'Very Low';
    if (mood <= 4) return 'Low';
    if (mood <= 6) return 'Okay';
    if (mood <= 8) return 'Good';
    return 'Excellent';
  }

  Color _getMoodColor(int mood) {
    if (mood <= 2) return const Color(0xFFE57373); // Red - Very Low
    if (mood <= 4) return const Color(0xFFFF9800); // Orange - Low
    if (mood <= 6) return const Color(0xFFFFA726); // Amber - Okay (darker yellow)
    if (mood <= 8) return const Color(0xFF8BC34A); // Light Green - Good
    return const Color(0xFF4CAF50); // Green - Excellent
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    return '$difference days ago';
  }

  void _recordMood(int mood) {
    setState(() {
      _entries.add(WellbeingEntry(
        date: DateTime.now(),
        mood: mood,
        note: "Quick check-in",
      ));
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mood recorded! Consider chatting with your AI companion.'),
        backgroundColor: const Color(0xFF004D40),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }

  void _showFullHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Full wellbeing history coming soon!'),
        backgroundColor: Color(0xFF004D40),
      ),
    );
  }
}

class WellbeingEntry {
  final DateTime date;
  final int mood; // 1-10 scale
  final String note;

  WellbeingEntry({
    required this.date,
    required this.mood,
    required this.note,
  });
}
