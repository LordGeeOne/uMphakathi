import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/safety_provider.dart';

class PanicButton extends StatefulWidget {
  const PanicButton({super.key});

  @override
  State<PanicButton> createState() => _PanicButtonState();
}

class _PanicButtonState extends State<PanicButton>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _pressController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _pressAnimation;
  
  bool _isPressed = false;
  bool _isEmergencyActive = false;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _pressAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeInOut,
    ));
    
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SafetyProvider>(
      builder: (context, safetyProvider, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer pulse ring
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF004D40).withOpacity(0.3),
                    ),
                  ),
                );
              },
            ),
            
            // Main panic button
            AnimatedBuilder(
              animation: _pressAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pressAnimation.value,
                  child: GestureDetector(
                    onTapDown: (_) => _onPressStart(),
                    onTapUp: (_) => _onPressEnd(),
                    onTapCancel: () => _onPressEnd(),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isEmergencyActive 
                            ? const Color(0xFF004D40) 
                            : const Color(0xFF004D40),
                        boxShadow: [
                          BoxShadow(
                            color: (_isEmergencyActive 
                                ? const Color(0xFF004D40) 
                                : const Color(0xFF004D40)).withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        _isEmergencyActive ? Icons.check : Icons.warning,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                );
              },
            ),
            
            // Emergency text
            if (_isEmergencyActive)
              Positioned(
                bottom: -40,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'HELP SENT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _onPressStart() {
    setState(() => _isPressed = true);
    _pressController.forward();
    HapticFeedback.heavyImpact();
    
    // Show hold instruction
    if (!_isEmergencyActive) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hold for 3 seconds to send emergency alert'),
          duration: Duration(seconds: 2),
          backgroundColor: Color(0xFFF44336),
        ),
      );
      
      // Start emergency countdown
      Future.delayed(const Duration(seconds: 3), () {
        if (_isPressed) {
          _activateEmergency();
        }
      });
    }
  }

  void _onPressEnd() {
    setState(() => _isPressed = false);
    _pressController.reverse();
    
    if (_isEmergencyActive) {
      _deactivateEmergency();
    }
  }

  void _activateEmergency() {
    if (!_isEmergencyActive) {
      setState(() => _isEmergencyActive = true);
      HapticFeedback.heavyImpact();
      
      // Show emergency activation dialog
      _showEmergencyDialog();
      
      // TODO: Implement actual emergency actions
      // - Send location to circle members
      // - Start emergency recording
      // - Notify authorities if configured
      // - Activate dead man's switch
    }
  }

  void _deactivateEmergency() {
    setState(() => _isEmergencyActive = false);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Emergency alert cancelled'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF44336),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.white, size: 32),
            SizedBox(width: 12),
            Text(
              'EMERGENCY ACTIVE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Emergency protocol activated:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text('Location sent to circle', 
                     style: TextStyle(color: Colors.white)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.videocam, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text('Recording started', 
                     style: TextStyle(color: Colors.white)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.people, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text('Circle members notified', 
                     style: TextStyle(color: Colors.white)),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Stay safe. Help is on the way.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deactivateEmergency();
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              foregroundColor: Colors.white,
            ),
            child: const Text('CANCEL ALERT'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Keep emergency active but close dialog
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFF44336),
            ),
            child: const Text('KEEP ACTIVE'),
          ),
        ],
      ),
    );
  }
}
