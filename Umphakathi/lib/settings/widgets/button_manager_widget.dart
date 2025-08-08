import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/safe_button_provider.dart';
import '../../models/safe_button.dart';

class ButtonManagerWidget extends StatelessWidget {
  const ButtonManagerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SafeButtonProvider>(
      builder: (context, provider, child) {
        return Column(
          children: List.generate(3, (index) {
            SafeButton? button = index < provider.safeButtons.length 
                ? provider.safeButtons[index] 
                : null;

            return Column(
              children: [
                if (index > 0) Divider(height: 1, color: Colors.grey[300]),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                children: [
                  // Button indicator circle
                  DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: button != null 
                          ? (button.wasRecentlyTriggered() 
                              ? Colors.orange 
                              : const Color(0xFF764ba2))
                          : Colors.grey[300],
                      border: Border.all(
                        color: Colors.grey[400]!,
                        width: 1,
                      ),
                    ),
                    child: const SizedBox(width: 24, height: 24),
                  ),
                  const SizedBox(width: 12),
                  
                  // Button name or status text
                  Expanded(
                    child: Text(
                      button?.name ?? 'No button assigned',
                      style: TextStyle(
                        color: button != null ? Colors.black87 : Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ),
                  
                  // Action buttons
                  if (button != null) ...[
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      onPressed: () => _showRenameDialog(context, provider, button),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      visualDensity: VisualDensity.compact,
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: () => _showDeleteConfirmation(context, provider, button),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ],
              ),
            ),
              ],
            );
          }),
        );
      },
    );
  }

  void _showRenameDialog(BuildContext context, SafeButtonProvider provider, SafeButton button) {
    final controller = TextEditingController(text: button.name);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Button'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Button Name',
            hintText: 'Enter new name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.dispose();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty && newName != button.name) {
                provider.renameButton(button.id, newName);
              }
              controller.dispose();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, SafeButtonProvider provider, SafeButton button) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Safe Button?'),
        content: Text('Are you sure you want to delete "${button.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteButton(button.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
