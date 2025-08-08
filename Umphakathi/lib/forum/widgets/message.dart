import 'package:flutter/material.dart';

class Message {
  final String id;
  final String text;
  final String sender;
  final DateTime timestamp;
  final bool isMe;
  final MessageType type;
  final String? attachmentUrl;

  Message({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    required this.isMe,
    this.type = MessageType.text,
    this.attachmentUrl,
  });
}

enum MessageType {
  text,
  image,
  audio,
  video,
  document,
}

class MessageWidget extends StatelessWidget {
  final Message message;
  
  const MessageWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: message.isMe 
          ? MainAxisAlignment.end 
          : MainAxisAlignment.start,
        children: [
          if (!message.isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: Text(
                message.sender[0].toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: message.isMe 
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: message.isMe 
                  ? null 
                  : Border.all(
                      color: Theme.of(context).dividerColor,
                      width: 1,
                    ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!message.isMe) ...[
                    Text(
                      message.sender,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  _buildMessageContent(context),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      color: message.isMe 
                        ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.7)
                        : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Text(
                'Me',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    switch (message.type) {
      case MessageType.text:
        return Text(
          message.text,
          style: TextStyle(
            fontSize: 14,
            color: message.isMe 
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurface,
          ),
        );
      case MessageType.image:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.image,
                size: 40,
                color: Colors.grey.shade600,
              ),
            ),
            if (message.text.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                message.text,
                style: TextStyle(
                  fontSize: 14,
                  color: message.isMe 
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ],
        );
      case MessageType.audio:
        return Row(
          children: [
            Icon(
              Icons.play_circle_filled,
              color: message.isMe 
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message.text.isEmpty ? 'Audio message' : message.text,
                style: TextStyle(
                  fontSize: 14,
                  color: message.isMe 
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ],
        );
      case MessageType.video:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.play_circle_filled,
                size: 40,
                color: Colors.grey.shade600,
              ),
            ),
            if (message.text.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                message.text,
                style: TextStyle(
                  fontSize: 14,
                  color: message.isMe 
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ],
        );
      case MessageType.document:
        return Row(
          children: [
            Icon(
              Icons.insert_drive_file,
              color: message.isMe 
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message.text.isEmpty ? 'Document' : message.text,
                style: TextStyle(
                  fontSize: 14,
                  color: message.isMe 
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ],
        );
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }
}
