import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/screen_lock_provider.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../services/global_safewalk_monitor.dart';

/// A simplified full screen overlay that simulates a locked screen.
/// This widget is now stateless and delegates the actual lock screen UI to
/// [_LockScreenContent], which is more efficient and simplifies state management.
class ScreenLockOverlay extends StatelessWidget {
  const ScreenLockOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScreenLockProvider>(
      builder: (context, lockProvider, _) {
        if (!lockProvider.isLocked) {
          return const SizedBox.shrink();
        }
        
        // Using a ValueKey ensures that a new [_LockScreenContent] state is
        // created each time the lock screen is shown, automatically resetting
        // the slider and other state variables.
        return const _LockScreenContent(key: ValueKey('lock_screen'));
      },
    );
  }
}

/// The stateful widget that contains the UI and logic for the lock screen.
class _LockScreenContent extends StatefulWidget {
  const _LockScreenContent({super.key});

  @override
  State<_LockScreenContent> createState() => _LockScreenContentState();
}

class _LockScreenContentState extends State<_LockScreenContent> with TickerProviderStateMixin {
  // Controller for the unlock slider
  double _sliderPosition = 0.0;
  late AnimationController _animationController;
  late Animation<double> _unlockAnimation;
  bool _hasTriggeredUnlock = false;
  Timer? _inactivityTimer;
  bool _showUnlockHint = false;
  Timer? _hintTimer;
  
  // Alert animation controllers
  late AnimationController _pulseAnimationController;
  late Animation<double> _pulseAnimation;
  bool _isAlertActive = false;
  StreamSubscription? _safeWalkMonitorSubscription;
  
