import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _roleKey = 'userRole';
  static const _emailKey = 'userEmail';
  static const _cartKey = 'cart';

  static String? _cachedRole;

  static String? get userRole => _cachedRole;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _cachedRole = prefs.getString(_roleKey);
  }

  static Future<void> setUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_roleKey, role);
    _cachedRole = role;
  }

  static Future<void> setUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  static Future<void> clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_roleKey);
    await prefs.remove(_emailKey);
    _cachedRole = null;
  }

  // Cart persistence
  static Future<List<Map<String, dynamic>>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = prefs.getString(_cartKey);
    if (cartString == null) return [];
    final List<dynamic> decoded = jsonDecode(cartString);
    return decoded.cast<Map<String, dynamic>>();
  }

  static Future<void> saveCart(List<Map<String, dynamic>> cart) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cartKey, jsonEncode(cart));
  }
}