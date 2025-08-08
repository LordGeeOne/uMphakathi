import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/safety_provider.dart';

class TriggerWordsWidget extends StatefulWidget {
  const TriggerWordsWidget({super.key});

  @override
  State<TriggerWordsWidget> createState() => _TriggerWordsWidgetState();
}

class _TriggerWordsWidgetState extends State<TriggerWordsWidget> {
  final TextEditingController _wordController = TextEditingController();

  @override
  void dispose() {
    _wordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SafetyProvider>(
      builder: (context, safetyProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(
                  Icons.warning,
                  color: Color(0xFF004D40),
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Trigger Words',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004D40),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _showAddTriggerWordDialog(context, safetyProvider),
                  icon: const Icon(
                    Icons.add,
                    color: Color(0xFF004D40),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Words or phrases that might indicate danger or distress',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFF9800).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: const Color(0xFFFF9800),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'How it works',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFF9800),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'When these words appear in your messages or voice notes, the app may suggest safety resources or check on your wellbeing.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Trigger Words List
            if (safetyProvider.triggerWords.isEmpty)
              _buildEmptyState()
            else
              _buildTriggerWordsList(safetyProvider),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300]!,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.library_add,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            'No trigger words set',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Add words that might indicate you need help',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _showAddTriggerWordDialog(context, Provider.of<SafetyProvider>(context, listen: false)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF44336),
              foregroundColor: Colors.white,
            ),
            child: const Text('Add First Trigger Word'),
          ),
        ],
      ),
    );
  }

  Widget _buildTriggerWordsList(SafetyProvider safetyProvider) {
    return Column(
      children: [
        // Suggested trigger words section
        if (safetyProvider.triggerWords.length < 5) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF4CAF50).withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: const Color(0xFF4CAF50),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Suggested trigger words',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _getSuggestedWords(safetyProvider.triggerWords).map((word) {
                    return InkWell(
                      onTap: () => _addSuggestedWord(safetyProvider, word),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF4CAF50).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              word,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF4CAF50),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.add_circle_outline,
                              size: 16,
                              color: Color(0xFF4CAF50),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        
        // User's trigger words
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: safetyProvider.triggerWords.map((word) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF44336).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFF44336).withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.warning_amber,
                    size: 16,
                    color: const Color(0xFFF44336),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    word,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFF44336),
                    ),
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () => _showRemoveTriggerWordDialog(context, safetyProvider, word),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: const Color(0xFFF44336),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  List<String> _getSuggestedWords(List<String> currentWords) {
    const allSuggestions = [
      'help',
      'scared',
      'unsafe',
      'emergency',
      'danger',
      'hurt',
      'threatened',
      'worried',
      'anxious',
      'distressed',
      'trapped',
      'frightened',
    ];
    
    return allSuggestions
        .where((word) => !currentWords.contains(word.toLowerCase()))
        .take(6)
        .toList();
  }

  void _addSuggestedWord(SafetyProvider safetyProvider, String word) {
    safetyProvider.addTriggerWord(word.toLowerCase());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('"$word" added to trigger words')),
    );
  }

  void _showAddTriggerWordDialog(BuildContext context, SafetyProvider safetyProvider) {
    _wordController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Trigger Word'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter a word or phrase that might indicate you need help:',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _wordController,
                decoration: const InputDecoration(
                  labelText: 'Trigger word or phrase',
                  hintText: 'e.g., help, scared, unsafe',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.warning_amber),
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _addTriggerWord(context, safetyProvider),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => _addTriggerWord(context, safetyProvider),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF44336),
                foregroundColor: Colors.white,
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addTriggerWord(BuildContext context, SafetyProvider safetyProvider) {
    final word = _wordController.text.trim().toLowerCase();
    if (word.isNotEmpty && !safetyProvider.triggerWords.contains(word)) {
      safetyProvider.addTriggerWord(word);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"$word" added to trigger words')),
      );
    } else if (safetyProvider.triggerWords.contains(word)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"$word" is already in your trigger words')),
      );
    }
  }

  void _showRemoveTriggerWordDialog(BuildContext context, SafetyProvider safetyProvider, String word) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove Trigger Word'),
          content: Text('Are you sure you want to remove "$word" from your trigger words?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                safetyProvider.removeTriggerWord(word);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('"$word" removed from trigger words')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF44336),
                foregroundColor: Colors.white,
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }
}
