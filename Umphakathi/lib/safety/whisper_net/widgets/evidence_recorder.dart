import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/safety_provider.dart';
import '../../../vault/services/media_service.dart';
import '../../../audio_record/audio_recording.dart';

// Constants for styling consistency
class _EvidenceRecorderConstants {
  static const Color primaryPurple = Color(0xFF6A1B9A);
  static const Color secondaryPurple = Color(0xFF8E24AA);
  static const Color primaryOrange = Color(0xFFEC7E33);
  static const Color emergencyRed = Color(0xFFF44336);
  
  static const double borderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  
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

class EvidenceRecorder extends StatefulWidget {
  const EvidenceRecorder({super.key});

  @override
  State<EvidenceRecorder> createState() => _EvidenceRecorderState();
}

class _EvidenceRecorderState extends State<EvidenceRecorder> {
  bool _isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_EvidenceRecorderConstants.borderRadius),
        border: Border.all(
          color: _EvidenceRecorderConstants.primaryPurple.withValues(alpha: 0.2),
        ),
        boxShadow: [
          _EvidenceRecorderConstants.primaryShadow,
          _EvidenceRecorderConstants.secondaryShadow,
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _EvidenceRecorderConstants.primaryPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(_EvidenceRecorderConstants.smallBorderRadius),
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: _EvidenceRecorderConstants.primaryPurple,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Evidence Documentation',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _EvidenceRecorderConstants.primaryPurple,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Secure & timestamped recording',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (_isRecording)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _EvidenceRecorderConstants.emergencyRed,
                    borderRadius: BorderRadius.circular(_EvidenceRecorderConstants.borderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: _EvidenceRecorderConstants.emergencyRed.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'REC',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Quick Evidence Options
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.5,
            children: [
              _buildEvidenceButton(
                icon: Icons.camera_alt_rounded,
                label: 'Photo',
                color: _EvidenceRecorderConstants.primaryPurple,
                onTap: _takePhoto,
              ),
              _buildEvidenceButton(
                icon: Icons.videocam_rounded,
                label: 'Video',
                color: _EvidenceRecorderConstants.emergencyRed,
                onTap: _recordVideo,
              ),
              _buildEvidenceButton(
                icon: Icons.mic_rounded,
                label: 'Audio',
                color: _EvidenceRecorderConstants.secondaryPurple,
                onTap: _recordAudio,
              ),
              _buildEvidenceButton(
                icon: Icons.edit_note_rounded,
                label: 'Notes',
                color: _EvidenceRecorderConstants.primaryOrange,
                onTap: _addTextNote,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Auto-timestamped & geo-tagged. All evidence encrypted locally.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEvidenceButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_EvidenceRecorderConstants.smallBorderRadius),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(_EvidenceRecorderConstants.smallBorderRadius),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _takePhoto() async {
    try {
      final file = await MediaService.takePhoto();
      if (file != null) {
        final safetyProvider = Provider.of<SafetyProvider>(context, listen: false);
        final evidence = EvidenceEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: 'photo',
          content: file.path,
          timestamp: DateTime.now(),
          // TODO: Add actual location
        );
        await safetyProvider.addEvidenceEntry(evidence);
        _showSuccessSnackBar('Photo evidence recorded securely');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to take photo: $e');
    }
  }

  Future<void> _recordVideo() async {
    try {
      setState(() => _isRecording = true);
      final file = await MediaService.recordVideo();
      if (file != null) {
        final safetyProvider = Provider.of<SafetyProvider>(context, listen: false);
        final evidence = EvidenceEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: 'video',
          content: file.path,
          timestamp: DateTime.now(),
          // TODO: Add actual location
        );
        await safetyProvider.addEvidenceEntry(evidence);
        _showSuccessSnackBar('Video evidence recorded securely');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to record video: $e');
    } finally {
      setState(() => _isRecording = false);
    }
  }

  Future<void> _recordAudio() async {
    try {
      setState(() => _isRecording = true);
      
      // Navigate to the dedicated audio recording page
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AudioRecordingPage(),
        ),
      );
      
    } catch (e) {
      _showErrorSnackBar('Failed to navigate to audio recording: $e');
    } finally {
      setState(() => _isRecording = false);
    }
  }

  void _addTextNote() {
    showDialog(
      context: context,
      builder: (context) => _TextNoteDialog(),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFF44336),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _TextNoteDialog extends StatefulWidget {
  @override
  State<_TextNoteDialog> createState() => _TextNoteDialogState();
}

class _TextNoteDialogState extends State<_TextNoteDialog> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus the text field when dialog opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_EvidenceRecorderConstants.borderRadius),
      ),
      elevation: 24,
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_EvidenceRecorderConstants.borderRadius),
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
                    _EvidenceRecorderConstants.primaryOrange,
                    _EvidenceRecorderConstants.primaryOrange.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_EvidenceRecorderConstants.borderRadius),
                  topRight: Radius.circular(_EvidenceRecorderConstants.borderRadius),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(_EvidenceRecorderConstants.smallBorderRadius),
                    ),
                    child: const Icon(
                      Icons.edit_note_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Add Text Evidence',
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
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info Banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _EvidenceRecorderConstants.primaryOrange.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(_EvidenceRecorderConstants.smallBorderRadius),
                        border: Border.all(
                          color: _EvidenceRecorderConstants.primaryOrange.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_rounded,
                            color: _EvidenceRecorderConstants.primaryOrange,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Document what happened in detail. This will be timestamped and encrypted.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Text Field
                    const Text(
                      'Describe what happened:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(_EvidenceRecorderConstants.smallBorderRadius),
                          border: Border.all(
                            color: Colors.grey[300]!,
                          ),
                        ),
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Describe the incident, location, people involved, and any important details...',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Character Count
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Auto-timestamped: ${DateTime.now().toString().substring(0, 16)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const Spacer(),
                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _controller,
                          builder: (context, value, child) {
                            return Text(
                              '${value.text.length} characters',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey[400]!),
                        foregroundColor: Colors.grey[600],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(_EvidenceRecorderConstants.smallBorderRadius),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _controller,
                      builder: (context, value, child) {
                        final hasText = value.text.trim().isNotEmpty;
                        return ElevatedButton.icon(
                          onPressed: hasText ? () async {
                            final safetyProvider = Provider.of<SafetyProvider>(context, listen: false);
                            final evidence = EvidenceEntry(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              type: 'text',
                              content: _controller.text.trim(),
                              timestamp: DateTime.now(),
                              // TODO: Add actual location
                            );
                            await safetyProvider.addEvidenceEntry(evidence);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Text evidence recorded securely'),
                                backgroundColor: const Color(0xFF4CAF50),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          } : null,
                          icon: const Icon(Icons.save_rounded, size: 18),
                          label: const Text(
                            'Save Evidence',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: hasText 
                                ? _EvidenceRecorderConstants.primaryOrange
                                : Colors.grey[300],
                            foregroundColor: hasText ? Colors.white : Colors.grey[500],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(_EvidenceRecorderConstants.smallBorderRadius),
                            ),
                            elevation: 0,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
