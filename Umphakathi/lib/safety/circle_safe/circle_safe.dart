import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Constants for styling consistency
class _SafeCircleConstants {
  static const Color primaryPurple = Color(0xFF6A1B9A);
  static const Color secondaryPurple = Color(0xFF8E24AA);
  static const Color primaryOrange = Color(0xFFEC7E33);
  static const Color textDark = Color(0xFF212121);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color errorRed = Color(0xFFF44336);
  
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
}

class CircleSafePage extends StatefulWidget {
  const CircleSafePage({super.key});

  @override
  State<CircleSafePage> createState() => _CircleSafePageState();
}

class _CircleSafePageState extends State<CircleSafePage> {
  // Fake data for production preview
  final List<Map<String, dynamic>> _fakeCircleMembers = [
    {
      'name': 'Sarah Johnson',
      'relationship': 'Sister',
      'phone': '+27 82 123 4567',
      'isOnline': true,
      'lastSeen': 'Active now',
      'avatar': 'S',
      'color': _SafeCircleConstants.primaryPurple,
    },
    {
      'name': 'Michael Chen',
      'relationship': 'Best Friend',
      'phone': '+27 71 987 6543',
      'isOnline': false,
      'lastSeen': '2 hours ago',
      'avatar': 'M',
      'color': _SafeCircleConstants.secondaryPurple,
    },
    {
      'name': 'Dr. Amanda Smith',
      'relationship': 'Family Doctor',
      'phone': '+27 11 456 7890',
      'isOnline': true,
      'lastSeen': 'Active now',
      'avatar': 'A',
      'color': _SafeCircleConstants.successGreen,
    },
    {
      'name': 'David Thompson',
      'relationship': 'Neighbor',
      'phone': '+27 84 555 1234',
      'isOnline': false,
      'lastSeen': '30 min ago',
      'avatar': 'D',
      'color': _SafeCircleConstants.primaryOrange,
    },
  ];

  final List<Map<String, dynamic>> _fakeSafeZones = [
    {
      'name': 'Home',
      'address': '123 Oak Street, Sandton',
      'radius': '50m',
      'isActive': true,
      'icon': Icons.home,
    },
    {
      'name': 'Work Office',
      'address': 'Sandton City Tower, Johannesburg',
      'radius': '100m',
      'isActive': true,
      'icon': Icons.business,
    },
    {
      'name': 'University Campus',
      'address': 'University of Witwatersrand',
      'radius': '200m',
      'isActive': false,
      'icon': Icons.school,
    },
  ];

  final List<String> _fakeTriggerWords = [
    'help me',
    'emergency',
    'call police',
    'I need help',
    'danger',
  ];

  // Panic button state
  bool _isPanicPressed = false;
  int _holdDuration = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: _SafeCircleConstants.standardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildSectionHeader('Circle Members', Icons.people),
                  SizedBox(height: _SafeCircleConstants.cardSpacing),
                  _buildCircleMembersSection(),
                  
                  SizedBox(height: _SafeCircleConstants.sectionSpacing),
                  
                  _buildSectionHeader('Safe Zones', Icons.location_on),
                  SizedBox(height: _SafeCircleConstants.cardSpacing),
                  _buildSafeZonesSection(),
                  
                  SizedBox(height: _SafeCircleConstants.sectionSpacing),
                  
                  _buildSectionHeader('Trigger Words', Icons.record_voice_over),
                  SizedBox(height: _SafeCircleConstants.cardSpacing),
                  _buildTriggerWordsSection(),
                  
