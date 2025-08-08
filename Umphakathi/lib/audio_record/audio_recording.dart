import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../safety/providers/safety_provider.dart';

class AudioRecordingPage extends StatefulWidget {
  const AudioRecordingPage({super.key});

  @override
  State<AudioRecordingPage> createState() => _AudioRecordingPageState();
}

class _AudioRecordingPageState extends State<AudioRecordingPage>
    with TickerProviderStateMixin {
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  bool _isInitialized = false;
  String? _currentFilePath;
  Duration _recordingDuration = Duration.zero;
  Timer? _timer;
  
  // Animation controllers for visual effects
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;

  // Constants for styling
  static const Color primaryPurple = Color(0xFF6A1B9A);
  static const Color secondaryPurple = Color(0xFF8E24AA);
  static const Color primaryOrange = Color(0xFFEC7E33);
  static const Color recordingRed = Color(0xFFF44336);
  static const Color successGreen = Color(0xFF4CAF50);

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    _setupAnimations();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _initializeRecorder() async {
    try {
      _recorder = FlutterSoundRecorder();
      
      // Request microphone permission
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw Exception('Microphone permission denied');
      }

      await _recorder!.openRecorder();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      _showErrorSnackBar('Failed to initialize recorder: $e');
    }
  }

  Future<void> _startRecording() async {
    if (!_isInitialized || _recorder == null) return;

    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'audio_${DateTime.now().millisecondsSinceEpoch}.aac';
      _currentFilePath = '${directory.path}/$fileName';

      await _recorder!.startRecorder(
        toFile: _currentFilePath,
        codec: Codec.aacADTS,
      );

      setState(() {
        _isRecording = true;
        _recordingDuration = Duration.zero;
      });

      // Start animations
      _pulseController.repeat(reverse: true);
      _waveController.repeat();

      // Start timer for duration
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _recordingDuration = Duration(seconds: timer.tick);
        });
      });

    } catch (e) {
      _showErrorSnackBar('Failed to start recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording || _recorder == null) return;

    try {
      await _recorder!.stopRecorder();
      
      setState(() {
        _isRecording = false;
      });

      // Stop animations
      _pulseController.stop();
      _waveController.stop();
      _timer?.cancel();

      if (_currentFilePath != null) {
        await _saveRecording();
      }

    } catch (e) {
      _showErrorSnackBar('Failed to stop recording: $e');
    }
  }

  Future<void> _saveRecording() async {
    if (_currentFilePath == null) return;

    try {
      final safetyProvider = Provider.of<SafetyProvider>(context, listen: false);
      final evidence = EvidenceEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'audio',
        content: _currentFilePath!,
        timestamp: DateTime.now(),
        // TODO: Add actual location if available
      );

      await safetyProvider.addEvidenceEntry(evidence);
      
      _showSuccessSnackBar('Audio evidence recorded securely');
      Navigator.pop(context);
      
    } catch (e) {
      _showErrorSnackBar('Failed to save recording: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: recordingRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds % 60);
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Audio Recording',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryPurple, secondaryPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          if (_isRecording)
            IconButton(
              icon: const Icon(Icons.stop_rounded),
              onPressed: _stopRecording,
              tooltip: 'Stop Recording',
            ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF8F9FA),
              Color(0xFFE9ECEF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Status Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _isRecording 
                              ? recordingRed.withValues(alpha: 0.1)
                              : primaryOrange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _isRecording ? Icons.fiber_manual_record : Icons.mic_rounded,
                          color: _isRecording ? recordingRed : primaryOrange,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isRecording ? 'Recording in Progress' : 'Ready to Record',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _isRecording ? recordingRed : primaryPurple,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isRecording 
                                  ? 'Audio evidence is being captured'
                                  : 'Tap the microphone to start recording',
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

                const SizedBox(height: 40),

                // Recording Visualization
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Timer Display
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            _formatDuration(_recordingDuration),
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: _isRecording ? recordingRed : Colors.grey[400],
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
                          ),
                        ),

                        const SizedBox(height: 60),

                        // Main Recording Button with Animation
                        AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _isRecording ? _pulseAnimation.value : 1.0,
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _isRecording ? recordingRed : primaryOrange,
                                  boxShadow: [
                                    BoxShadow(
                                      color: (_isRecording ? recordingRed : primaryOrange)
                                          .withValues(alpha: 0.3),
                                      blurRadius: 24,
                                      spreadRadius: _isRecording ? 8 : 4,
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(100),
                                    onTap: _isInitialized
                                        ? (_isRecording ? _stopRecording : _startRecording)
                                        : null,
                                    child: Center(
                                      child: Icon(
                                        _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                                        size: 80,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 40),

                        // Recording Waves Animation
                        if (_isRecording)
                          AnimatedBuilder(
                            animation: _waveAnimation,
                            builder: (context, child) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  final delay = index * 0.2;
                                  final animationValue = (_waveAnimation.value + delay) % 1.0;
                                  return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    width: 4,
                                    height: 40 * (0.5 + 0.5 * animationValue),
                                    decoration: BoxDecoration(
                                      color: recordingRed.withValues(alpha: 0.6),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  );
                                }),
                              );
                            },
                          ),

                        const SizedBox(height: 40),

                        // Instructions
                        Text(
                          _isRecording 
                              ? 'Tap the stop button when finished'
                              : 'Tap the microphone to start recording',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Action Buttons
                if (!_isRecording) ...[
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close_rounded),
                          label: const Text('Cancel'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey[600],
                            side: BorderSide(color: Colors.grey[400]!),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _waveController.dispose();
    _recorder?.closeRecorder();
    super.dispose();
  }
}
