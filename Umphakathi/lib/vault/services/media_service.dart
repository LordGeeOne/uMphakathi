import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class MediaService {
  static final ImagePicker _picker = ImagePicker();
  static final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();

  // Check and request permissions
  static Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) {
      return true;
    }
    
    final result = await permission.request();
    return result.isGranted;
  }

  // Take photo from camera
  static Future<File?> takePhoto() async {
    try {
      // Request camera permission
      final hasPermission = await _requestPermission(Permission.camera);
      if (!hasPermission) {
        throw Exception('Camera permission denied');
      }

      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (photo != null) {
        return File(photo.path);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to take photo: $e');
    }
  }

  // Record video from camera
  static Future<File?> recordVideo() async {
    try {
      // Request camera and microphone permissions
      final cameraPermission = await _requestPermission(Permission.camera);
      final micPermission = await _requestPermission(Permission.microphone);
      
      if (!cameraPermission || !micPermission) {
        throw Exception('Camera or microphone permission denied');
      }

      final XFile? video = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(minutes: 5),
      );

      if (video != null) {
        return File(video.path);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to record video: $e');
    }
  }

  // Record audio - Now with flutter_sound implementation
  static Future<File?> recordAudio(BuildContext context) async {
    try {
      // Request microphone permission
      final hasPermission = await _requestPermission(Permission.microphone);
      if (!hasPermission) {
        throw Exception('Microphone permission denied');
      }

      // Initialize the recorder
      await _audioRecorder.openRecorder();

      // Get app documents directory
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'audio_${DateTime.now().millisecondsSinceEpoch}.aac';
      final filePath = '${directory.path}/$fileName';

      // Show recording dialog
      bool isRecording = false;
      File? recordedFile;

      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8E24AA).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.mic_rounded,
                        color: Color(0xFF8E24AA),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Audio Recording',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isRecording 
                            ? const Color(0xFFF44336).withValues(alpha: 0.1)
                            : const Color(0xFF8E24AA).withValues(alpha: 0.1),
                        border: Border.all(
                          color: isRecording 
                              ? const Color(0xFFF44336) 
                              : const Color(0xFF8E24AA),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                        size: 32,
                        color: isRecording 
                            ? const Color(0xFFF44336) 
                            : const Color(0xFF8E24AA),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isRecording 
                          ? 'Recording in progress...\nTap stop when finished'
                          : 'Ready to record audio evidence.\nTap the microphone to start.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    if (isRecording) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF44336),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'REC',
                            style: TextStyle(
                              color: Color(0xFFF44336),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      if (isRecording) {
                        await _audioRecorder.stopRecorder();
                      }
                      await _audioRecorder.closeRecorder();
                      Navigator.of(dialogContext).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (!isRecording) {
                        // Start recording
                        await _audioRecorder.startRecorder(
                          toFile: filePath,
                          codec: Codec.aacADTS,
                        );
                        setState(() {
                          isRecording = true;
                        });
                      } else {
                        // Stop recording
                        await _audioRecorder.stopRecorder();
                        recordedFile = File(filePath);
                        await _audioRecorder.closeRecorder();
                        Navigator.of(dialogContext).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isRecording 
                          ? const Color(0xFFF44336) 
                          : const Color(0xFF8E24AA),
                      foregroundColor: Colors.white,
                    ),
                    child: Text(isRecording ? 'Stop' : 'Start'),
                  ),
                ],
              );
            },
          );
        },
      );

      return recordedFile;
    } catch (e) {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to record audio: $e'),
          backgroundColor: const Color(0xFFF44336),
        ),
      );
      return null;
    }
  }

  // Pick image from gallery
  static Future<File?> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }

  // Pick video from gallery
  static Future<File?> pickVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
      );

      if (video != null) {
        return File(video.path);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick video: $e');
    }
  }

  // Pick audio file
  static Future<File?> pickAudio() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick audio: $e');
    }
  }

  // Pick document
  static Future<File?> pickDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'rtf'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick document: $e');
    }
  }

  // Pick any media file
  static Future<File?> pickMedia() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick media: $e');
    }
  }

  // Get file extension
  static String getFileExtension(String path) {
    return path.split('.').last.toLowerCase();
  }

  // Get file size in readable format
  static String getFileSize(File file) {
    final bytes = file.lengthSync();
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
