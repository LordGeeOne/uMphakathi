import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/safety_provider.dart';

class SafeZonesWidget extends StatefulWidget {
  const SafeZonesWidget({super.key});

  @override
  State<SafeZonesWidget> createState() => _SafeZonesWidgetState();
}

class _SafeZonesWidgetState extends State<SafeZonesWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _notesController.dispose();
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
                  Icons.location_on,
                  color: Color(0xFF004D40),
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Safe Zones',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004D40),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _showAddSafeZoneDialog(context, safetyProvider),
                  icon: const Icon(
                    Icons.add_location,
                    color: Color(0xFF004D40),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Mark places where you feel safe and secure',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Safe Zones List
            if (safetyProvider.safeZones.isEmpty)
              _buildEmptyState()
            else
              _buildSafeZonesList(safetyProvider),
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
        color: const Color(0xFF004D40).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF004D40).withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.add_location_alt,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            'No safe zones marked yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Add places like home, work, school, or community centers',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSafeZonesList(SafetyProvider safetyProvider) {
    return Column(
      children: safetyProvider.safeZones.map((zone) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF004D40).withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Zone Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF004D40).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getZoneIcon(zone.name),
                      color: const Color(0xFF004D40),
                      size: 24,
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Zone Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          zone.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF212121),
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (zone.address.isNotEmpty)
                          Row(
                            children: [
                              Icon(
                                Icons.place,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  zone.address,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  
                  // Actions
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'navigate') {
                        // TODO: Implement navigation
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Navigate to ${zone.name}')),
                        );
                      } else if (value == 'edit') {
                        _showEditSafeZoneDialog(context, safetyProvider, zone);
                      } else if (value == 'remove') {
                        _showRemoveSafeZoneDialog(context, safetyProvider, zone);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'navigate',
                        child: Row(
                          children: [
                            Icon(Icons.navigation, size: 20, color: Color(0xFF004D40)),
                            SizedBox(width: 8),
                            Text('Navigate'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20, color: Color(0xFF00695C)),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'remove',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Color(0xFF004D40)),
                            SizedBox(width: 8),
                            Text('Remove'),
                          ],
                        ),
                      ),
                    ],
                    child: Icon(
                      Icons.more_vert,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              
              // Notes section
              if (zone.notes.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB2DFDB).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    zone.notes,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  IconData _getZoneIcon(String zoneName) {
    final name = zoneName.toLowerCase();
    if (name.contains('home') || name.contains('house')) {
      return Icons.home;
    } else if (name.contains('work') || name.contains('office')) {
      return Icons.work;
    } else if (name.contains('school') || name.contains('university') || name.contains('college')) {
      return Icons.school;
    } else if (name.contains('hospital') || name.contains('clinic')) {
      return Icons.local_hospital;
    } else if (name.contains('police') || name.contains('station')) {
      return Icons.local_police;
    } else if (name.contains('library')) {
      return Icons.library_books;
    } else if (name.contains('gym') || name.contains('fitness')) {
      return Icons.fitness_center;
    } else if (name.contains('store') || name.contains('shop') || name.contains('mall')) {
      return Icons.store;
    } else {
      return Icons.location_on;
    }
  }

  void _showAddSafeZoneDialog(BuildContext context, SafetyProvider safetyProvider) {
    _nameController.clear();
    _addressController.clear();
    _notesController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Safe Zone'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Zone Name *',
                    hintText: 'e.g., Home, Work, Library',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    hintText: 'Street address or landmark',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.place),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (Optional)',
                    hintText: 'Why this place feels safe to you',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.note),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.trim().isNotEmpty) {
                  final zone = SafeZone(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: _nameController.text.trim(),
                    address: _addressController.text.trim(),
                    notes: _notesController.text.trim(),
                    latitude: 0.0, // TODO: Get actual coordinates
                    longitude: 0.0,
                  );
                  safetyProvider.addSafeZone(zone);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${zone.name} added to safe zones')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF004D40),
                foregroundColor: Colors.white,
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditSafeZoneDialog(BuildContext context, SafetyProvider safetyProvider, SafeZone zone) {
    _nameController.text = zone.name;
    _addressController.text = zone.address;
    _notesController.text = zone.notes;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Safe Zone'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Zone Name *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.place),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.note),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.trim().isNotEmpty) {
                  final updatedZone = SafeZone(
                    id: zone.id,
                    name: _nameController.text.trim(),
                    address: _addressController.text.trim(),
                    notes: _notesController.text.trim(),
                    latitude: zone.latitude,
                    longitude: zone.longitude,
                  );
                  safetyProvider.updateSafeZone(updatedZone);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Safe zone updated')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF004D40),
                foregroundColor: Colors.white,
              ),
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showRemoveSafeZoneDialog(BuildContext context, SafetyProvider safetyProvider, SafeZone zone) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove Safe Zone'),
          content: Text('Are you sure you want to remove "${zone.name}" from your safe zones?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                safetyProvider.removeSafeZone(zone.id);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${zone.name} removed from safe zones')),
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
