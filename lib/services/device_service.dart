import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceService {
  static const String _registeredDeviceKey = 'registered_device_id';
  static const String _pendingApprovalKey = 'pending_device_approval';

  static final DeviceService _instance = DeviceService._internal();
  factory DeviceService() => _instance;
  DeviceService._internal();

  String? _currentDeviceId;

  /// Get unique device identifier
  Future<String> getDeviceId() async {
    if (_currentDeviceId != null) return _currentDeviceId!;

    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      _currentDeviceId = androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      _currentDeviceId = iosInfo.identifierForVendor ?? 'unknown_ios';
    } else {
      _currentDeviceId = 'unknown_platform';
    }

    return _currentDeviceId!;
  }

  /// Check if any device is registered
  Future<bool> hasRegisteredDevice() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_registeredDeviceKey);
  }

  /// Check if current device is the registered one
  Future<bool> isCurrentDeviceRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    final registeredId = prefs.getString(_registeredDeviceKey);

    if (registeredId == null) return false;

    final currentId = await getDeviceId();
    return registeredId == currentId;
  }

  /// Register current device (first time setup)
  Future<void> registerCurrentDevice() async {
    final prefs = await SharedPreferences.getInstance();
    final deviceId = await getDeviceId();
    await prefs.setString(_registeredDeviceKey, deviceId);
    await prefs.remove(_pendingApprovalKey);
  }

  /// Request admin approval for new device
  Future<void> requestDeviceApproval() async {
    final prefs = await SharedPreferences.getInstance();
    final deviceId = await getDeviceId();
    await prefs.setString(_pendingApprovalKey, deviceId);
  }

  /// Check if there's a pending approval request
  Future<bool> hasPendingApproval() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_pendingApprovalKey);
  }

  /// Admin approves the pending device (replaces old device)
  Future<void> approveNewDevice() async {
    final prefs = await SharedPreferences.getInstance();
    final pendingId = prefs.getString(_pendingApprovalKey);

    if (pendingId != null) {
      await prefs.setString(_registeredDeviceKey, pendingId);
      await prefs.remove(_pendingApprovalKey);
    }
  }

  /// Clear all device registration (for testing)
  Future<void> clearRegistration() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_registeredDeviceKey);
    await prefs.remove(_pendingApprovalKey);
  }

  /// Get registered device ID (for display)
  Future<String?> getRegisteredDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_registeredDeviceKey);
  }
}
