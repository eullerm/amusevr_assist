// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Device {
  String id;
  int deviceKey;
  String name;
  int boxStatus;
  bool isOnline;
  bool isBatteryCharging;
  int batteryLevelPercent;

  Device({
    required this.id,
    required this.deviceKey,
    required this.name,
    required this.boxStatus,
    required this.isOnline,
    required this.isBatteryCharging,
    required this.batteryLevelPercent,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'device_key': deviceKey,
      'name': name,
      'box_status': boxStatus,
      'is_online': isOnline,
      'is_battery_charging': isBatteryCharging,
      'batteryLevelPercent': batteryLevelPercent,
    };
  }

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      id: map['id'] as String,
      deviceKey: map['device_key'] as int,
      name: map['name'] as String,
      boxStatus: map['box_status'] as int,
      isOnline: map['is_online'] as bool,
      isBatteryCharging: map['is_battery_charging'] as bool,
      batteryLevelPercent: map['battery_level_percent'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Device.fromJson(String source) => Device.fromMap(json.decode(source) as Map<String, dynamic>);
}
