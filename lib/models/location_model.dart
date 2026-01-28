class LocationModel {
  final String id;
  final String name;
  final bool isActive;
  final List<String> neighborhoods;

  LocationModel({
    required this.id,
    required this.name,
    this.isActive = true,
    this.neighborhoods = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isActive': isActive,
      'neighborhoods': neighborhoods,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map, String id) {
    return LocationModel(
      id: id,
      name: map['name'] ?? '',
      isActive: map['isActive'] ?? true,
      neighborhoods: List<String>.from(map['neighborhoods'] ?? []),
    );
  }
}
