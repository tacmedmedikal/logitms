class Driver {
  final String id;
  final String fullName;
  final String phone;
  final String? email;
  final String licenseNumber;
  final DateTime licenseExpiry;
  final DriverStatus status;
  final String? currentVehicleId;
  final DateTime hireDate;
  final String? address;
  final String? emergencyContact;
  final String? emergencyPhone;

  Driver({
    required this.id,
    required this.fullName,
    required this.phone,
    this.email,
    required this.licenseNumber,
    required this.licenseExpiry,
    required this.status,
    this.currentVehicleId,
    required this.hireDate,
    this.address,
    this.emergencyContact,
    this.emergencyPhone,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      licenseNumber: json['license_number'] as String,
      licenseExpiry: DateTime.parse(json['license_expiry'] as String),
      status: DriverStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => DriverStatus.available,
      ),
      currentVehicleId: json['current_vehicle_id'] as String?,
      hireDate: DateTime.parse(json['hire_date'] as String),
      address: json['address'] as String?,
      emergencyContact: json['emergency_contact'] as String?,
      emergencyPhone: json['emergency_phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'email': email,
      'license_number': licenseNumber,
      'license_expiry': licenseExpiry.toIso8601String(),
      'status': status.name,
      'current_vehicle_id': currentVehicleId,
      'hire_date': hireDate.toIso8601String(),
      'address': address,
      'emergency_contact': emergencyContact,
      'emergency_phone': emergencyPhone,
    };
  }

  bool get isLicenseExpiringSoon {
    final daysUntilExpiry = licenseExpiry.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 30 && daysUntilExpiry > 0;
  }

  bool get isLicenseExpired {
    return licenseExpiry.isBefore(DateTime.now());
  }
}

enum DriverStatus {
  available,
  onTrip,
  onBreak,
  offDuty,
  inactive,
}

extension DriverStatusExtension on DriverStatus {
  String get displayName {
    switch (this) {
      case DriverStatus.available:
        return 'Musait';
      case DriverStatus.onTrip:
        return 'Seferde';
      case DriverStatus.onBreak:
        return 'Molada';
      case DriverStatus.offDuty:
        return 'Mesai Disi';
      case DriverStatus.inactive:
        return 'Pasif';
    }
  }
}
