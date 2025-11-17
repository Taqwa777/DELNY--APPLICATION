import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
 
class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 
  // جلب بيانات المستخدم
  Future<UserModel?> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }
 
  // تحديث بيانات المستخدم
  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      print('Error updating user data: $e');
      rethrow;
    }
  }
 
  // إضافة/إزالة من المفضلة
  Future<void> toggleFavorite(String userId, String targetUid) async {
    try {
      final userDoc = _firestore.collection('users').doc(userId);
      final user = await getUserData(userId);
 
      if (user?.favorites.contains(targetUid) ?? false) {
        await userDoc.update({
          'favorites': FieldValue.arrayRemove([targetUid])
        });
      } else {
        await userDoc.update({
          'favorites': FieldValue.arrayUnion([targetUid])
        });
      }
    } catch (e) {
      print('Error toggling favorite: $e');
      rethrow;
    }
  }
 
  // جلب الحرفيين حسب المهنة (stream لتحديث البيانات لحظة بلحظة)
  Stream<List<UserModel>> getUsersByCareer(String career) {
    return _firestore
        .collection('users')
        .where('career', isEqualTo: career)
        .where('isServiceProvider', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromMap(doc.data(), doc.id))
            .toList());
  }
 
  // جلب المستخدمين المفضلين
  Future<List<UserModel>> getFavoriteUsers(List<String> favoriteIds) async {
    if (favoriteIds.isEmpty) return [];
 
    try {
      final snapshot = await _firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: favoriteIds)
          .get();
 
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error getting favorite users: $e');
      return [];
    }
  }
 
  // ستريم المفضلة
  Stream<List<String>> getUserFavoritesStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) {
      final data = doc.data() ?? {};
      return List<String>.from(data['favorites'] ?? []);
    });
  }
}