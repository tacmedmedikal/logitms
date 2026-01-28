import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';
import '../models/shipment.dart';

class ShipmentsScreen extends StatefulWidget {
  const ShipmentsScreen({super.key});

  @override
  State<ShipmentsScreen> createState() => _ShipmentsScreenState();
}

class _ShipmentsScreenState extends State<ShipmentsScreen> {
  final _searchController = TextEditingController();
  ShipmentStatus? _selectedFilter;

  // Mock data
  final List<Shipment> _allShipments = [
    Shipment(
      id: '1',
      trackingNumber: 'TRK-001',
      origin: 'Istanbul',
      destination: 'Ankara',
      status: ShipmentStatus.inTransit,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      customerName: 'ABC Lojistik',
      customerPhone: '0532 123 4567',
      weight: 1500,
    ),
    Shipment(
      id: '2',
      trackingNumber: 'TRK-002',
      origin: 'Izmir',
      destination: 'Bursa',
      status: ShipmentStatus.delivered,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      customerName: 'XYZ Kargo',
      customerPhone: '0533 234 5678',
      weight: 800,
    ),
    Shipment(
      id: '3',
      trackingNumber: 'TRK-003',
      origin: 'Antalya',
      destination: 'Konya',
      status: ShipmentStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      customerName: 'Delta Nakliyat',
      customerPhone: '0534 345 6789',
      weight: 2200,
    ),
    Shipment(
      id: '4',
      trackingNumber: 'TRK-004',
      origin: 'Adana',
      destination: 'Mersin',
      status: ShipmentStatus.assigned,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      customerName: 'Omega Lojistik',
      customerPhone: '0535 456 7890',
      weight: 500,
    ),
    Shipment(
      id: '5',
      trackingNumber: 'TRK-005',
      origin: 'Trabzon',
      destination: 'Samsun',
      status: ShipmentStatus.pickedUp,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      customerName: 'Beta Kargo',
      customerPhone: '0536 567 8901',
      weight: 1200,
    ),
  ];

  List<Shipment> get _filteredShipments {
    var shipments = _allShipments;

    if (_selectedFilter != null) {
      shipments = shipments.where((s) => s.status == _selectedFilter).toList();
    }

    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      shipments = shipments.where((s) {
        return s.trackingNumber.toLowerCase().contains(query) ||
            s.origin.toLowerCase().contains(query) ||
            s.destination.toLowerCase().contains(query) ||
            (s.customerName?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return shipments;
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
        middle: const Text('Sevkiyatlar'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _showAddShipmentSheet,
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
                    placeholder: 'Sevkiyat ara...',
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  _buildFilterChips(),
                ],
              ),
            ),

            // Shipment List
            Expanded(
              child: _filteredShipments.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 100),
                      itemCount: _filteredShipments.length,
                      itemBuilder: (context, index) {
                        return _buildShipmentCard(_filteredShipments[index]);
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
          _buildFilterChip(ShipmentStatus.pending, 'Beklemede'),
          _buildFilterChip(ShipmentStatus.inTransit, 'Yolda'),
          _buildFilterChip(ShipmentStatus.delivered, 'Teslim'),
          _buildFilterChip(ShipmentStatus.cancelled, 'Iptal'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(ShipmentStatus? status, String label) {
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
            CupertinoIcons.cube_box,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Sevkiyat bulunamadi',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShipmentCard(Shipment shipment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => _showShipmentDetails(shipment),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    shipment.trackingNumber,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  _buildStatusBadge(shipment.status),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    CupertinoIcons.location,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${shipment.origin} → ${shipment.destination}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.person,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        shipment.customerName ?? '-',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    DateFormat('dd.MM.yyyy HH:mm').format(shipment.createdAt),
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
      ),
    );
  }

  Widget _buildStatusBadge(ShipmentStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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

  Color _getStatusColor(ShipmentStatus status) {
    switch (status) {
      case ShipmentStatus.pending:
        return AppColors.statusPending;
      case ShipmentStatus.assigned:
      case ShipmentStatus.pickedUp:
      case ShipmentStatus.inTransit:
        return AppColors.statusInTransit;
      case ShipmentStatus.delivered:
        return AppColors.statusDelivered;
      case ShipmentStatus.cancelled:
        return AppColors.statusCancelled;
    }
  }

  void _showShipmentDetails(Shipment shipment) {
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
                      Text(
                        shipment.trackingNumber,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildStatusBadge(shipment.status),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildDetailRow('Cikis', shipment.origin),
                  _buildDetailRow('Varis', shipment.destination),
                  _buildDetailRow('Musteri', shipment.customerName ?? '-'),
                  _buildDetailRow('Telefon', shipment.customerPhone ?? '-'),
                  _buildDetailRow(
                    'Agirlik',
                    shipment.weight != null ? '${shipment.weight} kg' : '-',
                  ),
                  _buildDetailRow(
                    'Olusturma',
                    DateFormat('dd.MM.yyyy HH:mm').format(shipment.createdAt),
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
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(12),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Iptal Et'),
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

  void _showAddShipmentSheet() {
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
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Yeni Sevkiyat',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildTextField('Cikis Noktasi', 'Istanbul'),
                  const SizedBox(height: 16),
                  _buildTextField('Varis Noktasi', 'Ankara'),
                  const SizedBox(height: 16),
                  _buildTextField('Musteri Adi', 'ABC Lojistik'),
                  const SizedBox(height: 16),
                  _buildTextField('Telefon', '0532 123 4567'),
                  const SizedBox(height: 16),
                  _buildTextField('Agirlik (kg)', '1000'),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton.filled(
                      borderRadius: BorderRadius.circular(12),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Sevkiyat Olustur'),
                    ),
                  ),
                ],
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
