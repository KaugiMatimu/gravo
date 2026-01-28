enum PropertyType { rental, airbnb }

class PropertyModel {
  final String id;
  final String landlordId;
  final String title;
  final String description;
  final double price;
  final String city;
  final String? neighborhood;
  final PropertyType type;
  final List<String> imageUrls;
  final int bedrooms;
  final int bathrooms;
  final bool isAvailable; // Admin/Landlord toggle
  final bool isBooked; // For Airbnb states
  final DateTime createdAt;
  final DateTime updatedAt;

  PropertyModel({
    required this.id,
    required this.landlordId,
    required this.title,
    required this.description,
    required this.price,
    required this.city,
    this.neighborhood,
    required this.type,
    required this.imageUrls,
    required this.bedrooms,
    required this.bathrooms,
    this.isAvailable = true,
    this.isBooked = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'landlordId': landlordId,
      'title': title,
      'description': description,
      'price': price,
      'city': city,
      'neighborhood': neighborhood,
      'type': type.toString().split('.').last,
      'imageUrls': imageUrls,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'isAvailable': isAvailable,
      'isBooked': isBooked,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory PropertyModel.fromMap(Map<String, dynamic> map, String id) {
    return PropertyModel(
      id: id,
      landlordId: map['landlordId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      city: map['city'] ?? '',
      neighborhood: map['neighborhood'],
      type: PropertyType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
        orElse: () => PropertyType.rental,
      ),
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      bedrooms: map['bedrooms'] ?? 0,
      bathrooms: map['bathrooms'] ?? 0,
      isAvailable: map['isAvailable'] ?? true,
      isBooked: map['isBooked'] ?? false,
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
