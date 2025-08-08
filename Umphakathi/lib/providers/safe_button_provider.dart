import 'package:flutter/foundation.dart';
import '../models/safe_button.dart';

class SafeButtonProvider extends ChangeNotifier {
  final List<SafeButton> _safeButtons = [];
  bool _isRecordingButton = false;
  String? _recordingName;

  List<SafeButton> get safeButtons => List.unmodifiable(_safeButtons);
  bool get isRecordingButton => _isRecordingButton;
  String? get recordingName => _recordingName;

  void addButton(SafeButton button) {
    _safeButtons.add(button);
    notifyListeners();
  }

  void deleteButton(String id) {
    _safeButtons.removeWhere((button) => button.id == id);
    notifyListeners();
  }

  void renameButton(String id, String newName) {
    final index = _safeButtons.indexWhere((button) => button.id == id);
    if (index != -1) {
      _safeButtons[index] = _safeButtons[index].copyWith(name: newName);
      notifyListeners();
    }
  }

  Future<void> startRecording(String name) async {
    if (_isRecordingButton) return;
    
    _isRecordingButton = true;
    _recordingName = name;
    notifyListeners();

    // Auto-stop recording after 30 seconds
    Future.delayed(const Duration(seconds: 30), () {
      if (_isRecordingButton) {
        stopRecording();
      }
    });
  }

  void stopRecording() {
    _isRecordingButton = false;
    _recordingName = null;
    notifyListeners();
  }

  void simulateButtonPress(String action, String type) {
    if (!_isRecordingButton || _recordingName == null) return;

    final button = SafeButton(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _recordingName!,
      action: action,
      createdAt: DateTime.now(),
    );

    addButton(button);
    stopRecording();
  }

  void triggerButton(String id) {
    final index = _safeButtons.indexWhere((button) => button.id == id);
    if (index != -1) {
      _safeButtons[index] = _safeButtons[index].copyWith(
        lastTriggered: DateTime.now(),
      );
      notifyListeners();
      
      // Here you would implement the actual emergency action
      _handleEmergencyTrigger(_safeButtons[index]);
    }
  }

  void _handleEmergencyTrigger(SafeButton button) {
    // Implementation for handling emergency triggers
    // This could send alerts, make calls, etc.
    debugPrint('Emergency triggered: ${button.name}');
  }
}
