import 'package:flutter/material.dart';

class _ListItemConstants {
  static const Color primaryPurple = Color(0xFF6A1B9A);
  static const Color primaryOrange = Color(0xFFEC7E33);
  static const Color textDark = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF666666);
  static const double mediumBorderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double cardElevation = 3.0;
  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);
}

class SpeakHubListItem extends StatelessWidget {
  final String title;
  final String description;
  final String lastActivity;
  final int memberCount;
  final bool hasUnreadMessages;
  final VoidCallback onTap;

  const SpeakHubListItem({
    super.key,
    required this.title,
    required this.description,
    required this.lastActivity,
    required this.memberCount,
    this.hasUnreadMessages = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: _ListItemConstants.cardElevation,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_ListItemConstants.mediumBorderRadius),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(_ListItemConstants.mediumBorderRadius),
          child: Padding(
            padding: _ListItemConstants.cardPadding,
            child: Row(
              children: [
                // Community Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _ListItemConstants.primaryPurple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(_ListItemConstants.smallBorderRadius),
                  ),
                  child: Icon(
                    Icons.forum_rounded,
                    color: _ListItemConstants.primaryPurple,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Community Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _ListItemConstants.textDark,
                              ),
                            ),
                          ),
                          if (hasUnreadMessages)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: _ListItemConstants.primaryOrange,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: _ListItemConstants.textSecondary,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 16,
                            color: _ListItemConstants.primaryPurple,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$memberCount members',
                            style: TextStyle(
                              fontSize: 12,
                              color: _ListItemConstants.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: _ListItemConstants.primaryOrange,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              lastActivity,
                              style: TextStyle(
                                fontSize: 12,
                                color: _ListItemConstants.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                
                // Arrow Icon
                Icon(
                  Icons.arrow_forward_ios,
                  color: _ListItemConstants.primaryPurple,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
