import 'package:flutter/cupertino.dart';
import 'package:fl_chart/fl_chart.dart';
import '../constants/app_colors.dart';
import '../models/shipment.dart';
import 'scanner_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isSearchVisible = false;
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  void _openScanner() async {
    final result = await Navigator.push<String>(
      context,
      CupertinoPageRoute(
        builder: (context) => const ScannerScreen(),
      ),
    );

    if (result != null && mounted) {
      // Handle the scanned barcode result
      // For now, just show a toast or handle the result as needed
      debugPrint('Scanned barcode: $result');
    }
  }

  // Mock data - will be replaced with real data from API
  final List<Shipment> _recentShipments = [
    Shipment(
      id: '1',
      trackingNumber: 'TRK-001',
      origin: 'Istanbul',
      destination: 'Ankara',
      status: ShipmentStatus.inTransit,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      customerName: 'ABC Lojistik',
    ),
    Shipment(
      id: '2',
      trackingNumber: 'TRK-002',
      origin: 'Izmir',
      destination: 'Bursa',
      status: ShipmentStatus.delivered,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      customerName: 'XYZ Kargo',
    ),
    Shipment(
      id: '3',
      trackingNumber: 'TRK-003',
      origin: 'Antalya',
      destination: 'Konya',
      status: ShipmentStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      customerName: 'Delta Nakliyat',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final expandedHeight = topPadding + (_isSearchVisible ? 140 : 80);

    // Calculate collapse progress (0 = expanded, 1 = collapsed)
    final collapseProgress = (_scrollOffset / 60).clamp(0.0, 1.0);

    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      child: Container(
        color: AppColors.background,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Scrollable content
            CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Space for header
              SliverToBoxAdapter(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: expandedHeight,
                ),
              ),
              SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Cards
                  _buildSummaryCards(),
                  const SizedBox(height: 24),
                  // Weekly Chart
                  _buildWeeklyChart(),
                  const SizedBox(height: 24),
                  // Recent Shipments
                  const Text(
                    'Son Sevkiyatlar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildShipmentCard(_recentShipments[index]),
              childCount: _recentShipments.length,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 120),
          ),
        ],
      ),
          // Fixed Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildHeader(context, collapseProgress),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double collapseProgress) {
    final topPadding = MediaQuery.of(context).padding.top;

    // Interpolate border radius based on collapse
    final borderRadius = 28.0 * (1 - collapseProgress);

    // Interpolate padding based on collapse
    final bottomPadding = collapseProgress > 0.01 ? 8.0 : (_isSearchVisible ? 20.0 : 16.0);
    final logoRowHeight = collapseProgress > 0.01 ? 32.0 : 44.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.fromLTRB(20, topPadding + 8, 20, bottomPadding),
      decoration: BoxDecoration(
        color: AppColors.tigerTail5,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top row: Logo, Icons using Stack for true centering
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: logoRowHeight,
            child: Stack(
              children: [
                // Logo - left when expanded, centered when collapsed
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  left: 0,
                  right: collapseProgress > 0.01 ? 0 : null,
                  top: 0,
                  bottom: 0,
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    alignment: collapseProgress > 0.01 ? Alignment.center : Alignment.centerLeft,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      height: collapseProgress > 0.01 ? 20 : 28,
                      child: Image.asset(
                        'assets/images/talaygif.gif',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                // Buttons - hide when collapsed
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: collapseProgress > 0.3 ? 0.0 : 1.0,
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 200),
                      scale: collapseProgress > 0.3 ? 0.0 : 1.0,
                      child: Row(
                        children: [
                          _buildHeaderButton(
                            icon: _isSearchVisible ? CupertinoIcons.xmark : CupertinoIcons.search,
                            onTap: () {
                              setState(() {
                                _isSearchVisible = !_isSearchVisible;
                              });
                            },
                            isActive: _isSearchVisible,
                          ),
                          const SizedBox(width: 10),
                          _buildHeaderButton(
                            icon: CupertinoIcons.barcode_viewfinder,
                            onTap: _openScanner,
                          ),
                          const SizedBox(width: 10),
                          _buildNotificationButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Search bar with animation - hide when collapsed
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            child: _isSearchVisible && collapseProgress < 0.5
                ? Column(
                    children: [
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: CupertinoColors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: CupertinoColors.white.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.search,
                              color: CupertinoColors.white.withValues(alpha: 0.6),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CupertinoTextField(
                                placeholder: 'Sevkiyat, arac veya surucu ara...',
                                placeholderStyle: TextStyle(
                                  color: CupertinoColors.white.withValues(alpha: 0.5),
                                  fontSize: 15,
                                ),
                                style: const TextStyle(
                                  color: CupertinoColors.white,
                                  fontSize: 15,
                                ),
                                decoration: const BoxDecoration(
                                  color: CupertinoColors.transparent,
                                ),
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.tigerTail2
              : CupertinoColors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          icon,
          color: isActive ? AppColors.tigerTail5 : CupertinoColors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildNotificationButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: CupertinoColors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          children: [
            const Center(
              child: Icon(
                CupertinoIcons.bell,
                color: CupertinoColors.white,
                size: 20,
              ),
            ),
            // Badge
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.tigerTail5,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildSummaryCard(
          'Toplam Sevkiyat',
          '156',
          CupertinoIcons.cube_box,
          AppColors.primary,
        ),
        _buildSummaryCard(
          'Aktif Araclar',
          '24',
          CupertinoIcons.car_detailed,
          AppColors.success,
        ),
        _buildSummaryCard(
          'Musait Suruculer',
          '18',
          CupertinoIcons.person_2,
          AppColors.info,
        ),
        _buildSummaryCard(
          'Bugunun Teslimleri',
          '12',
          CupertinoIcons.checkmark_circle,
          AppColors.warning,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
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
          const Text(
            'Haftalik Sevkiyat',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 30,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['Pzt', 'Sal', 'Car', 'Per', 'Cum', 'Cmt', 'Paz'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            days[value.toInt()],
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                barGroups: [
                  _buildBarGroup(0, 18),
                  _buildBarGroup(1, 24),
                  _buildBarGroup(2, 20),
                  _buildBarGroup(3, 28),
                  _buildBarGroup(4, 22),
                  _buildBarGroup(5, 15),
                  _buildBarGroup(6, 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.primary,
          width: 20,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
      ],
    );
  }

  Widget _buildShipmentCard(Shipment shipment) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _getStatusColor(shipment.status).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                CupertinoIcons.cube_box,
                color: _getStatusColor(shipment.status),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shipment.trackingNumber,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${shipment.origin} → ${shipment.destination}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor(shipment.status).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                shipment.status.displayName,
                style: TextStyle(
                  color: _getStatusColor(shipment.status),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
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
}
