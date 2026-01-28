import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'GRAVON';
  
  // Colors
  static const Color primaryColor = Color(0xFFFF9800); // Orange
  static const Color secondaryColor = Color(0xFF4CAF50); // Green
  static const Color errorColor = Color(0xFFF44336); // Red
  static const Color darkBlue = Color(0xFF1A2337); // Footer/Hero background
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Colors.white;
  
  // Padding/Margins
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 16.0;
  static const double borderRadius = 12.0;
  
  // Text Styles (can be moved to theme but useful here too)
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // Mock Locations
  static const List<Map<String, String>> locations = [
    {'name': 'Nairobi', 'image': 'https://images.unsplash.com/photo-1585320806297-9794b3e4eeae?w=500&q=80'},
    {'name': 'Mombasa', 'image': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=500&q=80'},
    {'name': 'Nakuru', 'image': 'https://images.unsplash.com/photo-1611002214172-792c1f90b59a?w=500&q=80'},
    {'name': 'Eldoret', 'image': 'https://images.unsplash.com/photo-1516026672322-bc52d61a55d5?w=500&q=80'},
    {'name': 'Kisumu', 'image': 'https://images.unsplash.com/photo-1563298723-dcfebaa392e3?w=500&q=80'},
  ];
}
