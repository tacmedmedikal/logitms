import 'dart:ui';
import 'package:flutter/cupertino.dart';
import '../constants/app_colors.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showAlert('Hata', 'Lutfen tum alanlari doldurun.');
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
    widget.onLoginSuccess();
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
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  CupertinoColors.black.withValues(alpha: 0.3),
                  CupertinoColors.black.withValues(alpha: 0.7),
                  CupertinoColors.black.withValues(alpha: 0.85),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        // Logo & Title Section
                        _buildHeader(),
                        const SizedBox(height: 50),
                        // Login Card
                        _buildLoginCard(),
                        const SizedBox(height: 40),
                        // Footer
                        _buildFooter(),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Icon Container
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: CupertinoColors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: CupertinoColors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: const Icon(
            CupertinoIcons.cube_box_fill,
            size: 40,
            color: CupertinoColors.white,
          ),
        ),
        const SizedBox(height: 24),
        // App Name
        const Text(
          'LogiTMS',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: CupertinoColors.white,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        // Tagline
        Text(
          'Lojistik Yonetim Sistemi',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: CupertinoColors.white.withValues(alpha: 0.7),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: CupertinoColors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: CupertinoColors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Text
              const Text(
                'Hos Geldiniz',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Devam etmek icin giris yapin',
                style: TextStyle(
                  fontSize: 14,
                  color: CupertinoColors.white.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 32),
              // Email Field
              _buildTextField(
                controller: _emailController,
                placeholder: 'E-posta adresiniz',
                icon: CupertinoIcons.mail,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              // Password Field
              _buildTextField(
                controller: _passwordController,
                placeholder: 'Sifreniz',
                icon: CupertinoIcons.lock,
                isPassword: true,
              ),
              const SizedBox(height: 16),
              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    _showAlert(
                      'Sifre Sifirlama',
                      'Sifre sifirlama maili gonderildi.',
                    );
                  },
                  child: Text(
                    'Sifremi Unuttum',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: CupertinoColors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              // Login Button
              _buildLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String placeholder,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: CupertinoColors.white.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: CupertinoTextField(
        controller: controller,
        placeholder: placeholder,
        placeholderStyle: TextStyle(
          color: CupertinoColors.white.withValues(alpha: 0.4),
          fontSize: 15,
        ),
        style: const TextStyle(
          color: CupertinoColors.white,
          fontSize: 15,
        ),
        obscureText: isPassword ? _obscurePassword : false,
        prefix: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Icon(
            icon,
            color: CupertinoColors.white.withValues(alpha: 0.6),
            size: 20,
          ),
        ),
        suffix: isPassword
            ? Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                  child: Icon(
                    _obscurePassword
                        ? CupertinoIcons.eye
                        : CupertinoIcons.eye_slash,
                    color: CupertinoColors.white.withValues(alpha: 0.6),
                    size: 20,
                  ),
                ),
              )
            : null,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: const BoxDecoration(
          color: CupertinoColors.transparent,
        ),
        keyboardType: keyboardType,
        textInputAction:
            isPassword ? TextInputAction.done : TextInputAction.next,
        onSubmitted: isPassword ? (_) => _handleLogin() : null,
      ),
    );
  }

  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _handleLogin,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primary.withValues(alpha: 0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: _isLoading
              ? const CupertinoActivityIndicator(
                  color: CupertinoColors.white,
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Giris Yap',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      CupertinoIcons.arrow_right,
                      color: CupertinoColors.white,
                      size: 18,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          'Powered by LogiTMS',
          style: TextStyle(
            fontSize: 12,
            color: CupertinoColors.white.withValues(alpha: 0.4),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'v1.0.0',
          style: TextStyle(
            fontSize: 11,
            color: CupertinoColors.white.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }
}