                  const SizedBox(height: 100), // Space for floating button
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildPanicButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'SafeCircle',
        style: GoogleFonts.dancingScript(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: Colors.white,
        ),
      ),
      backgroundColor: _SafeCircleConstants.primaryPurple,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () => _showCircleInfo(context),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: _SafeCircleConstants.primaryOrange,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(title, style: _SafeCircleConstants.sectionTitleStyle),
        const SizedBox(width: 12),
        Icon(icon, color: _SafeCircleConstants.primaryOrange, size: 20),
      ],
    );
  }

  Widget _buildCircleMembersSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_SafeCircleConstants.borderRadius),
        boxShadow: [_SafeCircleConstants.primaryShadow],
      ),
      child: Column(
        children: [
          Padding(
            padding: _SafeCircleConstants.cardInternalPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Trusted People',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _SafeCircleConstants.textDark,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddMemberDialog(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _SafeCircleConstants.primaryPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_SafeCircleConstants.smallBorderRadius),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...(_fakeCircleMembers.asMap().entries.map((entry) {
            final index = entry.key;
            final member = entry.value;
            return _buildMemberCard(member, index < _fakeCircleMembers.length - 1);
          }).toList()),
        ],
      ),
    );
  }

  Widget _buildMemberCard(Map<String, dynamic> member, bool showDivider) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: member['color'],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    member['avatar'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          member['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (member['isOnline']) ...[
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: _SafeCircleConstants.successGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      member['relationship'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      member['lastSeen'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.more_vert,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: Colors.grey[200],
            indent: 84,
          ),
      ],
    );
  }

  Widget _buildSafeZonesSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_SafeCircleConstants.borderRadius),
        boxShadow: [_SafeCircleConstants.primaryShadow],
      ),
      child: Column(
        children: [
          Padding(
            padding: _SafeCircleConstants.cardInternalPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Safe Locations',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _SafeCircleConstants.textDark,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddZoneDialog(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _SafeCircleConstants.primaryPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_SafeCircleConstants.smallBorderRadius),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...(_fakeSafeZones.asMap().entries.map((entry) {
            final index = entry.key;
            final zone = entry.value;
            return _buildZoneCard(zone, index < _fakeSafeZones.length - 1);
          }).toList()),
        ],
      ),
    );
  }

  Widget _buildZoneCard(Map<String, dynamic> zone, bool showDivider) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: zone['isActive'] 
                      ? _SafeCircleConstants.primaryPurple.withValues(alpha: 0.1)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(_SafeCircleConstants.smallBorderRadius),
                ),
                child: Icon(
                  zone['icon'],
                  color: zone['isActive'] 
                      ? _SafeCircleConstants.primaryPurple
                      : Colors.grey[400],
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          zone['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: zone['isActive'] 
                                ? _SafeCircleConstants.successGreen.withValues(alpha: 0.1)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            zone['isActive'] ? 'Active' : 'Inactive',
                            style: TextStyle(
                              fontSize: 12,
                              color: zone['isActive'] 
                                  ? _SafeCircleConstants.successGreen
                                  : Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      zone['address'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      'Radius: ${zone['radius']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: zone['isActive'],
                onChanged: (value) => _toggleZone(zone),
                activeColor: _SafeCircleConstants.primaryPurple,
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: Colors.grey[200],
            indent: 84,
          ),
      ],
    );
  }

  Widget _buildTriggerWordsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_SafeCircleConstants.borderRadius),
        boxShadow: [_SafeCircleConstants.primaryShadow],
      ),
      child: Column(
        children: [
          Padding(
            padding: _SafeCircleConstants.cardInternalPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Voice Triggers',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _SafeCircleConstants.textDark,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddTriggerDialog(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _SafeCircleConstants.primaryPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_SafeCircleConstants.smallBorderRadius),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _fakeTriggerWords.map((word) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _SafeCircleConstants.primaryOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _SafeCircleConstants.primaryOrange.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '"$word"',
                      style: TextStyle(
                        color: _SafeCircleConstants.primaryOrange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.close,
                      size: 16,
                      color: _SafeCircleConstants.primaryOrange,
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanicButton() {
    return SizedBox(
      width: 80,
      height: 80,
      child: GestureDetector(
        onTapDown: (_) => _startPanicHold(),
        onTapUp: (_) => _cancelPanicHold(),
        onTapCancel: () => _cancelPanicHold(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: _isPanicPressed 
                ? _SafeCircleConstants.errorRed.withValues(alpha: 0.8)
                : _SafeCircleConstants.errorRed,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _SafeCircleConstants.errorRed.withValues(alpha: 0.4),
                blurRadius: _isPanicPressed ? 20 : 8,
                spreadRadius: _isPanicPressed ? 4 : 2,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Progress ring
              if (_isPanicPressed)
                SizedBox(
                  width: 70,
                  height: 70,
                  child: CircularProgressIndicator(
                    value: _holdDuration / 3.0,
                    strokeWidth: 3,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
              
              // Icon
              Icon(
                Icons.warning,
                color: Colors.white,
                size: _isPanicPressed ? 28 : 32,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Panic button hold logic
  void _startPanicHold() {
    setState(() {
      _isPanicPressed = true;
      _holdDuration = 0;
    });
    
    _incrementHoldDuration();
  }

  void _incrementHoldDuration() {
    if (_isPanicPressed && _holdDuration < 3) {
      Future.delayed(const Duration(seconds: 1), () {
        if (_isPanicPressed) {
          setState(() {
            _holdDuration++;
          });
          
          if (_holdDuration >= 3) {
            _triggerPanic();
          } else {
            _incrementHoldDuration();
          }
        }
      });
    }
  }

  void _cancelPanicHold() {
    setState(() {
      _isPanicPressed = false;
      _holdDuration = 0;
    });
  }

  // Dialog and action methods
  void _showAddMemberDialog() {
    _showComingSoon('Add Member');
  }

  void _showAddZoneDialog() {
    _showComingSoon('Add Safe Zone');
  }

  void _showAddTriggerDialog() {
    _showComingSoon('Add Trigger Word');
  }

  void _toggleZone(Map<String, dynamic> zone) {
    setState(() {
      zone['isActive'] = !zone['isActive'];
    });
  }

  void _triggerPanic() {
    setState(() {
      _isPanicPressed = false;
      _holdDuration = 0;
    });
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_SafeCircleConstants.borderRadius),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning,
              color: _SafeCircleConstants.errorRed,
            ),
            const SizedBox(width: 8),
            const Text('Panic Alert Triggered!'),
          ],
        ),
        content: const Text(
          'Emergency alert sent to your SafeCircle!\n\n'
          'Your location and emergency status have been shared with all trusted contacts.\n\n'
          'Emergency services have been notified.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: _SafeCircleConstants.errorRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon!'),
        backgroundColor: _SafeCircleConstants.primaryPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_SafeCircleConstants.smallBorderRadius),
        ),
      ),
    );
  }

  void _showCircleInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_SafeCircleConstants.borderRadius),
        ),
        title: Row(
          children: [
            Icon(
              Icons.people,
              color: _SafeCircleConstants.primaryPurple,
            ),
            const SizedBox(width: 8),
            const Text('SafeCircle'),
          ],
        ),
        content: const Text(
          'SafeCircle connects you with trusted people who care about your safety.\n\n'
          '• Circle Members get alerts when you\'re in danger\n'
          '• Safe Zones trigger automatic notifications\n'
          '• Trigger Words activate silent recording\n'
          '• Panic Button sends immediate help alerts\n\n'
          'Your location and alerts are only shared with your trusted circle.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: _SafeCircleConstants.primaryPurple,
            ),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
