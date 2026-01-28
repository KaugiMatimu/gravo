import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/property_service.dart';
import '../../services/location_service.dart';
import '../../models/property_model.dart';
import '../../models/location_model.dart';
import '../../utils/constants.dart';
import '../../widgets/property_card.dart';
import '../property/property_details_screen.dart';

class PropertySearchView extends StatefulWidget {
  const PropertySearchView({super.key});

  @override
  State<PropertySearchView> createState() => _PropertySearchViewState();
}

class _PropertySearchViewState extends State<PropertySearchView> {
  String _searchQuery = '';
  String? _selectedCity;
  PropertyType? _selectedType;
  RangeValues _priceRange = const RangeValues(0, 500000);
  String _sortBy = 'createdAt';

  @override
  Widget build(BuildContext context) {
    final propertyService = context.read<PropertyService>();
    final locationService = context.read<LocationService>();

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Explore Properties'),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                // Modern Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by city, name or description...',
                    prefixIcon: const Icon(Icons.search_rounded, color: AppConstants.primaryColor),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.tune_rounded, color: AppConstants.primaryColor),
                      onPressed: () => _showFilterSheet(context),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
                ),
                const SizedBox(height: 16),
                
                // Dynamic Locations
                StreamBuilder<List<LocationModel>>(
                  stream: locationService.getActiveLocations(),
                  builder: (context, snapshot) {
                    final locations = snapshot.data ?? [];
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip(
                            label: 'All Cities',
                            isSelected: _selectedCity == null,
                            onSelected: (val) => setState(() => _selectedCity = null),
                          ),
                          ...locations.map((loc) => Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: _buildFilterChip(
                              label: loc.name,
                              isSelected: _selectedCity == loc.name,
                              onSelected: (val) => setState(() => _selectedCity = val ? loc.name : null),
                            ),
                          )),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          
          Expanded(
            child: StreamBuilder<List<PropertyModel>>(
              stream: propertyService.getProperties(sortBy: _sortBy),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                var properties = snapshot.data ?? [];

                // Client-side filtering
                properties = properties.where((p) {
                  final matchesSearch = p.title.toLowerCase().contains(_searchQuery) || 
                                      p.description.toLowerCase().contains(_searchQuery) ||
                                      p.city.toLowerCase().contains(_searchQuery);
                  final matchesCity = _selectedCity == null || p.city == _selectedCity;
                  final matchesType = _selectedType == null || p.type == _selectedType;
                  final matchesPrice = p.price >= _priceRange.start && p.price <= _priceRange.end;
                  return matchesSearch && matchesCity && matchesType && matchesPrice;
                }).toList();

                if (properties.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: properties.length,
                  itemBuilder: (context, index) {
                    final property = properties[index];
                    return PropertyCard(
                      property: property,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PropertyDetailsScreen(property: property),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({required String label, required bool isSelected, required Function(bool) onSelected}) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: AppConstants.primaryColor.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppConstants.primaryColor : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: Colors.grey.shade100,
      side: BorderSide(color: isSelected ? AppConstants.primaryColor : Colors.transparent),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      showCheckmark: false,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 24),
            Text(
              'No Properties Found',
              style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Text(
              'We couldn\'t find any properties matching your current filters. Try adjusting your search or resetting the filters.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
            const SizedBox(height: 32),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _selectedCity = null;
                  _selectedType = null;
                  _priceRange = const RangeValues(0, 500000);
                });
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reset Filters'),
              style: TextButton.styleFrom(
                foregroundColor: AppConstants.primaryColor,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).padding.bottom + 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filters',
                        style: GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text('Property Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildModalChip(
                        label: 'Rental',
                        isSelected: _selectedType == PropertyType.rental,
                        onSelected: (val) => setModalState(() => _selectedType = val ? PropertyType.rental : null),
                      ),
                      const SizedBox(width: 12),
                      _buildModalChip(
                        label: 'Airbnb',
                        isSelected: _selectedType == PropertyType.airbnb,
                        onSelected: (val) => setModalState(() => _selectedType = val ? PropertyType.airbnb : null),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Price Range', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(
                        'KSh ${_priceRange.start.round()} - ${_priceRange.end.round()}',
                        style: const TextStyle(color: AppConstants.primaryColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 500000,
                    divisions: 50,
                    activeColor: AppConstants.primaryColor,
                    inactiveColor: Colors.grey.shade200,
                    onChanged: (values) => setState(() => setModalState(() => _priceRange = values)),
                  ),
                  const SizedBox(height: 32),
                  const Text('Sort By', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _sortBy,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(value: 'createdAt', child: Text('Newest First')),
                          DropdownMenuItem(value: 'price', child: Text('Price: Low to High')),
                        ],
                        onChanged: (val) => setState(() => setModalState(() => _sortBy = val!)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildModalChip({required String label, required bool isSelected, required Function(bool) onSelected}) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: AppConstants.primaryColor.withOpacity(0.1),
      checkmarkColor: AppConstants.primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? AppConstants.primaryColor : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: Colors.grey.shade50,
      side: BorderSide(color: isSelected ? AppConstants.primaryColor : Colors.grey.shade200),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
