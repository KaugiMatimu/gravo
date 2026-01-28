import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/location_model.dart';

class LocationService {
  FirebaseFirestore get _db {
    if (Firebase.apps.isEmpty) {
      throw Exception('Firebase not initialized. Please run "flutterfire configure".');
    }
    return FirebaseFirestore.instance;
  }

  // Fallback initial locations
  final List<LocationModel> _fallbackLocations = [
    LocationModel(id: '1', name: 'Nairobi'),
    LocationModel(id: '2', name: 'Mombasa'),
    LocationModel(id: '3', name: 'Nakuru'),
    LocationModel(id: '4', name: 'Eldoret'),
    LocationModel(id: '5', name: 'Kisumu'),
  ];

  Stream<List<LocationModel>> getActiveLocations() {
    try {
      if (Firebase.apps.isEmpty) return Stream.value(_fallbackLocations);
      
      return _db
          .collection('locations')
          .where('isActive', isEqualTo: true)
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isEmpty) return _fallbackLocations;
        return snapshot.docs
            .map((doc) => LocationModel.fromMap(doc.data(), doc.id))
            .toList();
      });
    } catch (e) {
      return Stream.value(_fallbackLocations);
    }
  }

  // Admin method to add location
  Future<void> addLocation(LocationModel location) async {
    await _db.collection('locations').add(location.toMap());
  }
}
