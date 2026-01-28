import 'package:flutter/cupertino.dart';
import '../constants/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onLogout;

  const ProfileScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Profil'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Profile Avatar
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Center(
                  child: Text(
                    'AY',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Admin User',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'admin@logitms.com',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Admin',
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Settings Sections
              _buildSettingsSection(
                'Hesap',
                [
                  _SettingsItem(
                    icon: CupertinoIcons.person,
                    title: 'Profil Bilgileri',
                    onTap: () {},
                  ),
                  _SettingsItem(
                    icon: CupertinoIcons.lock,
                    title: 'Sifre Degistir',
                    onTap: () {},
                  ),
                  _SettingsItem(
                    icon: CupertinoIcons.bell,
                    title: 'Bildirimler',
                    onTap: () {},
                    trailing: CupertinoSwitch(
                      value: true,
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildSettingsSection(
                'Uygulama',
                [
                  _SettingsItem(
                    icon: CupertinoIcons.globe,
                    title: 'Dil',
                    subtitle: 'Turkce',
                    onTap: () {},
                  ),
                  _SettingsItem(
                    icon: CupertinoIcons.moon,
                    title: 'Karanlik Mod',
                    onTap: () {},
                    trailing: CupertinoSwitch(
                      value: false,
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildSettingsSection(
                'Destek',
                [
                  _SettingsItem(
                    icon: CupertinoIcons.question_circle,
                    title: 'Yardim Merkezi',
                    onTap: () {},
                  ),
                  _SettingsItem(
                    icon: CupertinoIcons.info_circle,
                    title: 'Hakkinda',
                    subtitle: 'v1.0.0',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  onPressed: () => _showLogoutConfirmation(context),
                  child: const Text(
                    'Cikis Yap',
                    style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<_SettingsItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Container(
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
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  GestureDetector(
                    onTap: item.onTap,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      color: CupertinoColors.transparent,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              item.icon,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                if (item.subtitle != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    item.subtitle!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (item.trailing != null)
                            item.trailing!
                          else
                            const Icon(
                              CupertinoIcons.chevron_right,
                              color: AppColors.textSecondary,
                              size: 16,
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (index < items.length - 1)
                    Padding(
                      padding: const EdgeInsets.only(left: 56),
                      child: Container(
                        height: 1,
                        color: AppColors.divider,
                      ),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Cikis Yap'),
        content: const Text('Cikis yapmak istediginize emin misiniz?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Iptal'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              onLogout();
            },
            child: const Text('Cikis Yap'),
          ),
        ],
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  _SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.trailing,
  });
}
