class Shipment {
  final String id;
  final String trackingNumber;
  final String origin;
  final String destination;
  final ShipmentStatus status;
  final DateTime createdAt;
  final DateTime? estimatedDelivery;
  final DateTime? actualDelivery;
  final String? vehicleId;
  final String? driverId;
  final String? customerName;
  final String? customerPhone;
  final double? weight;
  final String? notes;

  Shipment({
    required this.id,
    required this.trackingNumber,
    required this.origin,
    required this.destination,
    required this.status,
    required this.createdAt,
    this.estimatedDelivery,
    this.actualDelivery,
    this.vehicleId,
    this.driverId,
    this.customerName,
    this.customerPhone,
    this.weight,
    this.notes,
  });

  factory Shipment.fromJson(Map<String, dynamic> json) {
    return Shipment(
      id: json['id'] as String,
      trackingNumber: json['tracking_number'] as String,
      origin: json['origin'] as String,
      destination: json['destination'] as String,
      status: ShipmentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ShipmentStatus.pending,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      estimatedDelivery: json['estimated_delivery'] != null
          ? DateTime.parse(json['estimated_delivery'] as String)
          : null,
      actualDelivery: json['actual_delivery'] != null
          ? DateTime.parse(json['actual_delivery'] as String)
          : null,
      vehicleId: json['vehicle_id'] as String?,
      driverId: json['driver_id'] as String?,
      customerName: json['customer_name'] as String?,
      customerPhone: json['customer_phone'] as String?,
      weight: (json['weight'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tracking_number': trackingNumber,
      'origin': origin,
      'destination': destination,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'estimated_delivery': estimatedDelivery?.toIso8601String(),
      'actual_delivery': actualDelivery?.toIso8601String(),
      'vehicle_id': vehicleId,
      'driver_id': driverId,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'weight': weight,
      'notes': notes,
    };
  }

  Shipment copyWith({
    String? id,
    String? trackingNumber,
    String? origin,
    String? destination,
    ShipmentStatus? status,
    DateTime? createdAt,
    DateTime? estimatedDelivery,
    DateTime? actualDelivery,
    String? vehicleId,
    String? driverId,
    String? customerName,
    String? customerPhone,
    double? weight,
    String? notes,
  }) {
    return Shipment(
      id: id ?? this.id,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      actualDelivery: actualDelivery ?? this.actualDelivery,
      vehicleId: vehicleId ?? this.vehicleId,
      driverId: driverId ?? this.driverId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      weight: weight ?? this.weight,
      notes: notes ?? this.notes,
    );
  }
}

enum ShipmentStatus {
  pending,
  assigned,
  pickedUp,
  inTransit,
  delivered,
  cancelled,
}

extension ShipmentStatusExtension on ShipmentStatus {
  String get displayName {
    switch (this) {
      case ShipmentStatus.pending:
        return 'Beklemede';
      case ShipmentStatus.assigned:
        return 'Atandi';
      case ShipmentStatus.pickedUp:
        return 'Alindi';
      case ShipmentStatus.inTransit:
        return 'Yolda';
      case ShipmentStatus.delivered:
        return 'Teslim Edildi';
      case ShipmentStatus.cancelled:
        return 'Iptal';
    }
  }
}
