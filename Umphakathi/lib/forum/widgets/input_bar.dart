import 'package:flutter/material.dart';

class _InputBarConstants {
  static const Color primaryPurple = Color(0xFF6A1B9A);
  static const Color primaryOrange = Color(0xFFEC7E33);
  static const Color textDark = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF666666);
  static const double smallBorderRadius = 8.0;
  static const double mediumBorderRadius = 12.0;
}

class InputBar extends StatefulWidget {
  final Function(String) onSend;
  final Function()? onAttachment;
  
  const InputBar({
    super.key,
    required this.onSend,
    this.onAttachment,
  });

  @override
  State<InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<InputBar> {
  final TextEditingController _textController = TextEditingController();
  
  void _sendMessage() {
    final message = _textController.text.trim();
    if (message.isNotEmpty) {
      widget.onSend(message);
      _textController.clear();
    }
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(_InputBarConstants.mediumBorderRadius),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _InputBarConstants.primaryOrange,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.attach_file,
                    color: _InputBarConstants.primaryPurple,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Send Media',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _InputBarConstants.textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAttachmentOption(
                    icon: Icons.image,
                    label: 'Image',
                    color: _InputBarConstants.primaryPurple,
                    onTap: () {
                      Navigator.pop(context);
                      if (widget.onAttachment != null) {
                        widget.onAttachment!();
                      }
                    },
                  ),
                  _buildAttachmentOption(
                    icon: Icons.videocam,
                    label: 'Video',
                    color: _InputBarConstants.primaryOrange,
                    onTap: () {
                      Navigator.pop(context);
                      if (widget.onAttachment != null) {
                        widget.onAttachment!();
                      }
                    },
                  ),
                  _buildAttachmentOption(
                    icon: Icons.mic,
                    label: 'Audio',
                    color: _InputBarConstants.primaryPurple,
                    onTap: () {
                      Navigator.pop(context);
                      if (widget.onAttachment != null) {
                        widget.onAttachment!();
                      }
                    },
                  ),
                  _buildAttachmentOption(
                    icon: Icons.insert_drive_file,
                    label: 'Document',
                    color: _InputBarConstants.primaryOrange,
                    onTap: () {
                      Navigator.pop(context);
                      if (widget.onAttachment != null) {
                        widget.onAttachment!();
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(_InputBarConstants.mediumBorderRadius),
            ),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: _InputBarConstants.textDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: _InputBarConstants.primaryOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(_InputBarConstants.smallBorderRadius),
              ),
              child: IconButton(
                onPressed: _showAttachmentOptions,
                icon: Icon(
                  Icons.attach_file,
                  size: 20,
                  color: _InputBarConstants.primaryOrange,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1.0,
                  ),
                  color: Colors.grey[50],
                ),
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(
                      color: _InputBarConstants.textSecondary,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                  ),
                  style: TextStyle(
                    color: _InputBarConstants.textDark,
                  ),
                  maxLines: 1,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: _InputBarConstants.primaryPurple,
                borderRadius: BorderRadius.circular(_InputBarConstants.smallBorderRadius),
              ),
              child: IconButton(
                onPressed: _sendMessage,
                icon: const Icon(
                  Icons.send,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