  // How far the user needs to drag to unlock (100% of screen width)
  final double _unlockThreshold = 1.0; // 100% of the slider width
    @override
  void initState() {
    super.initState();
      // Enable wakelock to keep screen on
    WakelockPlus.enable();
    
    // Set system UI to be hidden for full screen experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    
    // Set system UI options for lock screen
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    
    // Set preferred orientations to portrait only while locked
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    // Setup animation for slider returning to start
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
    
    // Setup pulse animation controller for alerts
    _pulseAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseAnimationController,
      curve: Curves.easeInOut,
    ))..addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    
    // Only start pulse animation when alert is active
    // We'll control this in the stream listener
    
    // Subscribe to SafeWalk monitor to detect alerts
    _safeWalkMonitorSubscription = GlobalSafeWalkMonitor().monitoringStream.listen((data) {
      final bool hasButtonPressed = data['buttonPressed'] != null;
      if (hasButtonPressed != _isAlertActive) {
        setState(() {
          _isAlertActive = hasButtonPressed;
        });
        
        if (_isAlertActive) {
          // Provide strong haptic feedback when alert is activated
          HapticFeedback.heavyImpact();
          // Start the pulse animation
          _pulseAnimationController.repeat(reverse: true);
        } else {
          // Stop the pulse animation when alert is no longer active
          _pulseAnimationController.stop();
          _pulseAnimationController.reset();
        }
      }
    });
    
    // Show hint briefly when screen first appears
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _showHintTemporarily();
      }
    });
  }
    @override
  void dispose() {
    // Stop all animations before disposal
    if (_animationController.isAnimating) {
      _animationController.stop();
    }
    _animationController.dispose();
    
    if (_pulseAnimationController.isAnimating) {
      _pulseAnimationController.stop();
    }
    _pulseAnimationController.dispose();
    
    // Cancel all timers
    _inactivityTimer?.cancel();
    _hintTimer?.cancel();
    
    // Cancel subscriptions
    _safeWalkMonitorSubscription?.cancel();
      // Disable wakelock when lock screen is disposed
    WakelockPlus.disable();
    
    // Restore system UI when lock screen is disposed
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    
    // Reset orientation options when widget is disposed
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    
    super.dispose();
  }

  void _startUnlockAnimation() {
    // Set animation to go from current position back to 0
    _unlockAnimation = Tween<double>(
      begin: _sliderPosition,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _animationController.forward(from: 0.0);
  }
  
  void _resetSliderAfterInactivity() {
    // Cancel any existing timer
    _inactivityTimer?.cancel();
    
    // Create a new timer that will reset the slider after a delay
    _inactivityTimer = Timer(const Duration(seconds: 3), () {
      if (_sliderPosition > 0.0 && !_hasTriggeredUnlock && mounted) {
        _startUnlockAnimation();
      }
    });
  }
  
  void _showHintTemporarily() {
    setState(() {
      _showUnlockHint = true;
    });
    
    _hintTimer?.cancel();
    _hintTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showUnlockHint = false;
        });
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxSliderDistance = screenWidth * 0.7; // Maximum distance slider can move
    final lockProvider = Provider.of<ScreenLockProvider>(context, listen: false);
    
    // Return a Scaffold that fully blocks the screen
    return WillPopScope(
      // Prevent back button from working when locked
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black, // Pure black background
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
          child: Stack(            children: [
              // Block all interactions with a transparent overlay
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _showHintTemporarily();
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(color: Colors.black),
                ),
              ),
              
              // Dim overlay with alert effect
              Positioned.fill(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  color: _isAlertActive 
                      ? Colors.red.withOpacity(0.1) 
                      : Colors.black.withOpacity(0.3),
                ),
              ),
              
              // Additional pulse overlay for alert
              if (_isAlertActive)
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _pulseAnimationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: 0.1 + (_pulseAnimationController.value * 0.1), // Pulsing opacity
                        child: Container(
                          color: Colors.red,
                        ),
                      );
                    },
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
                // SafeWalk status indicator - positioned for better visibility
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                top: _isAlertActive ? 170 : 200, // Move up slightly when alert is active for emphasis
                left: 0,
                right: 0,
                child: _buildSafeWalkStatus(),
              ),
              
              // Battery status info
              Positioned(
                left: 0,
                right: 0,
                bottom: 70,
                child: _buildBatteryStatus(),
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
              
              // The unlock slider on top of everything else so it remains interactive
              Positioned(
                left: 0,
                right: 0,
                bottom: 100, 
                child: _buildUnlockSlider(maxSliderDistance, lockProvider),
              ),
            ],
          ),
        ),
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
  }  Widget _buildSafeWalkStatus() {
    // Enhanced colors and text based on alert status
    final Color iconColor = _isAlertActive ? Colors.red : Colors.red.withOpacity(0.7);
    final Color circleColor = _isAlertActive ? Colors.red.withOpacity(0.3) : Colors.red.withOpacity(0.1);
    final String statusText = _isAlertActive ? "ALERT TRIGGERED!" : "SafeWalk Protection Active";
    final String subtitleText = _isAlertActive ? "Emergency services contacted" : "Panic buttons active";
    
    // Apply pulse animation to both icon and container when alert is active
    Widget iconContent = Icon(
      _isAlertActive ? Icons.warning_amber_rounded : Icons.shield_outlined,
      color: iconColor,
      size: 40,
    );
    
    // Create animated container for alert visual
    Widget iconContainer = AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: circleColor,
        shape: BoxShape.circle,
        boxShadow: _isAlertActive 
          ? [
              BoxShadow(
                color: Colors.red.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 5,
              )
            ] 
          : null,
      ),
      child: iconContent,
    );
    
    // Apply scale transition if alert is active
    if (_isAlertActive) {
      iconContainer = ScaleTransition(
        scale: _pulseAnimation,
        child: iconContainer,
      );
    }
    
    // Enhanced animated container with pulse effect
    return Column(
      children: [
        iconContainer,
        const SizedBox(height: 12),
        // Status text with enhanced animation
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            color: _isAlertActive ? Colors.red : Colors.red.withOpacity(0.9),
            fontSize: _isAlertActive ? 22 : 16, // Larger text for alert
            fontWeight: FontWeight.w600,
          ),
          child: Text(statusText),
        ),
        const SizedBox(height: 6),
        // Subtitle text
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            color: _isAlertActive ? Colors.white : Colors.white.withOpacity(0.7),
            fontSize: _isAlertActive ? 16 : 14, // Larger text for alert
            fontWeight: _isAlertActive ? FontWeight.w500 : FontWeight.w400,
          ),
          child: Text(subtitleText),
        ),
        // Additional information when alert is active
        if (_isAlertActive)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.red.withOpacity(0.7), width: 1),
              ),
              child: const Text(
                "Help is on the way",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildUnlockSlider(double maxSliderDistance, ScreenLockProvider lockProvider) {
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
                  5, // Number of dots
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
                  color: _sliderPosition / maxSliderDistance >= _unlockThreshold
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
                    // Cancel any reset timer when user starts dragging
                    _inactivityTimer?.cancel();
                    _hintTimer?.cancel();
                    HapticFeedback.selectionClick();
                  },
                  onHorizontalDragUpdate: (details) {
                    // Update position but constrain within bounds
                    double newPosition = _sliderPosition + details.delta.dx;
                    newPosition = newPosition.clamp(0, maxSliderDistance);
                    
                    setState(() {
                      _sliderPosition = newPosition;
                    });
                    
                    // Provide haptic feedback at the halfway point
                    if (_sliderPosition / maxSliderDistance > 0.5 && 
                        _sliderPosition / maxSliderDistance < 0.65 &&
                        details.delta.dx > 0) {
                      HapticFeedback.selectionClick();
                    }
                    
                    // Check if we've passed the unlock threshold
                    if (!_hasTriggeredUnlock && _sliderPosition / maxSliderDistance >= _unlockThreshold) {
                      _hasTriggeredUnlock = true;
                      HapticFeedback.heavyImpact();
                      
                      // Unlock with a slight delay to show the complete animation
                      Future.delayed(const Duration(milliseconds: 200), () {
                        if (mounted) {
                          lockProvider.unlockScreen();
                        }
                      });
                    }
                  },
                  onHorizontalDragEnd: (_) {
                    if (!_hasTriggeredUnlock) {
                      _startUnlockAnimation();
                      HapticFeedback.lightImpact();
                      
                      // Set a timer to ensure the slider resets if user doesn't interact with it
                      _resetSliderAfterInactivity();
                      
                      // Hide hint after drag ends
                      _hintTimer?.cancel();
                      _hintTimer = Timer(const Duration(milliseconds: 500), () {
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
                      color: _sliderPosition / maxSliderDistance >= _unlockThreshold 
                          ? Colors.red 
                          : Colors.redAccent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (_sliderPosition / maxSliderDistance >= _unlockThreshold 
                              ? Colors.red 
                              : Colors.redAccent).withOpacity(0.6),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      _sliderPosition / maxSliderDistance >= _unlockThreshold 
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
  
  Widget _buildBatteryStatus() {
    // Simple battery status display with current time
    final now = DateTime.now();
    final timeString = '${_formatTwoDigits(now.hour)}:${_formatTwoDigits(now.minute)}';
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Battery icon
        Icon(
          Icons.battery_full,
          color: Colors.red,
          size: 16,
        ),
        const SizedBox(width: 8),
        // Battery percentage
        Text(
          '82%', // Placeholder for actual battery level
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 16),
        // Time icon
        Icon(
          Icons.access_time,
          color: Colors.white.withOpacity(0.7),
          size: 16,
        ),
        const SizedBox(width: 8),
        // Current time
        Text(
          timeString,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
  
  String _formatTwoDigits(int number) {
    return number.toString().padLeft(2, '0');
  }
}
