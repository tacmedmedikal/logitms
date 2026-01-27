class Vehicle {
  final String id;
  final String plate;
  final String brand;
  final String model;
  final int year;
  final VehicleType type;
  final VehicleStatus status;
  final double? capacity;
  final String? currentDriverId;
  final DateTime? lastMaintenanceDate;
  final DateTime? nextMaintenanceDate;
  final double? currentKm;

  Vehicle({
    required this.id,
    required this.plate,
    required this.brand,
    required this.model,
    required this.year,
    required this.type,
    required this.status,
    this.capacity,
    this.currentDriverId,
    this.lastMaintenanceDate,
    this.nextMaintenanceDate,
    this.currentKm,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as String,
      plate: json['plate'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      year: json['year'] as int,
      type: VehicleType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => VehicleType.truck,
      ),
      status: VehicleStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => VehicleStatus.available,
      ),
      capacity: (json['capacity'] as num?)?.toDouble(),
      currentDriverId: json['current_driver_id'] as String?,
      lastMaintenanceDate: json['last_maintenance_date'] != null
          ? DateTime.parse(json['last_maintenance_date'] as String)
          : null,
      nextMaintenanceDate: json['next_maintenance_date'] != null
          ? DateTime.parse(json['next_maintenance_date'] as String)
          : null,
      currentKm: (json['current_km'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plate': plate,
      'brand': brand,
      'model': model,
      'year': year,
      'type': type.name,
      'status': status.name,
      'capacity': capacity,
      'current_driver_id': currentDriverId,
      'last_maintenance_date': lastMaintenanceDate?.toIso8601String(),
      'next_maintenance_date': nextMaintenanceDate?.toIso8601String(),
      'current_km': currentKm,
    };
  }

  String get fullName => '$brand $model ($plate)';
}

enum VehicleType {
  truck,
  van,
  pickup,
  trailer,
}

extension VehicleTypeExtension on VehicleType {
  String get displayName {
    switch (this) {
      case VehicleType.truck:
        return 'Tir';
      case VehicleType.van:
        return 'Kamyonet';
      case VehicleType.pickup:
        return 'Pikap';
      case VehicleType.trailer:
        return 'Dorse';
    }
  }
}

enum VehicleStatus {
  available,
  inUse,
  maintenance,
  outOfService,
}

extension VehicleStatusExtension on VehicleStatus {
  String get displayName {
    switch (this) {
      case VehicleStatus.available:
        return 'Musait';
      case VehicleStatus.inUse:
        return 'Kullanımda';
      case VehicleStatus.maintenance:
        return 'Bakımda';
      case VehicleStatus.outOfService:
        return 'Devre Disi';
    }
  }
}
