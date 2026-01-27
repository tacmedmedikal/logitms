import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';
import '../models/driver.dart';

class DriversScreen extends StatefulWidget {
  const DriversScreen({super.key});

  @override
  State<DriversScreen> createState() => _DriversScreenState();
}

class _DriversScreenState extends State<DriversScreen> {
  final _searchController = TextEditingController();
  DriverStatus? _selectedFilter;

  // Mock data
  final List<Driver> _allDrivers = [
    Driver(
      id: '1',
      fullName: 'Ahmet Yilmaz',
      phone: '0532 111 2233',
      email: 'ahmet@logitms.com',
      licenseNumber: 'B-123456',
      licenseExpiry: DateTime.now().add(const Duration(days: 365)),
      status: DriverStatus.onTrip,
      hireDate: DateTime(2020, 5, 15),
    ),
    Driver(
      id: '2',
      fullName: 'Mehmet Demir',
      phone: '0533 222 3344',
      email: 'mehmet@logitms.com',
      licenseNumber: 'B-234567',
      licenseExpiry: DateTime.now().add(const Duration(days: 30)),
      status: DriverStatus.available,
      hireDate: DateTime(2021, 3, 10),
    ),
    Driver(
      id: '3',
      fullName: 'Ali Kaya',
      phone: '0534 333 4455',
      email: 'ali@logitms.com',
      licenseNumber: 'B-345678',
      licenseExpiry: DateTime.now().add(const Duration(days: 180)),
      status: DriverStatus.onBreak,
      hireDate: DateTime(2019, 8, 20),
    ),
    Driver(
      id: '4',
      fullName: 'Veli Ozturk',
      phone: '0535 444 5566',
      email: 'veli@logitms.com',
      licenseNumber: 'B-456789',
      licenseExpiry: DateTime.now().add(const Duration(days: 500)),
      status: DriverStatus.available,
      hireDate: DateTime(2022, 1, 5),
    ),
    Driver(
      id: '5',
      fullName: 'Hasan Celik',
      phone: '0536 555 6677',
      email: 'hasan@logitms.com',
      licenseNumber: 'B-567890',
      licenseExpiry: DateTime.now().subtract(const Duration(days: 10)),
      status: DriverStatus.inactive,
      hireDate: DateTime(2018, 11, 30),
    ),
  ];

  List<Driver> get _filteredDrivers {
    var drivers = _allDrivers;

    if (_selectedFilter != null) {
      drivers = drivers.where((d) => d.status == _selectedFilter).toList();
    }

    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      drivers = drivers.where((d) {
        return d.fullName.toLowerCase().contains(query) ||
            d.phone.contains(query) ||
            d.licenseNumber.toLowerCase().contains(query);
      }).toList();
    }

    return drivers;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Suruculer'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _showAddDriverSheet,
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Search and Filter
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CupertinoSearchTextField(
                    controller: _searchController,
                    placeholder: 'Surucu ara...',
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  _buildFilterChips(),
                ],
              ),
            ),

            // Driver List
            Expanded(
              child: _filteredDrivers.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredDrivers.length,
                      itemBuilder: (context, index) {
                        return _buildDriverCard(_filteredDrivers[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(null, 'Tumu'),
          _buildFilterChip(DriverStatus.available, 'Musait'),
          _buildFilterChip(DriverStatus.onTrip, 'Seferde'),
          _buildFilterChip(DriverStatus.onBreak, 'Molada'),
          _buildFilterChip(DriverStatus.inactive, 'Pasif'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(DriverStatus? status, String label) {
    final isSelected = _selectedFilter == status;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() => _selectedFilter = status),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? CupertinoColors.white : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.person_2,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Surucu bulunamadi',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverCard(Driver driver) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => _showDriverDetails(driver),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.systemGrey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _getStatusColor(driver.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Center(
                  child: Text(
                    _getInitials(driver.fullName),
                    style: TextStyle(
                      color: _getStatusColor(driver.status),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          driver.fullName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (driver.isLicenseExpired) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Ehliyet Suresi Doldu',
                              style: TextStyle(
                                color: AppColors.error,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ] else if (driver.isLicenseExpiringSoon) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Ehliyet Bitmek Uzere',
                              style: TextStyle(
                                color: AppColors.warning,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      driver.phone,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ehliyet: ${driver.licenseNumber}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(driver.status),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  Widget _buildStatusBadge(DriverStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          color: _getStatusColor(status),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getStatusColor(DriverStatus status) {
    switch (status) {
      case DriverStatus.available:
        return AppColors.success;
      case DriverStatus.onTrip:
        return AppColors.primary;
      case DriverStatus.onBreak:
        return AppColors.warning;
      case DriverStatus.offDuty:
        return AppColors.textSecondary;
      case DriverStatus.inactive:
        return AppColors.error;
    }
  }

  void _showDriverDetails(Driver driver) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: _getStatusColor(driver.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Center(
                          child: Text(
                            _getInitials(driver.fullName),
                            style: TextStyle(
                              color: _getStatusColor(driver.status),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              driver.fullName,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            _buildStatusBadge(driver.status),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildDetailRow('Telefon', driver.phone),
                  _buildDetailRow('E-posta', driver.email ?? '-'),
                  _buildDetailRow('Ehliyet No', driver.licenseNumber),
                  _buildDetailRow(
                    'Ehliyet Bitis',
                    DateFormat('dd.MM.yyyy').format(driver.licenseExpiry),
                    valueColor: driver.isLicenseExpired
                        ? AppColors.error
                        : driver.isLicenseExpiringSoon
                            ? AppColors.warning
                            : null,
                  ),
                  _buildDetailRow(
                    'Ise Baslama',
                    DateFormat('dd.MM.yyyy').format(driver.hireDate),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: CupertinoButton(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Duzenle'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CupertinoButton(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(12),
                          onPressed: () {
                            Navigator.pop(context);
                            _callDriver(driver.phone);
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.phone,
                                color: CupertinoColors.white,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text('Ara'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _callDriver(String phone) {
    // In a real app, this would open the phone dialer
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Arama'),
        content: Text('$phone numarasi aranacak'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Iptal'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Ara'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showAddDriverSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Yeni Surucu',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildTextField('Ad Soyad', 'Ahmet Yilmaz'),
                    const SizedBox(height: 16),
                    _buildTextField('Telefon', '0532 123 4567'),
                    const SizedBox(height: 16),
                    _buildTextField('E-posta', 'ahmet@example.com'),
                    const SizedBox(height: 16),
                    _buildTextField('Ehliyet No', 'B-123456'),
                    const SizedBox(height: 16),
                    _buildTextField('Ehliyet Bitis', '01.01.2026'),
                    const SizedBox(height: 16),
                    _buildTextField('Adres', 'Istanbul, Turkiye'),
                    const SizedBox(height: 16),
                    _buildTextField('Acil Durum Kisi', 'Ayse Yilmaz'),
                    const SizedBox(height: 16),
                    _buildTextField('Acil Durum Tel', '0533 987 6543'),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton.filled(
                        borderRadius: BorderRadius.circular(12),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Surucu Ekle'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        CupertinoTextField(
          placeholder: placeholder,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
        ),
      ],
    );
  }
}
