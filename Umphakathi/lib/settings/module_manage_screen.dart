import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/safe_button_provider.dart';
import '../../models/safe_button.dart';

class ModuleManageScreen extends StatelessWidget {
  final VoidCallback? onSwitchToSetup;

  const ModuleManageScreen({
    super.key,
    this.onSwitchToSetup,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SafeButtonProvider>(
      builder: (context, provider, child) {
        if (provider.safeButtons.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_circle_outline,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No safe buttons configured',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: onSwitchToSetup,
                  child: const Text('Add a button'),
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.safeButtons.length,
          itemBuilder: (context, index) {
            final button = provider.safeButtons[index];
            return Card(
              child: ListTile(
                leading: Icon(
                  button.wasRecentlyTriggered()
                      ? Icons.warning_amber_rounded
                      : Icons.check_circle_outline,
                  color: button.wasRecentlyTriggered()
                      ? Colors.orange
                      : Colors.green,
                ),
                title: Text(button.name),
                subtitle: Text(_getButtonDescription(button)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => _showRenameDialog(context, provider, button),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _showDeleteConfirmation(context, provider, button),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _getButtonDescription(SafeButton button) {
    switch (button.action) {
      case 'volume_up':
        return 'Volume Up button';
      case 'volume_down':
        return 'Volume Down button';
      case 'power':
        return 'Power button';
      default:
        return 'Custom button';
    }
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
