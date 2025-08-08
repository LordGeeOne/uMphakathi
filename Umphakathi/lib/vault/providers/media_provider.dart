import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/media_file.dart';

class MediaProvider extends ChangeNotifier {
  List<MediaFile> _mediaFiles = [];
  bool _isLoading = false;

  List<MediaFile> get mediaFiles => _mediaFiles;
  bool get isLoading => _isLoading;
  bool get hasMedia => _mediaFiles.isNotEmpty;

  // Get media files by type
  List<MediaFile> getMediaByType(MediaType type) {
    return _mediaFiles.where((file) => file.type == type).toList();
  }

  // Get count by type
  int getCountByType(MediaType type) {
    return _mediaFiles.where((file) => file.type == type).length;
  }

  // Initialize and load saved media files
  Future<void> initializeMedia() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loadMediaFiles();
    } catch (e) {
      debugPrint('Error initializing media: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new media file
  Future<void> addMediaFile(File file, MediaType type) async {
    try {
      // Check if file exists
      if (!await file.exists()) {
        throw Exception('File does not exist');
      }

      final mediaFile = MediaFile.fromFile(file, type);
      _mediaFiles.add(mediaFile);
      
      // Save to persistent storage
      await _saveMediaFiles();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add media file: $e');
    }
  }

  // Remove a media file
  Future<void> removeMediaFile(String id) async {
    try {
      _mediaFiles.removeWhere((file) => file.id == id);
      await _saveMediaFiles();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to remove media file: $e');
    }
  }

  // Clear all media files
  Future<void> clearAllMedia() async {
    try {
      _mediaFiles.clear();
      await _saveMediaFiles();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to clear media files: $e');
    }
  }

  // Save media files to SharedPreferences
  Future<void> _saveMediaFiles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final mediaJson = _mediaFiles.map((file) => file.toJson()).toList();
      await prefs.setString('media_files', jsonEncode(mediaJson));
    } catch (e) {
      debugPrint('Error saving media files: $e');
    }
  }

  // Load media files from SharedPreferences
  Future<void> _loadMediaFiles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final mediaString = prefs.getString('media_files');
      
      if (mediaString != null) {
        final List<dynamic> mediaJson = jsonDecode(mediaString);
        _mediaFiles = mediaJson
            .map((json) => MediaFile.fromJson(json))
            .where((file) => File(file.path).existsSync()) // Only keep existing files
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading media files: $e');
      _mediaFiles = [];
    }
  }

  // Determine media type from file extension
  MediaType getMediaTypeFromExtension(String extension) {
    extension = extension.toLowerCase();
    
    // Image extensions
    if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension)) {
      return MediaType.image;
    }
    
    // Video extensions
    if (['mp4', 'avi', 'mov', 'wmv', 'flv', 'webm', 'mkv'].contains(extension)) {
      return MediaType.video;
    }
    
    // Audio extensions
    if (['mp3', 'wav', 'aac', 'm4a', 'ogg', 'flac'].contains(extension)) {
      return MediaType.audio;
    }
    
    // Document extensions
    return MediaType.document;
  }
}
