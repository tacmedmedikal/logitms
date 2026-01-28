import 'package:flutter/cupertino.dart';
import '../constants/app_colors.dart';
import '../models/vehicle.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  final _searchController = TextEditingController();
  VehicleStatus? _selectedFilter;

  // Mock data
  final List<Vehicle> _allVehicles = [
    Vehicle(
      id: '1',
      plate: '34 ABC 123',
      brand: 'Mercedes',
      model: 'Actros',
      year: 2022,
      type: VehicleType.truck,
      status: VehicleStatus.inUse,
      capacity: 25000,
      currentKm: 45000,
    ),
    Vehicle(
      id: '2',
      plate: '06 XYZ 456',
      brand: 'Volvo',
      model: 'FH16',
      year: 2021,
      type: VehicleType.truck,
      status: VehicleStatus.available,
      capacity: 30000,
      currentKm: 78000,
    ),
    Vehicle(
      id: '3',
      plate: '35 DEF 789',
      brand: 'Ford',
      model: 'Transit',
      year: 2023,
      type: VehicleType.van,
      status: VehicleStatus.maintenance,
      capacity: 3500,
      currentKm: 12000,
    ),
    Vehicle(
      id: '4',
      plate: '07 GHI 012',
      brand: 'Scania',
      model: 'R500',
      year: 2020,
      type: VehicleType.truck,
      status: VehicleStatus.available,
      capacity: 28000,
      currentKm: 120000,
    ),
    Vehicle(
      id: '5',
      plate: '16 JKL 345',
      brand: 'MAN',
      model: 'TGX',
      year: 2022,
      type: VehicleType.truck,
      status: VehicleStatus.inUse,
      capacity: 26000,
      currentKm: 55000,
    ),
  ];

  List<Vehicle> get _filteredVehicles {
    var vehicles = _allVehicles;

    if (_selectedFilter != null) {
      vehicles = vehicles.where((v) => v.status == _selectedFilter).toList();
    }

    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      vehicles = vehicles.where((v) {
        return v.plate.toLowerCase().contains(query) ||
            v.brand.toLowerCase().contains(query) ||
            v.model.toLowerCase().contains(query);
      }).toList();
    }

    return vehicles;
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
        middle: const Text('Araclar'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _showAddVehicleSheet,
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
                    placeholder: 'Arac ara...',
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  _buildFilterChips(),
                ],
              ),
            ),

            // Vehicle List
            Expanded(
              child: _filteredVehicles.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredVehicles.length,
                      itemBuilder: (context, index) {
                        return _buildVehicleCard(_filteredVehicles[index]);
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
          _buildFilterChip(VehicleStatus.available, 'Musait'),
          _buildFilterChip(VehicleStatus.inUse, 'Kulanimda'),
          _buildFilterChip(VehicleStatus.maintenance, 'Bakimda'),
          _buildFilterChip(VehicleStatus.outOfService, 'Devre Disi'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(VehicleStatus? status, String label) {
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
            CupertinoIcons.car_detailed,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Arac bulunamadi',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(Vehicle vehicle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => _showVehicleDetails(vehicle),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.systemGrey.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _getStatusColor(vehicle.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getVehicleIcon(vehicle.type),
                  color: _getStatusColor(vehicle.status),
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle.plate,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${vehicle.brand} ${vehicle.model}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          vehicle.type.displayName,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const Text(
                          ' • ',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        Text(
                          '${vehicle.year}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(vehicle.status),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(VehicleStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withValues(alpha: 0.1),
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

  Color _getStatusColor(VehicleStatus status) {
    switch (status) {
      case VehicleStatus.available:
        return AppColors.success;
      case VehicleStatus.inUse:
        return AppColors.primary;
      case VehicleStatus.maintenance:
        return AppColors.warning;
      case VehicleStatus.outOfService:
        return AppColors.error;
    }
  }

  IconData _getVehicleIcon(VehicleType type) {
    switch (type) {
      case VehicleType.truck:
        return CupertinoIcons.bus;
      case VehicleType.van:
        return CupertinoIcons.car_detailed;
      case VehicleType.pickup:
        return CupertinoIcons.car;
      case VehicleType.trailer:
        return CupertinoIcons.rectangle_on_rectangle;
    }
  }

  void _showVehicleDetails(Vehicle vehicle) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vehicle.plate,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${vehicle.brand} ${vehicle.model}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      _buildStatusBadge(vehicle.status),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildDetailRow('Tip', vehicle.type.displayName),
                  _buildDetailRow('Yil', '${vehicle.year}'),
                  _buildDetailRow(
                    'Kapasite',
                    vehicle.capacity != null ? '${vehicle.capacity} kg' : '-',
                  ),
                  _buildDetailRow(
                    'Kilometre',
                    vehicle.currentKm != null ? '${vehicle.currentKm} km' : '-',
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
                          color: AppColors.warning,
                          borderRadius: BorderRadius.circular(12),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Bakima Al'),
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

  Widget _buildDetailRow(String label, String value) {
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
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddVehicleSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
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
                      'Yeni Arac',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildTextField('Plaka', '34 ABC 123'),
                    const SizedBox(height: 16),
                    _buildTextField('Marka', 'Mercedes'),
                    const SizedBox(height: 16),
                    _buildTextField('Model', 'Actros'),
                    const SizedBox(height: 16),
                    _buildTextField('Yil', '2023'),
                    const SizedBox(height: 16),
                    _buildTextField('Kapasite (kg)', '25000'),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton.filled(
                        borderRadius: BorderRadius.circular(12),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Arac Ekle'),
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
