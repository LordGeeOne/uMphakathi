import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/list_item.dart';
import '../forum/forum.dart';

class SpeakHubListPage extends StatefulWidget {
  const SpeakHubListPage({super.key});

  @override
  State<SpeakHubListPage> createState() => _SpeakHubListPageState();
}

// Constants matching home page styling
class _SpeakHubConstants {
  static const Color primaryPurple = Color(0xFF6A1B9A);
  static const Color secondaryPurple = Color(0xFF8E24AA);
  static const Color primaryOrange = Color(0xFFEC7E33);
  static const Color textDark = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF666666);
  static const Color cardBackground = Colors.white;
  static const Color shadowColor = Color(0x1A000000);
  
  static const double sectionSpacing = 24.0;
  static const double cardSpacing = 12.0;
  static const double borderRadius = 8.0;
  static const double smallBorderRadius = 6.0;
  static const double mediumBorderRadius = 12.0;
  static const double largeBorderRadius = 16.0;
  static const double cardElevation = 3.0;
  
  static const EdgeInsets standardPadding = EdgeInsets.all(16);
  static const EdgeInsets cardInternalPadding = EdgeInsets.all(20);
  static const EdgeInsets cardPadding = EdgeInsets.all(16);
  
  static const TextStyle sectionTitleStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: textDark,
  );
  
  static const TextStyle sectionHeaderStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textDark,
  );
  
  static BoxShadow get primaryShadow => BoxShadow(
    color: primaryOrange.withValues(alpha: 0.1),
    blurRadius: 8,
    offset: const Offset(0, 2),
  );
  
  static BoxShadow get secondaryShadow => BoxShadow(
    color: Colors.black.withValues(alpha: 0.05),
    blurRadius: 8,
    offset: const Offset(0, 2),
  );
}

class _SpeakHubListPageState extends State<SpeakHubListPage> {
  final List<Map<String, dynamic>> _speakHubCommunities = [
    {
      'title': 'General Discussion',
      'description': 'Share your thoughts, ideas, and connect with the community in our main discussion hub.',
      'lastActivity': '2 hours ago',
      'memberCount': 234,
      'hasUnreadMessages': true,
    },
    {
      'title': 'Safety Tips & Advice',
      'description': 'Exchange safety tips, advice, and best practices for staying safe in various situations.',
      'lastActivity': '4 hours ago',
      'memberCount': 156,
      'hasUnreadMessages': false,
    },
    {
      'title': 'Support & Help',
      'description': 'Get help from community members and moderators. Ask questions and share resources.',
      'lastActivity': '6 hours ago',
      'memberCount': 189,
      'hasUnreadMessages': true,
    },
    {
      'title': 'Local Community',
      'description': 'Connect with people in your local area. Share local events and community news.',
      'lastActivity': '1 day ago',
      'memberCount': 78,
      'hasUnreadMessages': false,
    },
    {
      'title': 'App Feedback',
      'description': 'Share your feedback about the Umphakathi app. Report bugs and suggest new features.',
      'lastActivity': '2 days ago',
      'memberCount': 92,
      'hasUnreadMessages': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'SpeakHub',
          style: GoogleFonts.dancingScript(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
        backgroundColor: _SpeakHubConstants.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Search functionality coming soon!'),
                  backgroundColor: _SpeakHubConstants.primaryPurple,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_SpeakHubConstants.smallBorderRadius),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: _SpeakHubConstants.standardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildSectionHeader('Your Communities', Icons.people),
              SizedBox(height: _SpeakHubConstants.cardSpacing),
              _buildStatsCard(),
              SizedBox(height: _SpeakHubConstants.sectionSpacing),
              
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _speakHubCommunities.length,
                itemBuilder: (context, index) {
                  final community = _speakHubCommunities[index];
                  return SpeakHubListItem(
                    title: community['title'],
                    description: community['description'],
                    lastActivity: community['lastActivity'],
                    memberCount: community['memberCount'],
                    hasUnreadMessages: community['hasUnreadMessages'],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SpeakHubPage(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateSpeakHubDialog(context),
        backgroundColor: _SpeakHubConstants.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 8,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: _SpeakHubConstants.primaryOrange,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Icon(
          icon,
          color: _SpeakHubConstants.primaryPurple,
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: _SpeakHubConstants.sectionHeaderStyle,
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    return Card(
      elevation: _SpeakHubConstants.cardElevation,
      shadowColor: _SpeakHubConstants.shadowColor,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_SpeakHubConstants.mediumBorderRadius),
      ),
      child: Padding(
        padding: _SpeakHubConstants.cardPadding,
        child: Row(
          children: [
            Expanded(
              child: _buildStatItem(
                '${_speakHubCommunities.length}',
                'Communities',
                Icons.groups,
                _SpeakHubConstants.primaryPurple,
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: Colors.grey[300],
            ),
            Expanded(
              child: _buildStatItem(
                '0',
                'Unread',
                Icons.mark_chat_unread,
                _SpeakHubConstants.primaryOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String count, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          count,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _SpeakHubConstants.textDark,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: _SpeakHubConstants.textSecondary,
          ),
        ),
      ],
    );
  }

  void _showCreateSpeakHubDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_SpeakHubConstants.mediumBorderRadius),
        ),
        elevation: _SpeakHubConstants.cardElevation,
        child: Container(
          padding: _SpeakHubConstants.cardPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _SpeakHubConstants.primaryOrange,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.add_circle,
                    color: _SpeakHubConstants.primaryPurple,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Create New Community',
                    style: _SpeakHubConstants.sectionHeaderStyle,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Community Title',
                  hintText: 'Enter community title',
                  labelStyle: TextStyle(color: _SpeakHubConstants.primaryPurple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_SpeakHubConstants.smallBorderRadius),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_SpeakHubConstants.smallBorderRadius),
                    borderSide: BorderSide(color: _SpeakHubConstants.primaryPurple, width: 2),
                  ),
                  prefixIcon: Icon(
                    Icons.group,
                    color: _SpeakHubConstants.primaryPurple,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Describe what this community is about',
                  labelStyle: TextStyle(color: _SpeakHubConstants.primaryPurple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_SpeakHubConstants.smallBorderRadius),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_SpeakHubConstants.smallBorderRadius),
                    borderSide: BorderSide(color: _SpeakHubConstants.primaryPurple, width: 2),
                  ),
                  prefixIcon: Icon(
                    Icons.description,
                    color: _SpeakHubConstants.primaryPurple,
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: _SpeakHubConstants.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (titleController.text.trim().isNotEmpty &&
                          descriptionController.text.trim().isNotEmpty) {
                        _createSpeakHubCommunity(
                          titleController.text.trim(),
                          descriptionController.text.trim(),
                        );
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Please fill in both title and description'),
                            backgroundColor: _SpeakHubConstants.primaryOrange,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(_SpeakHubConstants.smallBorderRadius),
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _SpeakHubConstants.primaryPurple,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_SpeakHubConstants.smallBorderRadius),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      'Create',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createSpeakHubCommunity(String title, String description) {
    setState(() {
      _speakHubCommunities.insert(0, {
        'title': title,
        'description': description,
        'lastActivity': 'Just now',
        'memberCount': 1,
        'hasUnreadMessages': false,
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('SpeakHub Community "$title" created successfully!'),
        backgroundColor: _SpeakHubConstants.primaryPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_SpeakHubConstants.smallBorderRadius),
        ),
      ),
    );
  }
}
