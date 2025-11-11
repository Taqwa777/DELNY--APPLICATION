import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;

  final UserService _userService = UserService();
  List<String> favoriteIds = [];

  String? get uid => _user?.uid;

  // جلب بيانات المستخدم
  Future<void> fetchUserData(String userId) async {
    _user = await _userService.getUserData(userId);
    favoriteIds = _user?.favorites ?? [];
    notifyListeners();
  }

  // التحقق إذا كان بالمفضلة
  bool isFavorite(String targetUid) => favoriteIds.contains(targetUid);

  // تبديل المفضلة
  Future<void> toggleFavorite(String targetUid) async {
    if (_user == null) return;

    await _userService.toggleFavorite(_user!.uid, targetUid);

    if (isFavorite(targetUid)) {
      favoriteIds.remove(targetUid);
    } else {
      favoriteIds.add(targetUid);
    }

    // تحديث الـ user model
    _user = _user!.copyWith(favorites: List.from(favoriteIds));
    notifyListeners();
  }

  // تحديث الملف الشخصي
  Future<void> updateProfile(Map<String, dynamic> updates) async {
    if (_user == null) return;

    await _userService.updateUserData(_user!.uid, updates);

    // تحديث الـ user model محلياً
    _user = _user!.copyWith(
      name: updates['name'] ?? _user!.name,
      phone: updates['phone'] ?? _user!.phone,
      career: updates['career'] ?? _user!.career,
      location: updates['location'] ?? _user!.location,
      experience: updates['experience'] ?? _user!.experience,
      isServiceProvider: updates['isServiceProvider'] ?? _user!.isServiceProvider,
    );

    notifyListeners();
  }

  // ستريم المفضلة
  Stream<List<String>> favoriteStream() {
    if (_user == null) return const Stream.empty();
    return _userService.getUserFavoritesStream(_user!.uid);
  }

  // تنظيف البيانات عند تسجيل الخروج
  void clearData() {
    _user = null;
    favoriteIds.clear();
    notifyListeners();
  }
}