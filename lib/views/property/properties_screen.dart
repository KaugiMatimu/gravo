import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/property_model.dart';
import '../../services/property_service.dart';
import '../../services/auth_service.dart';
import '../../utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../models/user_model.dart';
import '../auth/login_screen.dart';
import '../../widgets/property_card.dart';
import 'property_details_screen.dart';

class PropertiesScreen extends StatefulWidget {
  final String? initialLocation;
  final String? initialType;
  final String? initialBedrooms;

  const PropertiesScreen({
    super.key,
    this.initialLocation,
    this.initialType,
    this.initialBedrooms,
  });

  @override
  State<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> {
  late String selectedLocation;
  late String selectedType;
  String selectedBedrooms = 'Bedrooms';
  String selectedSort = 'Newest';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> locations = ['Location', 'Nairobi', 'Mombasa', 'Nakuru', 'Eldoret', 'Kisumu'];
  final List<String> types = ['Type', 'Rental', 'Airbnb'];
  final List<String> bedroomsList = ['Bedrooms', 'Any', '1+', '2+', '3+', '4+'];
  final List<String> sorts = ['Newest', 'Price: Low to High', 'Price: High to Low'];

  @override
  void initState() {
    super.initState();
    selectedLocation = widget.initialLocation ?? 'Location';
    selectedType = widget.initialType ?? 'Type';
    selectedBedrooms = widget.initialBedrooms ?? 'Bedrooms';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomNavBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderSection(),
                    _buildFilterSection(),
                    _buildResultsSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomNavBar() {
    final authService = context.read<AuthService>();
    final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          RichText(
            text: TextSpan(
              style: GoogleFonts.montserrat(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              children: const [
                TextSpan(text: 'Gra', style: TextStyle(color: AppConstants.primaryColor)),
                TextSpan(text: 'von', style: TextStyle(color: Color(0xFF1A2337))),
              ],
            ),
          ),
          
          // Center Links
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  'Home',
                  style: GoogleFonts.montserrat(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 30),
              Text(
                'Properties',
                style: GoogleFonts.montserrat(
                  color: AppConstants.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          // User Profile
          if (currentUser != null)
            FutureBuilder<UserModel?>(
              future: authService.getUserData(currentUser.uid),
              builder: (context, snapshot) {
                final userName = snapshot.data?.fullName ?? 'Kaugi'; // Fallback to Kaugi as requested if data is slow
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: AppConstants.primaryColor,
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : 'K',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      userName,
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFF1A2337),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
                  ],
                );
              },
            )
          else
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Login',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    final propertyService = context.read<PropertyService>();
    return StreamBuilder<List<PropertyModel>>(
      stream: propertyService.getProperties(),
      builder: (context, snapshot) {
        int count = snapshot.data?.length ?? 0;
        return Padding(
          padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'All Properties',
                style: GoogleFonts.montserrat(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A2337),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$count properties available',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildFilterSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Search by property name or description...',
              hintStyle: GoogleFonts.montserrat(color: Colors.grey[400], fontSize: 14),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[100]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[100]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppConstants.primaryColor),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[100]!),
          ),
          child: Row(
            children: [
              Expanded(child: _buildDropdown(selectedLocation, locations, (v) => setState(() => selectedLocation = v!))),
              _divider(),
              Expanded(child: _buildDropdown(selectedType, types, (v) => setState(() => selectedType = v!))),
              _divider(),
              Expanded(child: _buildDropdown(selectedBedrooms, bedroomsList, (v) => setState(() => selectedBedrooms = v!))),
              _divider(),
              Expanded(child: _buildDropdown(selectedSort, sorts, (v) => setState(() => selectedSort = v!))),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedLocation = 'Location';
                    selectedType = 'Type';
                    selectedBedrooms = 'Bedrooms';
                    selectedSort = 'Newest';
                    _searchController.clear();
                    _searchQuery = '';
                  });
                },
                child: Text(
                  'Reset',
                  style: GoogleFonts.montserrat(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _divider() => Container(height: 30, width: 1, color: Colors.grey[200]);

  Widget _buildDropdown(String value, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton<String>(
          value: items.contains(value) ? value : items.first,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          icon: Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey[400]),
        ),
      ),
    );
  }

  Widget _buildResultsSection() {
    final propertyService = context.read<PropertyService>();

    return StreamBuilder<List<PropertyModel>>(
      stream: propertyService.getProperties(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(40),
            child: CircularProgressIndicator(),
          ));
        }

        var properties = snapshot.data ?? [];

        // Apply filters
        if (_searchQuery.isNotEmpty) {
          properties = properties.where((p) => 
            p.title.toLowerCase().contains(_searchQuery.toLowerCase()) || 
            p.description.toLowerCase().contains(_searchQuery.toLowerCase())
          ).toList();
        }
        if (selectedLocation != 'Location') {
          properties = properties.where((p) => p.city.contains(selectedLocation)).toList();
        }
        if (selectedType != 'Type') {
          properties = properties.where((p) => p.type.name.toLowerCase() == selectedType.toLowerCase()).toList();
        }
        if (selectedBedrooms != 'Bedrooms' && selectedBedrooms != 'Any') {
          int count = int.parse(selectedBedrooms.replaceAll('+', ''));
          properties = properties.where((p) => p.bedrooms >= count).toList();
        }

        // Apply sorting
        if (selectedSort == 'Price: Low to High') {
          properties.sort((a, b) => a.price.compareTo(b.price));
        } else if (selectedSort == 'Price: High to Low') {
          properties.sort((a, b) => b.price.compareTo(a.price));
        } else {
          properties.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Showing ${properties.length} results',
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      _viewIcon(Icons.grid_view_rounded, true),
                      const SizedBox(width: 8),
                      _viewIcon(Icons.format_list_bulleted_rounded, false),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  int cols = constraints.maxWidth > 1200 ? 3 : (constraints.maxWidth > 800 ? 2 : 1);
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: properties.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 0,
                      mainAxisExtent: 380,
                    ),
                    itemBuilder: (context, index) {
                      return PropertyCard(
                        property: properties[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PropertyDetailsScreen(property: properties[index]),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _viewIcon(IconData icon, bool active) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: active ? Colors.orange : Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: active ? null : Border.all(color: Colors.grey[200]!),
      ),
      child: Icon(icon, size: 18, color: active ? Colors.white : Colors.grey[400]),
    );
  }
}
