import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme.dart';
import 'screens/dashboard_screen.dart';
import 'screens/search_screen.dart';
import 'screens/emergency_screen.dart';
import 'screens/catalog_screen.dart';
import 'screens/favorites_screen.dart';
import 'services/storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light));
  runApp(const MediToolApp());
}

class MediToolApp extends StatelessWidget {
  const MediToolApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'MediTool', debugShowCheckedModeBanner: false, theme: AppTheme.darkTheme, home: const MainShell());
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  int _favCount = 0;

  final _pages = const [DashboardScreen(), SearchScreen(), EmergencyScreen(), CatalogScreen(), FavoritesScreen()];

  @override
  void initState() { super.initState(); _updateFavCount(); }

  Future<void> _updateFavCount() async {
    final favs = await StorageService.getFavorites();
    if (mounted) setState(() => _favCount = favs.length);
  }

  void _onTabChanged(int index) { setState(() => _currentIndex = index); if (index == 4) _updateFavCount(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: AppTheme.card.withValues(alpha: 0.95), border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05)))),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(children: [
              _NavItem(icon: Icons.home_rounded, label: 'Start', isActive: _currentIndex == 0, onTap: () => _onTabChanged(0)),
              _NavItem(icon: Icons.search_rounded, label: 'Suche', isActive: _currentIndex == 1, onTap: () => _onTabChanged(1)),
              _NavItem(icon: Icons.warning_rounded, label: 'Notfall', isActive: _currentIndex == 2, onTap: () => _onTabChanged(2), hasAlert: true),
              _NavItem(icon: Icons.grid_view_rounded, label: 'Katalog', isActive: _currentIndex == 3, onTap: () => _onTabChanged(3)),
              _NavItem(icon: Icons.star_rounded, label: 'Merkliste', isActive: _currentIndex == 4, onTap: () => _onTabChanged(4), badge: _favCount > 0 ? _favCount : null),
            ]),
          ),
        ),
      ),
    );
  }
}
