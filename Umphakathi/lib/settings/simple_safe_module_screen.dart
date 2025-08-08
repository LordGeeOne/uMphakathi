import 'package:flutter/material.dart';

class SafeModuleScreen extends StatefulWidget {
  const SafeModuleScreen({super.key});

  @override
  State<SafeModuleScreen> createState() => _SafeModuleScreenState();
}

class _SafeModuleScreenState extends State<SafeModuleScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Mock data for demonstration
  final List<SafeButton> _safeButtons = [];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safe Module'),
        backgroundColor: const Color(0xFF6A1B9A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelp(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Emergency', icon: Icon(Icons.warning_rounded)),
            Tab(text: 'Contacts', icon: Icon(Icons.contacts)),
            Tab(text: 'Settings', icon: Icon(Icons.settings)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEmergencyTab(),
          _buildContactsTab(),
          _buildSettingsTab(),
        ],
      ),
    );
  }
  
  Widget _buildEmergencyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Emergency Actions Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning_rounded, color: Colors.red[700], size: 24),
                      const SizedBox(width: 12),
                      const Text(
                        'Emergency Actions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Quick actions for emergency situations',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  _buildEmergencyButton(
                    'Call Emergency Services',
                    Icons.phone,
                    Colors.red,
                    () => _showEmergencyCall(context),
                  ),
                  const SizedBox(height: 12),
                  _buildEmergencyButton(
                    'Alert Trusted Contacts',
                    Icons.people,
                    const Color(0xFF6A1B9A),
                    () => _showAlertContacts(context),
                  ),
                  const SizedBox(height: 12),
                  _buildEmergencyButton(
                    'Share Location',
                    Icons.location_on,
                    Colors.orange,
                    () => _showShareLocation(context),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Quick Safe Buttons Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.touch_app, color: Color(0xFF6A1B9A), size: 24),
                      const SizedBox(width: 12),
                      const Text(
                        'Quick Safe Buttons',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Use volume buttons or power button for quick emergency alerts',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  if (_safeButtons.isEmpty) ...[
                    Center(
                      child: Column(
                        children: [
                          Icon(Icons.add_circle_outline, size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'No safe buttons configured',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () => _showAddButtonDialog(context),
                            icon: const Icon(Icons.add),
                            label: const Text('Add Safe Button'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6A1B9A),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    ..._safeButtons.map((button) => Card(
                      color: Colors.grey[50],
                      child: ListTile(
                        leading: Icon(button.icon, color: const Color(0xFF6A1B9A)),
                        title: Text(button.name),
                        subtitle: Text(button.description),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => _deleteSafeButton(button),
                        ),
                      ),
                    )),
                    const SizedBox(height: 12),
                    if (_safeButtons.length < 3)
                      Center(
                        child: OutlinedButton.icon(
                          onPressed: () => _showAddButtonDialog(context),
                          icon: const Icon(Icons.add),
                          label: const Text('Add Another Button'),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContactsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.contacts, color: Color(0xFF6A1B9A), size: 24),
                      const SizedBox(width: 12),
                      const Text(
                        'Trusted Contacts',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Add up to 5 trusted contacts who will be notified in emergency situations',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.person_add, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No trusted contacts added yet',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () => _showComingSoon(context, 'Add Trusted Contacts'),
                          icon: const Icon(Icons.add),
                          label: const Text('Add Contact'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6A1B9A),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.message, color: Color(0xFF6A1B9A), size: 24),
                      const SizedBox(width: 12),
                      const Text(
                        'Emergency Message',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Customize the message sent to your trusted contacts',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'I need help! Please check on me. My location: [AUTO_LOCATION]',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.save),
                        onPressed: () => _showComingSoon(context, 'Save Emergency Message'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.settings, color: Color(0xFF6A1B9A), size: 24),
                      const SizedBox(width: 12),
                      const Text(
                        'Safety Settings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Auto Location Sharing'),
                    subtitle: const Text('Automatically share location in emergencies'),
                    value: true,
                    activeColor: const Color(0xFF6A1B9A),
                    onChanged: (value) => _showComingSoon(context, 'Auto Location Sharing'),
                  ),
                  SwitchListTile(
                    title: const Text('Silent Alert Mode'),
                    subtitle: const Text('Send alerts without making sounds'),
                    value: false,
                    activeColor: const Color(0xFF6A1B9A),
                    onChanged: (value) => _showComingSoon(context, 'Silent Alert Mode'),
                  ),
                  SwitchListTile(
                    title: const Text('Quick Button Access'),
                    subtitle: const Text('Use volume buttons for emergency alerts'),
                    value: true,
                    activeColor: const Color(0xFF6A1B9A),
                    onChanged: (value) => _showComingSoon(context, 'Quick Button Access'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.history, color: Color(0xFF6A1B9A), size: 24),
                      const SizedBox(width: 12),
                      const Text(
                        'Emergency History',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.list_alt),
                    title: const Text('View Alert History'),
                    subtitle: const Text('See your previous emergency alerts'),
                    onTap: () => _showComingSoon(context, 'Alert History'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.analytics),
                    title: const Text('Safety Analytics'),
                    subtitle: const Text('View your safety patterns and insights'),
                    onTap: () => _showComingSoon(context, 'Safety Analytics'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.backup, color: Color(0xFF6A1B9A), size: 24),
                      const SizedBox(width: 12),
                      const Text(
                        'Data & Backup',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.cloud_upload),
                    title: const Text('Backup Settings'),
                    subtitle: const Text('Backup your safety configuration'),
                    onTap: () => _showComingSoon(context, 'Backup Settings'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.restore),
                    title: const Text('Restore Settings'),
                    subtitle: const Text('Restore from previous backup'),
                    onTap: () => _showComingSoon(context, 'Restore Settings'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmergencyButton(String title, IconData icon, Color color, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(title, style: const TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
  
  void _showAddButtonDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    String selectedButton = 'volume_up';
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Safe Button'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Button Name',
                  hintText: 'e.g., Emergency Alert',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedButton,
                decoration: const InputDecoration(
                  labelText: 'Physical Button',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'volume_up', child: Text('Volume Up')),
                  DropdownMenuItem(value: 'volume_down', child: Text('Volume Down')),
                  DropdownMenuItem(value: 'power', child: Text('Power Button')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedButton = value);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  _addSafeButton(nameController.text.trim(), selectedButton);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A1B9A),
                foregroundColor: Colors.white,
              ),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _addSafeButton(String name, String buttonType) {
    setState(() {
      _safeButtons.add(SafeButton(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        buttonType: buttonType,
        icon: _getButtonIcon(buttonType),
        description: _getButtonDescription(buttonType),
      ));
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added safe button: $name'),
        backgroundColor: const Color(0xFF6A1B9A),
      ),
    );
  }
  
  void _deleteSafeButton(SafeButton button) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Safe Button'),
        content: Text('Are you sure you want to delete "${button.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _safeButtons.removeWhere((b) => b.id == button.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Deleted safe button: ${button.name}'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
  
  IconData _getButtonIcon(String buttonType) {
    switch (buttonType) {
      case 'volume_up':
        return Icons.volume_up;
      case 'volume_down':
        return Icons.volume_down;
      case 'power':
        return Icons.power_settings_new;
      default:
        return Icons.touch_app;
    }
  }
  
  String _getButtonDescription(String buttonType) {
    switch (buttonType) {
      case 'volume_up':
        return 'Press volume up button 3 times quickly';
      case 'volume_down':
        return 'Press volume down button 3 times quickly';
      case 'power':
        return 'Press power button 5 times quickly';
      default:
        return 'Custom button configuration';
    }
  }
  
  void _showEmergencyCall(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.phone, color: Colors.red[700]),
            const SizedBox(width: 8),
            const Text('Emergency Call'),
          ],
        ),
        content: const Text(
          'This will immediately call emergency services (911). Only use in real emergencies.\n\nAre you sure you want to proceed?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showComingSoon(context, 'Emergency Call');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Call 911', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
  
  void _showAlertContacts(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.people, color: Color(0xFF6A1B9A)),
            const SizedBox(width: 8),
            const Text('Alert Contacts'),
          ],
        ),
        content: const Text(
          'This will send an emergency alert to all your trusted contacts with your current location.\n\nProceed with alert?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showComingSoon(context, 'Alert Trusted Contacts');
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6A1B9A)),
            child: const Text('Send Alert', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
  
  void _showShareLocation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.orange),
            const SizedBox(width: 8),
            const Text('Share Location'),
          ],
        ),
        content: const Text(
          'This will share your current location with your trusted contacts and emergency services if needed.\n\nShare your location now?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showComingSoon(context, 'Location Sharing');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Share Location', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
  
  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Safe Module Help'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Emergency Tab',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('Quick access to emergency services and alert options. Configure safe buttons for rapid emergency response.'),
              SizedBox(height: 16),
              Text(
                'Contacts Tab',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('Add trusted contacts who will be notified during emergencies. Customize your emergency message.'),
              SizedBox(height: 16),
              Text(
                'Settings Tab',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('Configure safety preferences, view emergency history, and manage data backup.'),
              SizedBox(height: 16),
              Text(
                'Safe Buttons',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('Physical buttons on your device that can trigger emergency alerts when pressed multiple times quickly.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
  
  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon!'),
        backgroundColor: const Color(0xFF6A1B9A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

// Simple data model for safe buttons
class SafeButton {
  final String id;
  final String name;
  final String buttonType;
  final IconData icon;
  final String description;
  
  SafeButton({
    required this.id,
    required this.name,
    required this.buttonType,
    required this.icon,
    required this.description,
  });
}
