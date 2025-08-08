import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'widgets/upload_widget.dart';
import 'services/media_service.dart';
import 'providers/media_provider.dart';
import 'models/media_file.dart';

class VaultPage extends StatefulWidget {
  const VaultPage({super.key});

  @override
  State<VaultPage> createState() => _VaultPageState();
}

class _VaultPageState extends State<VaultPage> {
  bool _isLoading = false;

  Future<void> _handleCameraPressed() async {
    setState(() => _isLoading = true);
    try {
      final file = await MediaService.takePhoto();
      if (file != null) {
        final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
        await mediaProvider.addMediaFile(file, MediaType.image);
        _showSuccessMessage('Photo captured successfully!');
      }
    } catch (e) {
      _showErrorMessage('Failed to take photo: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleVideoRecord() async {
    setState(() => _isLoading = true);
    try {
      final file = await MediaService.recordVideo();
      if (file != null) {
        final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
        await mediaProvider.addMediaFile(file, MediaType.video);
        _showSuccessMessage('Video recorded successfully!');
      }
    } catch (e) {
      _showErrorMessage('Failed to record video: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleAudioRecord() async {
    setState(() => _isLoading = true);
    try {
      final file = await MediaService.recordAudio(context);
      if (file != null) {
        final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
        await mediaProvider.addMediaFile(file, MediaType.audio);
        _showSuccessMessage('Audio recorded successfully!');
      }
    } catch (e) {
      _showErrorMessage('Failed to record audio: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleImageUpload() async {
    setState(() => _isLoading = true);
    try {
      final file = await MediaService.pickImage();
      if (file != null) {
        final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
        await mediaProvider.addMediaFile(file, MediaType.image);
        _showSuccessMessage('Image uploaded successfully!');
      }
    } catch (e) {
      _showErrorMessage('Failed to upload image: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleVideoUpload() async {
    setState(() => _isLoading = true);
    try {
      final file = await MediaService.pickVideo();
      if (file != null) {
        final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
        await mediaProvider.addMediaFile(file, MediaType.video);
        _showSuccessMessage('Video uploaded successfully!');
      }
    } catch (e) {
      _showErrorMessage('Failed to upload video: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleAudioUpload() async {
    setState(() => _isLoading = true);
    try {
      final file = await MediaService.pickAudio();
      if (file != null) {
        final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
        await mediaProvider.addMediaFile(file, MediaType.audio);
        _showSuccessMessage('Audio uploaded successfully!');
      }
    } catch (e) {
      _showErrorMessage('Failed to upload audio: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleDocumentUpload() async {
    setState(() => _isLoading = true);
    try {
      final file = await MediaService.pickDocument();
      if (file != null) {
        final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
        await mediaProvider.addMediaFile(file, MediaType.document);
        _showSuccessMessage('Document uploaded successfully!');
      }
    } catch (e) {
      _showErrorMessage('Failed to upload document: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleMediaUpload() async {
    setState(() => _isLoading = true);
    try {
      final file = await MediaService.pickMedia();
      if (file != null) {
        final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
        final extension = MediaService.getFileExtension(file.path);
        final mediaType = mediaProvider.getMediaTypeFromExtension(extension);
        await mediaProvider.addMediaFile(file, mediaType);
        _showSuccessMessage('Media uploaded successfully!');
      }
    } catch (e) {
      _showErrorMessage('Failed to upload media: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showUploadModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      'Upload Media',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              // Upload Widget
              Expanded(
                child: SingleChildScrollView(
                  child: UploadWidget(
                    onCameraPressed: () {
                      _handleCameraPressed();
                      Navigator.pop(context);
                    },
                    onVideoRecord: () {
                      _handleVideoRecord();
                      Navigator.pop(context);
                    },
                    onAudioRecord: () {
                      _handleAudioRecord();
                      Navigator.pop(context);
                    },
                    onImageUpload: () {
                      _handleImageUpload();
                      Navigator.pop(context);
                    },
                    onVideoUpload: () {
                      _handleVideoUpload();
                      Navigator.pop(context);
                    },
                    onAudioUpload: () {
                      _handleAudioUpload();
                      Navigator.pop(context);
                    },
                    onDocumentUpload: () {
                      _handleDocumentUpload();
                      Navigator.pop(context);
                    },
                    onMediaUpload: () {
                      _handleMediaUpload();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vault',
          style: GoogleFonts.dancingScript(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF004D40),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<MediaProvider>(
        builder: (context, mediaProvider, child) {
          if (mediaProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return mediaProvider.hasMedia 
              ? _buildVaultWithMedia(mediaProvider) 
              : _buildEmptyVault(mediaProvider);
        },
      ),
      floatingActionButton: _isLoading
          ? const CircularProgressIndicator()
          : FloatingActionButton(
              onPressed: _showUploadModal,
              tooltip: 'Upload Media',
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              child: const Icon(Icons.add),
            ),
    );
  }

  Widget _buildEmptyVault(MediaProvider mediaProvider) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_outlined,
            size: 120,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 24),
          Text(
            'Your Vault is Empty',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Tap the + button to upload your first file\nand start building your media collection',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 40),
          
          // Media Type Cards
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _MediaTypeCard(
                icon: Icons.image,
                label: 'Images',
                count: mediaProvider.getCountByType(MediaType.image).toString(),
              ),
              const SizedBox(width: 16),
              _MediaTypeCard(
                icon: Icons.videocam,
                label: 'Videos',
                count: mediaProvider.getCountByType(MediaType.video).toString(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _MediaTypeCard(
                icon: Icons.audiotrack,
                label: 'Audio',
                count: mediaProvider.getCountByType(MediaType.audio).toString(),
              ),
              const SizedBox(width: 16),
              _MediaTypeCard(
                icon: Icons.description,
                label: 'Documents',
                count: mediaProvider.getCountByType(MediaType.document).toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVaultWithMedia(MediaProvider mediaProvider) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mediaProvider.mediaFiles.length,
      itemBuilder: (context, index) {
        final mediaFile = mediaProvider.mediaFiles[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: _getMediaIcon(mediaFile.type),
            title: Text(mediaFile.name),
            subtitle: Text('${mediaFile.formattedSize} • ${mediaFile.extension}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await mediaProvider.removeMediaFile(mediaFile.id);
                _showSuccessMessage('File removed successfully');
              },
            ),
          ),
        );
      },
    );
  }

  Widget _getMediaIcon(MediaType type) {
    switch (type) {
      case MediaType.image:
        return const Icon(Icons.image, color: Colors.blue);
      case MediaType.video:
        return const Icon(Icons.videocam, color: Colors.red);
      case MediaType.audio:
        return const Icon(Icons.audiotrack, color: Colors.green);
      case MediaType.document:
        return const Icon(Icons.description, color: Colors.orange);
    }
  }
}

class _MediaTypeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String count;

  const _MediaTypeCard({
    required this.icon,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 28,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 4),
          Text(
            count,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
