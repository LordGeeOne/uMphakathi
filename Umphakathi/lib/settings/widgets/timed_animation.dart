import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class TimedAnimation extends StatefulWidget {
  final bool isActive;
  final VoidCallback? onTimerComplete;

  const TimedAnimation({
    super.key,
    required this.isActive,
    this.onTimerComplete,
  });

  @override
  State<TimedAnimation> createState() => _TimedAnimationState();
}

class _TimedAnimationState extends State<TimedAnimation> with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _gradientAnimation;
  final List<_AnimatedCircle> circles = [];
  bool isAnimating = false;
  
  // Cache theme colors to avoid context issues during animation
  Color? _cachedPrimaryColor;
  Color? _cachedAccentColor;
  
  // Get colors from theme provider with caching
  Color _getPrimaryColor(BuildContext context) {
    _cachedPrimaryColor ??= Provider.of<ThemeProvider>(context, listen: false)
        .currentCustomTheme?.colorCategories['Primary Colors']?['Primary Color'] 
        ?? const Color(0xFF764ba2);
    return _cachedPrimaryColor!;
  }
  
  Color _getAccentColor(BuildContext context) {
    _cachedAccentColor ??= Provider.of<ThemeProvider>(context, listen: false)
        .currentCustomTheme?.colorCategories['Primary Colors']?['Accent Color'] 
        ?? const Color(0xFF667eea);
    return _cachedAccentColor!;
  }
  
  // Reset the color cache when theme changes
  void _resetColorCache() {
    _cachedPrimaryColor = null;
    _cachedAccentColor = null;
  }

  @override
  void initState() {
    super.initState();
    _resetColorCache();
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    
    _gradientAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(_fadeAnimation);

    // Initialize animation state if widget is active initially
    if (widget.isActive) {
      _startAnimation();
    }
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resetColorCache();
  }

  void _startAnimation() {
    if (isAnimating) return;
    
    setState(() {
      isAnimating = true;
      circles.clear();
    });
    
    _fadeController.forward();
    _spawnCircle();
  }

  void _stopAnimation() {
    if (!isAnimating) return;
    
    setState(() {
      isAnimating = false;
      circles.clear();
    });
    
    _fadeController.reverse();
    
    // Clean up any active circle controllers
    for (var circle in circles) {
      circle.controller.dispose();
    }
  }

  void _spawnCircle() {
    if (!isAnimating) return;

    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    _AnimatedCircle? circleRef;
    final circle = _AnimatedCircle(
      controller: controller,
      onComplete: () {
        if (!mounted) return;
        setState(() {
          if (circleRef != null && circles.remove(circleRef)) {
            controller.dispose();
          }
        });
      },
    );
    circleRef = circle;

    if (mounted && isAnimating) {
      setState(() {
        circles.add(circle);
      });
      
      controller.forward();

      // Schedule next circle if still animating
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted && isAnimating) {
          _spawnCircle();
        }
      });
    } else {
      controller.dispose();
    }
  }

  @override
  void didUpdateWidget(TimedAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _startAnimation();
      } else {
        _stopAnimation();
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    // Clean up all circle controllers
    for (var circle in circles) {
      circle.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _gradientAnimation,
      builder: (context, child) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _getAccentColor(context).withOpacity(_gradientAnimation.value),
              _getPrimaryColor(context).withOpacity(_gradientAnimation.value),
            ],
          ),
        ),
        child: widget.isActive ? CustomPaint(
          painter: _CirclesPainter(circles: circles),
          child: const SizedBox.expand(),
        ) : null,
      ),
    );
  }
}

class _AnimatedCircle {
  final AnimationController controller;
  final Animation<double> animation;

  _AnimatedCircle({
    required this.controller,
    required VoidCallback onComplete,
  }) : animation = Tween<double>(
          begin: 0.7,
          end: 0.0,
        ).animate(CurvedAnimation(
          parent: controller,
          curve: Curves.easeIn,
        )) {
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        onComplete();
      }
    });
  }
}

class _CirclesPainter extends CustomPainter {
  final List<_AnimatedCircle> circles;

  _CirclesPainter({required this.circles}) : super(repaint: Listenable.merge(
    circles.map((circle) => circle.animation).toList()
  ));

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = const Color(0xFF9f85c0)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width < size.height ? size.width : size.height;

    for (var circle in circles) {
      // Shrinking animation - start large and get smaller
      final radius = maxRadius * circle.animation.value;
      paint.color = const Color(0xFF9f85c0).withOpacity(circle.animation.value);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_CirclesPainter oldDelegate) => true;
}

