import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'explore_screen.dart';
import 'sell_screen.dart';
import 'saved_screen.dart';
import 'profile_screen.dart';

/// Main application shell with bottom navigation.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => MainShellState();

  /// Allow children to switch tabs programmatically.
  static MainShellState? of(BuildContext context) {
    return context.findAncestorStateOfType<MainShellState>();
  }
}

class MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  // Keep screens alive for tab state preservation.
  late final List<Widget> _screens;

  final GlobalKey<ExploreScreenState> _exploreKey = GlobalKey<ExploreScreenState>();

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      ExploreScreen(key: _exploreKey),
      const SellScreen(),
      const SavedScreen(),
      const ProfileScreen(),
    ];
  }

  /// Switch to a specific tab.
  void switchToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  /// Navigate to Explore with a category pre-selected.
  void navigateToExplore({String? category}) {
    setState(() {
      _currentIndex = 1;
    });
    // Defer the category filter application to after build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _exploreKey.currentState?.setCategory(category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: SwoopTheme.cardWhite,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  isActive: _currentIndex == 0,
                  onTap: () => switchToTab(0),
                ),
                _NavItem(
                  icon: Icons.explore_rounded,
                  label: 'Explore',
                  isActive: _currentIndex == 1,
                  onTap: () => switchToTab(1),
                ),
                // Sell — prominent central action
                _SellButton(
                  isActive: _currentIndex == 2,
                  onTap: () => switchToTab(2),
                ),
                _NavItem(
                  icon: Icons.favorite_rounded,
                  label: 'Saved',
                  isActive: _currentIndex == 3,
                  onTap: () => switchToTab(3),
                ),
                _NavItem(
                  icon: Icons.person_rounded,
                  label: 'Profile',
                  isActive: _currentIndex == 4,
                  onTap: () => switchToTab(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Standard navigation item.
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 56,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: isActive
                    ? SwoopTheme.forestGreen.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(SwoopTheme.radiusPill),
              ),
              child: Icon(
                icon,
                size: 24,
                color: isActive ? SwoopTheme.forestGreen : SwoopTheme.textTertiary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? SwoopTheme.forestGreen : SwoopTheme.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Prominent Sell button in the centre of the nav bar.
class _SellButton extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const _SellButton({required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [SwoopTheme.forestGreen, SwoopTheme.mutedTeal],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: SwoopTheme.forestGreen.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
