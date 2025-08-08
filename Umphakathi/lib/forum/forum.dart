import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/input_bar.dart';
import 'widgets/message.dart';

class _ForumConstants {
  static const Color primaryPurple = Color(0xFF6A1B9A);
  static const Color primaryOrange = Color(0xFFEC7E33);
  static const Color textDark = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF666666);
  static const double smallBorderRadius = 8.0;
}

class SpeakHubPage extends StatefulWidget {
  const SpeakHubPage({super.key});

  @override
  State<SpeakHubPage> createState() => _SpeakHubPageState();
}

class _SpeakHubPageState extends State<SpeakHubPage> {
  final List<Message> _messages = [
    Message(
      id: '1',
      text: 'Welcome to the Umphakathi community! This is where we share ideas and connect with each other.',
      sender: 'Admin',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isMe: false,
      type: MessageType.text,
    ),
    Message(
      id: '2',
      text: 'Hello everyone! Excited to be part of this community 🎉',
      sender: 'John',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      isMe: false,
      type: MessageType.text,
    ),
    Message(
      id: '3',
      text: 'Hi there! Looking forward to great discussions.',
      sender: 'Me',
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
      isMe: true,
      type: MessageType.text,
    ),
    Message(
      id: '4',
      text: 'Check out this amazing sunset I captured!',
      sender: 'Sarah',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      isMe: false,
      type: MessageType.image,
    ),
    Message(
      id: '5',
      text: 'Thanks for sharing! Beautiful photo.',
      sender: 'Me',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      isMe: true,
      type: MessageType.text,
    ),
    Message(
      id: '6',
      text: 'Here\'s a voice note about today\'s community meeting',
      sender: 'Alex',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      isMe: false,
      type: MessageType.audio,
    ),
  ];

  void _handleMessageSend(String message) {
    if (message.trim().isNotEmpty) {
      setState(() {
        _messages.add(
          Message(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: message,
            sender: 'Me',
            timestamp: DateTime.now(),
            isMe: true,
            type: MessageType.text,
          ),
        );
      });
    }
  }

  void _handleAttachment() {
    // TODO: Handle attachment selection
    print('Attachment button pressed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Community Chat',
          style: GoogleFonts.dancingScript(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
        backgroundColor: _ForumConstants.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Community info coming soon!'),
                  backgroundColor: _ForumConstants.primaryPurple,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_ForumConstants.smallBorderRadius),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Community header
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _ForumConstants.primaryOrange,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.forum_rounded,
                  color: _ForumConstants.primaryPurple,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Umphakathi Community',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _ForumConstants.textDark,
                        ),
                      ),
                      Text(
                        '${_messages.length} messages • Active now',
                        style: TextStyle(
                          fontSize: 12,
                          color: _ForumConstants.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return MessageWidget(message: _messages[index]);
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: InputBar(
              onSend: _handleMessageSend,
              onAttachment: _handleAttachment,
            ),
          ),
        ],
      ),
    );
  }
}
