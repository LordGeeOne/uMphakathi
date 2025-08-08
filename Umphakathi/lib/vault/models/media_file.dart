import 'dart:io';

enum MediaType { image, video, audio, document }

class MediaFile {
  final String id;
  final String name;
  final String path;
  final MediaType type;
  final int size;
  final DateTime createdAt;
  final String? thumbnail;

  MediaFile({
    required this.id,
    required this.name,
    required this.path,
    required this.type,
    required this.size,
    required this.createdAt,
    this.thumbnail,
  });

  factory MediaFile.fromFile(File file, MediaType type) {
    final fileName = file.path.split('/').last;
    return MediaFile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: fileName,
      path: file.path,
      type: type,
      size: file.lengthSync(),
      createdAt: DateTime.now(),
    );
  }

  String get formattedSize {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    if (size < 1024 * 1024 * 1024) return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String get extension {
    return path.split('.').last.toLowerCase();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'type': type.index,
      'size': size,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'thumbnail': thumbnail,
    };
  }

  factory MediaFile.fromJson(Map<String, dynamic> json) {
    return MediaFile(
      id: json['id'],
      name: json['name'],
      path: json['path'],
      type: MediaType.values[json['type']],
      size: json['size'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      thumbnail: json['thumbnail'],
    );
  }
}
