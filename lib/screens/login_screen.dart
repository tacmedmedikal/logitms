import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../services/device_service.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'test@test.com');
  final _hiddenPinController = TextEditingController();
  final _hiddenPinFocusNode = FocusNode();
  final List<TextEditingController> _pinControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  bool _emailValidated = false;
  int _currentStep = 0; // 0: email, 1: pin

  @override
  void dispose() {
    _emailController.dispose();
    _hiddenPinController.dispose();
    _hiddenPinFocusNode.dispose();
    for (var controller in _pinControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _validateEmail() async {
    if (_emailController.text.isEmpty) {
      _showAlert('Hata', 'Lutfen e-posta adresinizi girin.');
      return;
    }

    if (!_isValidEmail(_emailController.text)) {
      _showAlert('Hata', 'Gecerli bir e-posta adresi girin.');
      return;
    }

    setState(() {
      _emailValidated = true;
    });

    setState(() {
      _currentStep = 1;
    });

    // Focus hidden PIN input
    _hiddenPinFocusNode.requestFocus();
  }

  Future<void> _validatePin() async {
    String pin = _hiddenPinController.text;

    if (pin.length != 6) {
      _showAlert('Hata', 'Lutfen 6 haneli PIN kodunu girin.');
      return;
    }

    // Check device registration
    final deviceService = DeviceService();
    final hasRegistered = await deviceService.hasRegisteredDevice();

    if (!hasRegistered) {
      // First time login - register this device
      await deviceService.registerCurrentDevice();
      widget.onLoginSuccess();
      return;
    }

    final isCurrentDevice = await deviceService.isCurrentDeviceRegistered();

    if (isCurrentDevice) {
      // Same device - allow login
      widget.onLoginSuccess();
    } else {
      // Different device - request admin approval
      await deviceService.requestDeviceApproval();
      _showDeviceApprovalDialog();
    }
  }

  void _showDeviceApprovalDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Cihaz Onay Gerekli'),
        content: const Text(
          'Bu uygulama baska bir cihazda kayitli. '
          'Bu cihazda kullanmak icin admin onay\u0131 gereklidir.\n\n'
          'Lutfen sistem yoneticinize basvurun.',
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Tamam'),
            onPressed: () {
              Navigator.pop(context);
              _goBackToEmail();
            },
          ),
        ],
      ),
    );
  }

  void _onHiddenPinChanged(String value) {
    setState(() {
      for (int i = 0; i < 6; i++) {
        _pinControllers[i].text = i < value.length ? value[i] : '';
      }
    });

    // Auto submit when all fields are filled
    if (value.length == 6) {
      _validatePin();
    }
  }

  void _goBackToEmail() {
    setState(() {
      _currentStep = 0;
      _emailValidated = false;
      _hiddenPinController.clear();
      for (var controller in _pinControllers) {
        controller.clear();
      }
    });
  }

  void _showAlert(String title, String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('Tamam'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/login.jpg',
            fit: BoxFit.cover,
          ),
          // Dark overlay at top
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  CupertinoColors.black.withValues(alpha: 0.4),
                  CupertinoColors.black.withValues(alpha: 0.2),
                  CupertinoColors.transparent,
                ],
                stops: const [0.0, 0.3, 0.5],
              ),
            ),
          ),
          // Content
          Column(
            children: [
              // Top empty area (shows background image)
              const Expanded(
                flex: 4,
                child: SizedBox(),
              ),
              // Bottom white panel
              Container(
                decoration: const BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28, 32, 28, 20),
                    child: _currentStep == 0
                        ? _buildEmailStep()
                        : _buildPinStep(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmailStep() {
    return Column(
      key: const ValueKey('email_step'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Handle bar
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey4,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Welcome text
        const Text(
          'Hos Geldiniz',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: CupertinoColors.black,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Devam etmek icin e-posta adresinizi girin',
          style: TextStyle(
            fontSize: 15,
            color: CupertinoColors.systemGrey,
          ),
        ),
        const SizedBox(height: 32),
        // Email field
        _buildEmailField(),
        const SizedBox(height: 28),
        // Continue button
        _buildContinueButton(),
        const SizedBox(height: 24),
        // Footer
        Center(
          child: Text(
            'Powered by LogiTMS v1.0.0',
            style: TextStyle(
              fontSize: 12,
              color: CupertinoColors.systemGrey3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPinStep() {
    return Column(
      key: const ValueKey('pin_step'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Handle bar
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey4,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Back button and title row
        Row(
          children: [
            GestureDetector(
              onTap: _goBackToEmail,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  CupertinoIcons.back,
                  color: CupertinoColors.black,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'PIN Girisi',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: CupertinoColors.black,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '${_emailController.text} adresine gonderilen 6 haneli kodu girin',
          style: TextStyle(
            fontSize: 15,
            color: CupertinoColors.systemGrey,
          ),
        ),
        const SizedBox(height: 32),
        // Hidden PIN input
        _buildHiddenPinInput(),
        // PIN fields
        GestureDetector(
          onTap: () => _hiddenPinFocusNode.requestFocus(),
          child: _buildPinFields(),
        ),
        const SizedBox(height: 32),
        // Login button
        _buildLoginButton(),
        const SizedBox(height: 24),
        // Footer
        Center(
          child: Text(
            'Powered by LogiTMS v1.0.0',
            style: TextStyle(
              fontSize: 12,
              color: CupertinoColors.systemGrey3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Container(
      decoration: BoxDecoration(
        color: _emailValidated
            ? CupertinoColors.systemGreen.withValues(alpha: 0.1)
            : CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _emailValidated
              ? CupertinoColors.systemGreen
              : CupertinoColors.systemGrey5,
          width: _emailValidated ? 2 : 1,
        ),
      ),
      child: CupertinoTextField(
        controller: _emailController,
        placeholder: 'E-posta adresiniz',
        placeholderStyle: TextStyle(
          color: CupertinoColors.systemGrey,
          fontSize: 15,
        ),
        style: TextStyle(
          color: _emailValidated
              ? CupertinoColors.systemGreen.darkColor
              : CupertinoColors.black,
          fontSize: 15,
        ),
        enabled: !_emailValidated,
        prefix: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Icon(
            _emailValidated ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.mail,
            color: _emailValidated
                ? CupertinoColors.systemGreen
                : CupertinoColors.systemGrey,
            size: 20,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: const BoxDecoration(
          color: CupertinoColors.transparent,
        ),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _validateEmail(),
      ),
    );
  }

  Widget _buildPinFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        final bool isFilled = _pinControllers[index].text.isNotEmpty;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 48,
          height: 56,
          decoration: BoxDecoration(
            color: isFilled
                ? AppColors.primary.withValues(alpha: 0.08)
                : CupertinoColors.systemGrey6,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isFilled
                  ? AppColors.primary
                  : CupertinoColors.systemGrey4,
              width: isFilled ? 2 : 1.5,
            ),
            boxShadow: isFilled
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: isFilled
                ? Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  )
                : Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey4,
                      shape: BoxShape.circle,
                    ),
                  ),
          ),
        );
      }),
    );
  }

  Widget _buildHiddenPinInput() {
    return Opacity(
      opacity: 0,
      child: SizedBox(
        height: 1,
        child: CupertinoTextField(
          controller: _hiddenPinController,
          focusNode: _hiddenPinFocusNode,
          keyboardType: TextInputType.number,
          maxLength: 6,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: _onHiddenPinChanged,
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return GestureDetector(
      onTap: _validateEmail,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primary.withValues(alpha: 0.85),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Devam Et',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.white,
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                CupertinoIcons.arrow_right,
                color: CupertinoColors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: _validatePin,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primary.withValues(alpha: 0.85),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Giris Yap',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.white,
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                CupertinoIcons.arrow_right,
                color: CupertinoColors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
