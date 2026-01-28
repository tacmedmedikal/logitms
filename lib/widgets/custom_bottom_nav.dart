import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;
import '../constants/app_colors.dart';

class CustomBottomNav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  final List<GlobalKey> _itemKeys = List.generate(5, (_) => GlobalKey());

  void _handleDragUpdate(DragUpdateDetails details) {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final localPosition = details.localPosition;

    for (int i = 0; i < _itemKeys.length; i++) {
      final key = _itemKeys[i];
      final itemContext = key.currentContext;
      if (itemContext != null) {
        final itemBox = itemContext.findRenderObject() as RenderBox?;
        if (itemBox != null) {
          final itemPosition = itemBox.localToGlobal(Offset.zero, ancestor: renderBox);
          final itemSize = itemBox.size;
          final itemRect = Rect.fromLTWH(
            itemPosition.dx,
            itemPosition.dy,
            itemSize.width,
            itemSize.height,
          );

          if (itemRect.contains(localPosition)) {
            if (widget.currentIndex != i) {
              widget.onTap(i);
            }
            break;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _handleDragUpdate,
      onVerticalDragUpdate: _handleDragUpdate,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 28),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.black.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: CupertinoColors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              key: _itemKeys[0],
              icon: CupertinoIcons.house,
              activeIcon: CupertinoIcons.house_fill,
              label: 'Ana Sayfa',
              isSelected: widget.currentIndex == 0,
              onTap: () => widget.onTap(0),
            ),
            _NavItem(
              key: _itemKeys[1],
              icon: CupertinoIcons.cube_box,
              activeIcon: CupertinoIcons.cube_box_fill,
              label: 'Sevkiyat',
              isSelected: widget.currentIndex == 1,
              onTap: () => widget.onTap(1),
            ),
            _NavItem(
              key: _itemKeys[2],
              icon: Icons.local_shipping_outlined,
              activeIcon: Icons.local_shipping,
              label: 'Araclar',
              isSelected: widget.currentIndex == 2,
              onTap: () => widget.onTap(2),
            ),
            _NavItem(
              key: _itemKeys[3],
              icon: CupertinoIcons.person_2,
              activeIcon: CupertinoIcons.person_2_fill,
              label: 'Suruculer',
              isSelected: widget.currentIndex == 3,
              onTap: () => widget.onTap(3),
            ),
            _NavItem(
              key: _itemKeys[4],
              icon: CupertinoIcons.person_circle,
              activeIcon: CupertinoIcons.person_circle_fill,
              label: 'Profil',
              isSelected: widget.currentIndex == 4,
              onTap: () => widget.onTap(4),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    super.key,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.tigerTail5
              : CupertinoColors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? activeIcon : icon,
                key: ValueKey(isSelected),
                color: isSelected ? CupertinoColors.white : AppColors.textSecondary,
                size: 22,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              child: isSelected
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        label,
                        style: const TextStyle(
                          color: CupertinoColors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
