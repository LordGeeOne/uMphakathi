import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SafetyProvider extends ChangeNotifier {
  bool _aiNudgeEnabled = false;
  bool _emergencyProtocolSet = false;
  List<String> _triggerWords = [];
  List<SafeZone> _safeZones = [];
  List<CircleMember> _circleMembers = [];
  final List<EvidenceEntry> _evidenceEntries = [];
  
  // Getters
  bool get aiNudgeEnabled => _aiNudgeEnabled;
  bool get emergencyProtocolSet => _emergencyProtocolSet;
  List<String> get triggerWords => _triggerWords;
  List<SafeZone> get safeZones => _safeZones;
  List<CircleMember> get circleMembers => _circleMembers;
  List<EvidenceEntry> get evidenceEntries => _evidenceEntries;
  
  // Initialize safety settings
  Future<void> initializeSafety() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _aiNudgeEnabled = prefs.getBool('ai_nudge_enabled') ?? false;
      _emergencyProtocolSet = prefs.getBool('emergency_protocol_set') ?? false;
      
      // Load trigger words
      final triggerWordsJson = prefs.getString('trigger_words');
      if (triggerWordsJson != null) {
        _triggerWords = List<String>.from(jsonDecode(triggerWordsJson));
      }
      
      // Load safe zones
      final safeZonesJson = prefs.getString('safe_zones');
      if (safeZonesJson != null) {
        _safeZones = (jsonDecode(safeZonesJson) as List)
            .map((json) => SafeZone.fromJson(json))
            .toList();
      }
      
      // Load circle members
      final circleMembersJson = prefs.getString('circle_members');
      if (circleMembersJson != null) {
        _circleMembers = (jsonDecode(circleMembersJson) as List)
            .map((json) => CircleMember.fromJson(json))
            .toList();
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing safety settings: $e');
    }
  }
  
  // Toggle AI nudge
  Future<void> toggleAiNudge(bool enabled) async {
    _aiNudgeEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ai_nudge_enabled', enabled);
    notifyListeners();
  }
  
  // Add evidence entry
  Future<void> addEvidenceEntry(EvidenceEntry entry) async {
    _evidenceEntries.add(entry);
    notifyListeners();
  }
  
  // Add trigger word
  Future<void> addTriggerWord(String word) async {
    if (!_triggerWords.contains(word.toLowerCase()) && _triggerWords.length < 3) {
      _triggerWords.add(word.toLowerCase());
      await _saveTriggerWords();
      notifyListeners();
    }
  }
  
  // Remove trigger word
  Future<void> removeTriggerWord(String word) async {
    _triggerWords.remove(word.toLowerCase());
    await _saveTriggerWords();
    notifyListeners();
  }
  
  // Add safe zone
  Future<void> addSafeZone(SafeZone zone) async {
    _safeZones.add(zone);
    await _saveSafeZones();
    notifyListeners();
  }

  // Update safe zone
  Future<void> updateSafeZone(SafeZone updatedZone) async {
    final index = _safeZones.indexWhere((zone) => zone.id == updatedZone.id);
    if (index != -1) {
      _safeZones[index] = updatedZone;
      await _saveSafeZones();
      notifyListeners();
    }
  }

  // Remove safe zone
  Future<void> removeSafeZone(String zoneId) async {
    _safeZones.removeWhere((zone) => zone.id == zoneId);
    await _saveSafeZones();
    notifyListeners();
  }
  
  // Add circle member
  Future<void> addCircleMember(CircleMember member) async {
    _circleMembers.add(member);
    await _saveCircleMembers();
    notifyListeners();
  }

  // Remove circle member
  Future<void> removeCircleMember(String memberId) async {
    _circleMembers.removeWhere((member) => member.id == memberId);
    await _saveCircleMembers();
    notifyListeners();
  }
  
  // Save methods
  Future<void> _saveTriggerWords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('trigger_words', jsonEncode(_triggerWords));
  }
  
  Future<void> _saveSafeZones() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('safe_zones', jsonEncode(_safeZones.map((z) => z.toJson()).toList()));
  }
  
  Future<void> _saveCircleMembers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('circle_members', jsonEncode(_circleMembers.map((m) => m.toJson()).toList()));
  }
  
  // Set emergency protocol
  Future<void> setEmergencyProtocol(bool enabled) async {
    _emergencyProtocolSet = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('emergency_protocol_set', enabled);
    notifyListeners();
  }
}

// Data models
class EvidenceEntry {
  final String id;
  final String type; // photo, video, audio, text
  final String content;
  final DateTime timestamp;
  final double? latitude;
  final double? longitude;
  final String? notes;
  
  EvidenceEntry({
    required this.id,
    required this.type,
    required this.content,
    required this.timestamp,
    this.latitude,
    this.longitude,
    this.notes,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'content': content,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'latitude': latitude,
      'longitude': longitude,
      'notes': notes,
    };
  }
  
  factory EvidenceEntry.fromJson(Map<String, dynamic> json) {
    return EvidenceEntry(
      id: json['id'],
      type: json['type'],
      content: json['content'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      latitude: json['latitude'],
      longitude: json['longitude'],
      notes: json['notes'],
    );
  }
}

class SafeZone {
  final String id;
  final String name;
  final String address;
  final String notes;
  final double latitude;
  final double longitude;
  final double radius; // in meters
  final String type; // home, work, school, etc.
  
  SafeZone({
    required this.id,
    required this.name,
    this.address = '',
    this.notes = '',
    required this.latitude,
    required this.longitude,
    this.radius = 100.0,
    this.type = 'general',
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'notes': notes,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'type': type,
    };
  }
  
  factory SafeZone.fromJson(Map<String, dynamic> json) {
    return SafeZone(
      id: json['id'],
      name: json['name'],
      address: json['address'] ?? '',
      notes: json['notes'] ?? '',
      latitude: json['latitude'],
      longitude: json['longitude'],
      radius: json['radius'] ?? 100.0,
      type: json['type'] ?? 'general',
    );
  }
}

class CircleMember {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String role; // listener, watcher, responder
  final bool isActive;
  
  CircleMember({
    required this.id,
    required this.name,
    required this.phone,
    this.email = '',
    required this.role,
    this.isActive = true,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'role': role,
      'isActive': isActive,
    };
  }
  
  factory CircleMember.fromJson(Map<String, dynamic> json) {
    return CircleMember(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'] ?? '',
      role: json['role'],
      isActive: json['isActive'] ?? true,
    );
  }
}
