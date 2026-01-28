import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import '../../services/property_service.dart';
import '../../models/property_model.dart';
import '../../widgets/property_card.dart';
import '../property/property_details_screen.dart';
import '../property/properties_screen.dart';
import '../property/add_property_screen.dart';
import '../auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../services/auth_service.dart';
import '../../models/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

class LandingPageView extends StatefulWidget {
  const LandingPageView({super.key});

  @override
  State<LandingPageView> createState() => _LandingPageViewState();
}

class _LandingPageViewState extends State<LandingPageView> {
  String selectedLocation = 'All Locations';
  String selectedType = 'Type';
  String selectedBedrooms = 'Bedrooms';
  String selectedSort = 'Newest';

  final List<String> locations = ['All Locations', 'Nairobi', 'Mombasa', 'Nakuru', 'Eldoret', 'Kisumu'];
  final List<String> types = ['Type', 'Rental', 'Airbnb'];
  final List<String> bedrooms = ['Bedrooms', 'Any', '1+', '2+', '3+', '4+'];
  final List<String> sorts = ['Newest', 'Price: Low to High', 'Price: High to Low'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeroSection(context),
          _buildStatsSection(),
          _buildLocationsSection(),
          _buildFeaturedSection(context),
          _buildWhyChooseUsSection(),
          _buildTestimonialsSection(),
          _buildOwnerCTASection(),
          _buildFooterSection(),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: WaveClipper(),
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppConstants.darkBlue,
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=1200&q=80',
                ),
                fit: BoxFit.cover,
                opacity: 0.3,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo: Gra in orange, von in white
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.montserrat(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        children: const [
                          TextSpan(text: 'Gra', style: TextStyle(color: AppConstants.primaryColor)),
                          TextSpan(text: 'von', style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                    
                    // Center Links: Home and Properties
                    Row(
                      children: [
                        Text(
                          'Home',
                          style: GoogleFonts.montserrat(
                            color: AppConstants.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PropertiesScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Properties',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Right Actions: Login/Profile and List Property
                    Row(
                      children: [
                        _buildUserAction(context),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddPropertyScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppConstants.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'List Property',
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
                  ],
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppConstants.primaryColor.withOpacity(0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: AppConstants.primaryColor, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Kenya\'s Premier Property Platform',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.montserrat(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                    children: [
                      const TextSpan(text: 'Find Your Perfect '),
                      TextSpan(
                        text: 'Home',
                        style: TextStyle(color: AppConstants.primaryColor),
                      ),
                      const TextSpan(text: ' in Kenya'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Discover premium rental apartments and Airbnb properties across Nairobi, Mombasa, and beyond',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                // Wrapped in a SingleChildScrollView to allow the bar to be only as wide as its content
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildDropdown(selectedLocation, locations, (val) => setState(() => selectedLocation = val!)),
                        _buildDropdown(selectedType, types, (val) => setState(() => selectedType = val!)),
                        _buildDropdown(selectedBedrooms, bedrooms, (val) => setState(() => selectedBedrooms = val!)),
                        _buildDropdown(selectedSort, sorts, (val) => setState(() => selectedSort = val!)),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PropertiesScreen(
                                  initialLocation: selectedLocation,
                                  initialType: selectedType,
                                  initialBedrooms: selectedBedrooms,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.primaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.search, color: Colors.white, size: 20),
                              const SizedBox(width: 10),
                              Text(
                                'Search',
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserAction(BuildContext context) {
    if (Firebase.apps.isEmpty) return _buildLoginButton(context);

    final authService = context.read<AuthService>();
    final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      return FutureBuilder<UserModel?>(
        future: authService.getUserData(currentUser.uid),
        builder: (context, snapshot) {
          final userName = snapshot.data?.fullName ?? 'Kaugi';
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
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.white70),
            ],
          );
        },
      );
    } else {
      return _buildLoginButton(context);
    }
  }

  Widget _buildLoginButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      },
      child: Text(
        'Login',
        style: GoogleFonts.montserrat(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildDropdown(String value, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonHideUnderline(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: DropdownButton<String>(
          value: items.contains(value) ? value : items.first,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          icon: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey[400]),
          ),
          style: GoogleFonts.montserrat(color: Colors.black87),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            _buildStatCard(Icons.business_outlined, '500+', 'Properties Listed'),
            const SizedBox(width: 16),
            _buildStatCard(Icons.location_on_outlined, '5', 'Major Cities'),
            const SizedBox(width: 16),
            _buildStatCard(Icons.home_outlined, '1000+', 'Happy Tenants'),
            const SizedBox(width: 16),
            _buildStatCard(Icons.verified_user_outlined, '100%', 'Verified Listings'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppConstants.primaryColor, size: 32),
          const SizedBox(height: 16),
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A2337),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Explore Locations',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.darkBlue,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Browse properties in Kenya\'s top cities',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: AppConstants.locations.map((location) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PropertiesScreen(initialLocation: location['name']),
                    ),
                  );
                },
                child: Container(
                  width: 140,
                  height: 140,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(location['image']!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      location['name']!,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildFeaturedSection(BuildContext context) {
    final propertyService = context.read<PropertyService>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Featured Properties',
                    style: GoogleFonts.montserrat(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Hand-picked properties available now',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PropertiesScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey[300]!),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: Row(
                  children: [
                    Text(
                      'View All',
                      style: GoogleFonts.montserrat(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 16, color: Colors.black54),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        StreamBuilder<List<PropertyModel>>(
          stream: propertyService.getProperties(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final properties = snapshot.data ?? [];
            if (properties.isEmpty) {
              return const Center(child: Text('No properties found'));
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Determine number of columns based on screen width
                  int crossAxisCount = constraints.maxWidth > 900 ? 3 : (constraints.maxWidth > 600 ? 2 : 1);
                  
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: properties.length > 6 ? 6 : properties.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 10,
                      mainAxisExtent: 380, // Fixed height for consistency
                    ),
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
              ),
            );
          },
        ),
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildOwnerCTASection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: const BoxDecoration(
        color: AppConstants.primaryColor,
      ),
      child: Column(
        children: [
          Text(
            'Are You a Property Owner?',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'List your property on GRAVON and reach thousands of potential tenants',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPropertyScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppConstants.primaryColor,
              minimumSize: const Size(200, 50),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('List Your Property', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSection() {
    return Container(
      width: double.infinity,
      color: AppConstants.darkBlue,
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.home_work, color: AppConstants.primaryColor, size: 24),
              const SizedBox(width: 8),
              Text(
                'Gravon',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Kenya\'s premier property listing platform for rentals and Airbnb properties.',
            style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Links',
                      style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _footerLink('Browse Properties'),
                    _footerLink('List Property'),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Locations',
                      style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _footerLink('Nairobi'),
                    _footerLink('Mombasa'),
                    _footerLink('Nakuru'),
                    _footerLink('Eldoret'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Contact',
            style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _footerLink('info@gravon.co.ke'),
          _footerLink('+254 700 000 000'),
          const SizedBox(height: 32),
          Text(
            'Follow Us',
            style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _socialIcon(FontAwesomeIcons.facebookF),
              const SizedBox(width: 20),
              _socialIcon(FontAwesomeIcons.twitter),
              const SizedBox(width: 20),
              _socialIcon(FontAwesomeIcons.instagram),
              const SizedBox(width: 20),
              _socialIcon(FontAwesomeIcons.linkedinIn),
            ],
          ),
          const SizedBox(height: 40),
          const Divider(color: Colors.white24),
          const SizedBox(height: 20),
          Center(
            child: Text(
              '© 2026 GRAVON. All rights reserved.',
              style: GoogleFonts.montserrat(color: Colors.white38, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _footerLink(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 14),
      ),
    );
  }

  Widget _socialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 16),
    );
  }

  Widget _buildWhyChooseUsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            'Why Choose GRAVON?',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppConstants.darkBlue,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'We provide the most seamless property hunting experience in Kenya',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 48),
          Row(
            children: [
              Expanded(
                child: _buildChoiceCard(
                  Icons.verified_user_rounded,
                  'Verified Listings',
                  'Every property on our platform is thoroughly verified for your safety.',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildChoiceCard(
                  Icons.flash_on_rounded,
                  'Instant Booking',
                  'Book your next Airbnb or rental viewing with just a few clicks.',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildChoiceCard(
                  Icons.support_agent_rounded,
                  '24/7 Support',
                  'Our dedicated team is always here to help you with any inquiries.',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildChoiceCard(
                  Icons.account_balance_wallet_rounded,
                  'Transparent Pricing',
                  'No hidden fees. What you see is exactly what you pay.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceCard(IconData icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppConstants.backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppConstants.primaryColor, size: 28),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.darkBlue,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialsSection() {
    final List<Map<String, String>> testimonials = [
      {
        'name': 'Sarah Wangari',
        'role': 'Tenant in Kilimani',
        'content': 'Finding an apartment in Nairobi was always a headache until I used Gravon. The verification process gave me peace of mind!',
        'image': 'https://i.pravatar.cc/150?u=sarah',
      },
      {
        'name': 'James Omondi',
        'role': 'Airbnb Guest',
        'content': 'Super easy to use. I booked a stay in Mombasa for my holiday and everything was exactly as shown in the pictures.',
        'image': 'https://i.pravatar.cc/150?u=james',
      },
      {
        'name': 'Faith Mutua',
        'role': 'Property Owner',
        'content': 'As an owner, listing my properties was seamless. I started getting inquiries within the first 24 hours!',
        'image': 'https://i.pravatar.cc/150?u=faith',
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      color: AppConstants.backgroundColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(
                  'What Our Users Say',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.darkBlue,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Join thousands of happy users finding their homes on GRAVON',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: testimonials.map((t) {
                return Container(
                  width: 320,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(t['image']!),
                            radius: 25,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t['name']!,
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  t['role']!,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.format_quote, color: AppConstants.primaryColor, size: 32),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        t['content']!,
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 40);
    
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    
    var secondControlPoint = Offset(size.width - (size.width / 3.25), size.height - 65);
    var secondEndPoint = Offset(size.width, size.height - 20);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);
    
    path.lineTo(size.width, size.height - 20);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
