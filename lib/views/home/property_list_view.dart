import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/property_service.dart';
import '../../models/property_model.dart';
import '../property/property_details_screen.dart';
import '../../widgets/property_card.dart';

class PropertyListView extends StatelessWidget {
  const PropertyListView({super.key});

  @override
  Widget build(BuildContext context) {
    final propertyService = context.read<PropertyService>();

    return StreamBuilder<List<PropertyModel>>(
      stream: propertyService.getProperties(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final properties = snapshot.data ?? [];
        if (properties.isEmpty) {
          return const Center(child: Text('No properties found'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: properties.length,
          itemBuilder: (context, index) {
            final property = properties[index];
            return PropertyCard(
              property: property,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PropertyDetailsScreen(property: property),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
