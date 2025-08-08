class SafeButton {
  final String id;
  final String name;
  final String action;
  final DateTime createdAt;
  final DateTime? lastTriggered;

  SafeButton({
    required this.id,
    required this.name,
    required this.action,
    required this.createdAt,
    this.lastTriggered,
  });

  SafeButton copyWith({
    String? id,
    String? name,
    String? action,
    DateTime? createdAt,
    DateTime? lastTriggered,
  }) {
    return SafeButton(
      id: id ?? this.id,
      name: name ?? this.name,
      action: action ?? this.action,
      createdAt: createdAt ?? this.createdAt,
      lastTriggered: lastTriggered ?? this.lastTriggered,
    );
  }

  bool wasRecentlyTriggered() {
    if (lastTriggered == null) return false;
    final now = DateTime.now();
    final difference = now.difference(lastTriggered!);
    return difference.inMinutes < 30; // Consider "recent" as within 30 minutes
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'action': action,
      'createdAt': createdAt.toIso8601String(),
      'lastTriggered': lastTriggered?.toIso8601String(),
    };
  }

  factory SafeButton.fromJson(Map<String, dynamic> json) {
    return SafeButton(
      id: json['id'],
      name: json['name'],
      action: json['action'],
      createdAt: DateTime.parse(json['createdAt']),
      lastTriggered: json['lastTriggered'] != null 
          ? DateTime.parse(json['lastTriggered'])
          : null,
    );
  }
}
