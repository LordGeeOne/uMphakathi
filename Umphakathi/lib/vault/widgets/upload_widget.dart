import 'package:flutter/material.dart';

class UploadWidget extends StatelessWidget {
  final VoidCallback? onCameraPressed;
  final VoidCallback? onVideoRecord;
  final VoidCallback? onAudioRecord;
  final VoidCallback? onImageUpload;
  final VoidCallback? onVideoUpload;
  final VoidCallback? onAudioUpload;
  final VoidCallback? onDocumentUpload;
  final VoidCallback? onMediaUpload;

  const UploadWidget({
    super.key,
    this.onCameraPressed,
    this.onVideoRecord,
    this.onAudioRecord,
    this.onImageUpload,
    this.onVideoUpload,
    this.onAudioUpload,
    this.onDocumentUpload,
    this.onMediaUpload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.cloud_upload,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Upload Media',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Capture or upload files to your vault',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),

          // Camera Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.camera_alt,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Text(
                  'Capture Media',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Take photos, record videos, or capture audio',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                
                // Action Buttons Row
                Row(
                  children: [
                    // Take Photo Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onCameraPressed ?? () {
                          _showComingSoonDialog(context, 'Camera');
                        },
                        icon: const Icon(Icons.camera_alt, size: 18),
                        label: const Text('Photo'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    
                    // Record Video Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onVideoRecord ?? () {
                          _showComingSoonDialog(context, 'Video Recording');
                        },
                        icon: const Icon(Icons.videocam, size: 18),
                        label: const Text('Video'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    
                    // Record Audio Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onAudioRecord ?? () {
                          _showComingSoonDialog(context, 'Audio Recording');
                        },
                        icon: const Icon(Icons.mic, size: 18),
                        label: const Text('Audio'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Upload Options
          Text(
            'Upload from Device',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),

          // Upload Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              _buildUploadOption(
                context,
                icon: Icons.image,
                label: 'Images',
                description: 'JPG, PNG, GIF',
                color: Colors.blue,
                onTap: onImageUpload ?? () {
                  _showComingSoonDialog(context, 'Image Upload');
                },
              ),
              _buildUploadOption(
                context,
                icon: Icons.videocam,
                label: 'Videos',
                description: 'MP4, AVI, MOV',
                color: Colors.red,
                onTap: onVideoUpload ?? () {
                  _showComingSoonDialog(context, 'Video Upload');
                },
              ),
              _buildUploadOption(
                context,
                icon: Icons.audiotrack,
                label: 'Audio',
                description: 'MP3, WAV, AAC',
                color: Colors.green,
                onTap: onAudioUpload ?? () {
                  _showComingSoonDialog(context, 'Audio Upload');
                },
              ),
              _buildUploadOption(
                context,
                icon: Icons.description,
                label: 'Documents',
                description: 'PDF, DOC, TXT',
                color: Colors.orange,
                onTap: onDocumentUpload ?? () {
                  _showComingSoonDialog(context, 'Document Upload');
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // General Media Upload Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onMediaUpload ?? () {
                _showComingSoonDialog(context, 'Media Upload');
              },
              icon: const Icon(Icons.folder_open),
              label: const Text('Browse All Files'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              description,
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(
            Icons.construction,
            color: Theme.of(context).colorScheme.primary,
            size: 48,
          ),
          title: Text('$feature Coming Soon'),
          content: Text(
            '$feature functionality will be available in a future update. Stay tuned!',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
