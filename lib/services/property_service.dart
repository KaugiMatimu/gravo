import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/property_model.dart';

class PropertyService {
  FirebaseFirestore get _db {
    if (Firebase.apps.isEmpty) {
      throw Exception('Firebase not initialized. Please run "flutterfire configure".');
    }
    return FirebaseFirestore.instance;
  }

  // Add property
  Future<void> addProperty(PropertyModel property) async {
    await _db.collection('properties').add(property.toMap());
  }

  // Update property
  Future<void> updateProperty(String id, Map<String, dynamic> data) async {
    await _db.collection('properties').doc(id).update(data);
  }

  // Delete property
  Future<void> deleteProperty(String id) async {
    await _db.collection('properties').doc(id).delete();
  }

  // Get all properties
  Stream<List<PropertyModel>> getProperties({String? sortBy, bool descending = true}) {
    try {
      if (Firebase.apps.isEmpty) return Stream.value([]);
      
      Query query = _db.collection('properties').where('isAvailable', isEqualTo: true);
      
      if (sortBy != null) {
        query = query.orderBy(sortBy, descending: descending);
      } else {
        query = query.orderBy('createdAt', descending: true);
      }

      return query.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => PropertyModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      });
    } catch (e) {
      return Stream.value([]);
    }
  }

  // Get properties by landlord
  Stream<List<PropertyModel>> getLandlordProperties(String landlordId) {
    try {
      if (Firebase.apps.isEmpty) return Stream.value([]);
      return _db
          .collection('properties')
          .where('landlordId', isEqualTo: landlordId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => PropertyModel.fromMap(doc.data(), doc.id))
            .toList();
      });
    } catch (e) {
      return Stream.value([]);
    }
  }
}
