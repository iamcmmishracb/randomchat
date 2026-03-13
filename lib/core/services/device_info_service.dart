import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';

/// 📱 Device Info Service
/// NOTE: IMEI collection has been removed — it violates Google Play policy.
/// We use the Android device ID or iOS identifierForVendor instead,
/// which uniquely identifies the device without requiring special permissions.

class DeviceInfo {
  final String deviceId;
  final String? deviceModel;
  final String? deviceManufacturer;
  final double? latitude;
  final double? longitude;
  final double? accuracy;

  DeviceInfo({
    required this.deviceId,
    this.deviceModel,
    this.deviceManufacturer,
    this.latitude,
    this.longitude,
    this.accuracy,
  });
}

class DeviceInfoService {
  static final DeviceInfoService _instance = DeviceInfoService._internal();
  factory DeviceInfoService() => _instance;
  DeviceInfoService._internal();

  final _deviceInfo = DeviceInfoPlugin();

  Future<DeviceInfo> getDeviceInfo() async {
    try {
      final deviceId           = await _getDeviceId();
      final deviceModel        = await _getDeviceModel();
      final deviceManufacturer = await _getDeviceManufacturer();
      final position           = await _getLocation();

      _print('Device ID: $deviceId  Model: $deviceModel  Mfr: $deviceManufacturer');
      if (position != null) _print('Location: ${position.latitude}, ${position.longitude}');

      return DeviceInfo(
        deviceId:           deviceId,
        deviceModel:        deviceModel,
        deviceManufacturer: deviceManufacturer,
        latitude:           position?.latitude,
        longitude:          position?.longitude,
        accuracy:           position?.accuracy,
      );
    } catch (e) {
      _print('❌ Error collecting device info: $e');
      rethrow;
    }
  }

  Future<String> _getDeviceId() async {
    try {
      if (Platform.isAndroid) {
        final info = await _deviceInfo.androidInfo;
        return info.id; // Android device ID (no special permission needed)
      } else if (Platform.isIOS) {
        final info = await _deviceInfo.iosInfo;
        return info.identifierForVendor ?? 'ios-unknown';
      } else {
        return _generateFallbackId();
      }
    } catch (e) {
      _print('⚠️ Error getting device ID: $e');
      return _generateFallbackId();
    }
  }

  Future<String?> _getDeviceModel() async {
    try {
      if (Platform.isAndroid) {
        return (await _deviceInfo.androidInfo).model;
      } else if (Platform.isIOS) {
        return (await _deviceInfo.iosInfo).model;
      }
      return 'browser';
    } catch (e) {
      _print('⚠️ Error getting device model: $e');
      return null;
    }
  }

  Future<String?> _getDeviceManufacturer() async {
    try {
      if (Platform.isAndroid) {
        return (await _deviceInfo.androidInfo).manufacturer;
      } else if (Platform.isIOS) {
        return 'Apple';
      }
      return 'browser';
    } catch (e) {
      _print('⚠️ Error getting manufacturer: $e');
      return null;
    }
  }

  Future<Position?> _getLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        _print('⚠️ Location permission denied permanently');
        return null;
      }
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
          timeLimit: const Duration(seconds: 10),
        );
      }
      return null;
    } catch (e) {
      _print('⚠️ Error getting location: $e');
      return null;
    }
  }

  /// Simple fallback ID for web/desktop (not iOS/Android)
  String _generateFallbackId() {
    final now = DateTime.now().millisecondsSinceEpoch;
    return 'web-$now';
  }

  void _print(String message) => print('📱 DeviceInfo: $message');
}
