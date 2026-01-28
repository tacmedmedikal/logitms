import 'package:flutter/cupertino.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../constants/app_colors.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  bool _isScanned = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _handleBarcode(BarcodeCapture capture) {
    if (_isScanned) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final barcode = barcodes.first;
      setState(() {
        _isScanned = true;
      });

      _showResultDialog(barcode);
    }
  }

  void _showResultDialog(Barcode barcode) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Barkod Okundu'),
        content: Column(
          children: [
            const SizedBox(height: 12),
            Text(
              'Tip: ${barcode.format.name}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                barcode.rawValue ?? 'Bilinmiyor',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Tekrar Tara'),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isScanned = false;
              });
            },
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Tamam'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, barcode.rawValue);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.tigerTail5,
      child: Stack(
        children: [
          // Overlay with camera inside white card
          _buildOverlay(),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Top bar with close and flash buttons
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Close button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: CupertinoColors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            CupertinoIcons.xmark,
                            color: CupertinoColors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      // Flash toggle
                      GestureDetector(
                        onTap: () => controller.toggleTorch(),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: CupertinoColors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ValueListenableBuilder(
                            valueListenable: controller,
                            builder: (context, state, child) {
                              return Icon(
                                state.torchState == TorchState.on
                                    ? CupertinoIcons.bolt_fill
                                    : CupertinoIcons.bolt,
                                color: state.torchState == TorchState.on
                                    ? AppColors.tigerTail2
                                    : CupertinoColors.white,
                                size: 20,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Top text - right below top bar
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Column(
                    children: [
                      Text(
                        'Sipariş ve planlama için QR göster',
                        style: TextStyle(
                          color: CupertinoColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'QR kodunu cihaza okut',
                        style: TextStyle(
                          color: CupertinoColors.systemGrey,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Scan area placeholder (actual area is in overlay)
                const SizedBox(height: 340),

                const Spacer(),

                // Bottom button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: GestureDetector(
                    onTap: () {
                      // Handle other QR operations
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text(
                        'Diğer QR işlemleri',
                        style: TextStyle(
                          color: CupertinoColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    const double scanAreaSize = 300;
    const double cardPadding = 20;
    const double cardSize = scanAreaSize + (cardPadding * 2);
    const double cornerLength = 45;
    const double cornerWidth = 4;
    const double cornerRadius = 16;
    const double cardRadius = 24;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final cardLeft = (screenWidth - cardSize) / 2;
        final cardTop = (screenHeight - cardSize) / 2;
        final scanAreaLeft = cardLeft + cardPadding;
        final scanAreaTop = cardTop + cardPadding;

        return Stack(
          children: [
            // Dark navy overlay with cutout for the white card
            CustomPaint(
              size: Size(screenWidth, screenHeight),
              painter: _ScannerOverlayPainter(
                scanAreaLeft: cardLeft,
                scanAreaTop: cardTop,
                scanAreaSize: cardSize,
                overlayColor: AppColors.tigerTail5,
                cornerRadius: cardRadius,
              ),
            ),
            // White card background
            Positioned(
              left: cardLeft,
              top: cardTop,
              child: Container(
                width: cardSize,
                height: cardSize,
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(cardRadius),
                ),
                child: Center(
                  child: Container(
                    width: scanAreaSize,
                    height: scanAreaSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(cornerRadius),
                      color: CupertinoColors.black,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(cornerRadius),
                      child: MobileScanner(
                        controller: controller,
                        onDetect: _handleBarcode,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Yellow corners on scan area
            Positioned(
              left: scanAreaLeft,
              top: scanAreaTop,
              child: CustomPaint(
                size: const Size(scanAreaSize, scanAreaSize),
                painter: _CornersPainter(
                  cornerLength: cornerLength,
                  cornerWidth: cornerWidth,
                  cornerRadius: cornerRadius,
                  color: AppColors.tigerTail2,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Overlay painter - dark navy with transparent cutout
class _ScannerOverlayPainter extends CustomPainter {
  final double scanAreaLeft;
  final double scanAreaTop;
  final double scanAreaSize;
  final Color overlayColor;
  final double cornerRadius;

  _ScannerOverlayPainter({
    required this.scanAreaLeft,
    required this.scanAreaTop,
    required this.scanAreaSize,
    required this.overlayColor,
    required this.cornerRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = overlayColor;

    // Create path for the entire screen
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Create path for the scan area cutout with rounded corners
    final cutoutPath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(scanAreaLeft, scanAreaTop, scanAreaSize, scanAreaSize),
        Radius.circular(cornerRadius),
      ));

    // Combine paths (subtract cutout from background)
    final combinedPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    canvas.drawPath(combinedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Corner painter - yellow corners only
class _CornersPainter extends CustomPainter {
  final double cornerLength;
  final double cornerWidth;
  final double cornerRadius;
  final Color color;

  _CornersPainter({
    required this.cornerLength,
    required this.cornerWidth,
    required this.cornerRadius,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = cornerWidth
      ..strokeCap = StrokeCap.round;

    // Top-left corner
    _drawCorner(canvas, paint, 0, 0, cornerLength, cornerRadius, true, true);

    // Top-right corner
    _drawCorner(canvas, paint, size.width, 0, cornerLength, cornerRadius, false, true);

    // Bottom-left corner
    _drawCorner(canvas, paint, 0, size.height, cornerLength, cornerRadius, true, false);

    // Bottom-right corner
    _drawCorner(canvas, paint, size.width, size.height, cornerLength, cornerRadius, false, false);
  }

  void _drawCorner(
    Canvas canvas,
    Paint paint,
    double x,
    double y,
    double length,
    double radius,
    bool isLeft,
    bool isTop,
  ) {
    final path = Path();

    if (isLeft && isTop) {
      // Top-left
      path.moveTo(x, y + length);
      path.lineTo(x, y + radius);
      path.quadraticBezierTo(x, y, x + radius, y);
      path.lineTo(x + length, y);
    } else if (!isLeft && isTop) {
      // Top-right
      path.moveTo(x - length, y);
      path.lineTo(x - radius, y);
      path.quadraticBezierTo(x, y, x, y + radius);
      path.lineTo(x, y + length);
    } else if (isLeft && !isTop) {
      // Bottom-left
      path.moveTo(x, y - length);
      path.lineTo(x, y - radius);
      path.quadraticBezierTo(x, y, x + radius, y);
      path.lineTo(x + length, y);
    } else {
      // Bottom-right
      path.moveTo(x - length, y);
      path.lineTo(x - radius, y);
      path.quadraticBezierTo(x, y, x, y - radius);
      path.lineTo(x, y - length);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
