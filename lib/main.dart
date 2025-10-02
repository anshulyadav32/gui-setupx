import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'database/prisma_client.dart';

void main() {
  runApp(const FullScreenApp());
}

class FullScreenApp extends StatelessWidget {
  const FullScreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Full Screen Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const FullScreenHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FullScreenHomePage extends StatefulWidget {
  const FullScreenHomePage({super.key});

  @override
  State<FullScreenHomePage> createState() => _FullScreenHomePageState();
}

class _FullScreenHomePageState extends State<FullScreenHomePage> {
  bool _leftSidebarVisible = true;
  bool _rightSidebarVisible = true;
  int _selectedIndex = 0;
  Timer? _fullScreenTimer;

  List<Map<String, dynamic>> _navbarItems = [];
  List<Map<String, dynamic>> _packageManagers = [];
  String _selectedCategory = 'dashboard';

  @override
  void initState() {
    super.initState();
    // Initialize Prisma database
    _initializeDatabase();
    
    // Set full screen mode on Windows
    _setFullScreen();
    
    // Start timer to continuously maintain full screen mode
    _fullScreenTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        _forceFullScreen();
      }
    });
  }

  Future<void> _initializeDatabase() async {
    try {
      await PrismaClient.instance.initialize();
      await _loadUserSettings();
      await _loadNavbarItems();
      await _loadPackageManagers();
      await _logAppEvent('info', 'App initialized successfully', category: 'startup');
    } catch (e) {
      await _logAppEvent('error', 'Failed to initialize database: $e', category: 'startup');
    }
  }

  Future<void> _loadUserSettings() async {
    try {
      final settings = await PrismaClient.instance.getUserSettings('default-user');
      if (settings != null) {
        setState(() {
          _leftSidebarVisible = settings['sidebarLeftVisible'] ?? true;
          _rightSidebarVisible = settings['sidebarRightVisible'] ?? true;
        });
      }
    } catch (e) {
      await _logAppEvent('error', 'Failed to load user settings: $e', category: 'settings');
    }
  }

  Future<void> _loadNavbarItems() async {
    try {
      final items = await PrismaClient.instance.getNavbarItems();
      setState(() {
        _navbarItems = items;
        // Set default selection if items are loaded
        if (items.isNotEmpty) {
          _selectedCategory = items[0]['category'];
          _selectedIndex = 0;
        }
      });
      await _logAppEvent('info', 'Navbar items loaded successfully: ${items.length} items', category: 'navbar');
    } catch (e) {
      await _logAppEvent('error', 'Failed to load navbar items: $e', category: 'navbar');
      // Fallback to default items if database fails
      setState(() {
        _navbarItems = [
          {
            'id': '1',
            'name': 'Dashboard',
            'icon': 'dashboard',
            'route': '/dashboard',
            'order': 1,
            'isActive': true,
            'category': 'dashboard',
          },
          {
            'id': '2',
            'name': 'Package Manager',
            'icon': 'package',
            'route': '/package-manager',
            'order': 2,
            'isActive': true,
            'category': 'package_manager',
          },
          {
            'id': '3',
            'name': 'Server Management',
            'icon': 'server',
            'route': '/server-management',
            'order': 3,
            'isActive': true,
            'category': 'server_management',
          },
          {
            'id': '4',
            'name': 'Common Tools',
            'icon': 'tools',
            'route': '/common-tools',
            'order': 4,
            'isActive': true,
            'category': 'common_tools',
          },
        ];
        _selectedCategory = 'dashboard';
        _selectedIndex = 0;
      });
    }
  }

  Future<void> _loadPackageManagers() async {
    try {
      final managers = await PrismaClient.instance.getPackageManagers();
      setState(() {
        _packageManagers = managers;
      });
      await _logAppEvent('info', 'Package managers loaded successfully: ${managers.length} managers', category: 'package_managers');
    } catch (e) {
      await _logAppEvent('error', 'Failed to load package managers: $e', category: 'package_managers');
      // Fallback to empty list if database fails
      setState(() {
        _packageManagers = [];
      });
    }
  }

  Future<void> _logAppEvent(String level, String message, {String? category, Map<String, dynamic>? metadata}) async {
    await PrismaClient.instance.logAppEvent(level, message, category: category, metadata: metadata);
  }

  @override
  void dispose() {
    _fullScreenTimer?.cancel();
    super.dispose();
  }

  void _setFullScreen() {
    // Force full screen mode - hide all system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    
    // Set preferred orientations to prevent rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    
    // Force full screen on Windows
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
  }

  void _forceFullScreen() {
    // Always maintain full screen mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
  }

  void _toggleLeftSidebar() {
    setState(() {
      _leftSidebarVisible = !_leftSidebarVisible;
    });
    _saveUserSettings();
    _logAppEvent('info', 'Left sidebar toggled', category: 'navigation', metadata: {
      'visible': _leftSidebarVisible,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  void _toggleRightSidebar() {
    setState(() {
      _rightSidebarVisible = !_rightSidebarVisible;
    });
    _saveUserSettings();
    _logAppEvent('info', 'Right sidebar toggled', category: 'navigation', metadata: {
      'visible': _rightSidebarVisible,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<void> _saveUserSettings() async {
    try {
      await PrismaClient.instance.updateUserSettings('default-user', {
        'sidebarLeftVisible': _leftSidebarVisible,
        'sidebarRightVisible': _rightSidebarVisible,
        'fullScreenMode': true,
        'autoFullScreen': true,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      await _logAppEvent('error', 'Failed to save user settings: $e', category: 'settings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
              Color(0xFF0f3460),
            ],
          ),
        ),
        child: Row(
          children: [
            // Left Sidebar
            if (_leftSidebarVisible) _buildLeftSidebar(),
            
            // Main Content
            Expanded(
              child: _buildMainContent(),
            ),
            
            // Right Sidebar
            if (_rightSidebarVisible) _buildRightSidebar(),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftSidebar() {
    return Container(
      width: 250,
      decoration: const BoxDecoration(
        color: Color(0xFF0f1419),
        border: Border(
          right: BorderSide(color: Colors.white24, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Sidebar Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white24, width: 1),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.menu, color: Colors.white, size: 24),
                const SizedBox(width: 10),
                const Text(
                  'Navigation',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _loadNavbarItems,
                  icon: const Icon(Icons.refresh, color: Colors.white70, size: 20),
                  tooltip: 'Refresh Navigation',
                ),
                IconButton(
                  onPressed: _toggleLeftSidebar,
                  icon: const Icon(Icons.close, color: Colors.white70),
                ),
              ],
            ),
          ),
          
          // Menu Items
          Expanded(
            child: _navbarItems.isEmpty 
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.white70),
                      SizedBox(height: 16),
                      Text(
                        'Loading navigation...',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _navbarItems.length,
                  itemBuilder: (context, index) {
                    final item = _navbarItems[index];
                    final isSelected = _selectedCategory == item['category'];
                    
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      child: ListTile(
                        selected: isSelected,
                        selectedTileColor: Colors.blue.withOpacity(0.2),
                        leading: Icon(
                          _getNavbarIcon(item['icon']),
                          color: isSelected ? Colors.blue : Colors.white70,
                        ),
                        title: Text(
                          item['name'],
                          style: TextStyle(
                            color: isSelected ? Colors.blue : Colors.white,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedCategory = item['category'];
                            _selectedIndex = index;
                          });
                          _logAppEvent('info', 'Navigation item selected: ${item['name']}', 
                            category: 'navigation', 
                            metadata: {
                              'item': item['name'],
                              'category': item['category'],
                              'route': item['route'],
                            }
                          );
                        },
                      ),
                    );
                  },
                ),
          ),
          
          // Sidebar Footer
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white24, width: 1),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.white70, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Full Screen App',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Text(
                        '${_navbarItems.length} nav items',
                        style: const TextStyle(color: Colors.white54, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentForSelectedCategory() {
    switch (_selectedCategory) {
      case 'package_manager':
        return _buildPackageManagerView();
      case 'server_management':
        return _buildServerManagementView();
      case 'common_tools':
        return _buildCommonToolsView();
      case 'dashboard':
      default:
        return _buildDashboardView();
    }
  }

  Widget _buildDashboardView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.dashboard,
            size: 100,
            color: Colors.white,
          ),
          const SizedBox(height: 30),
          const Text(
            'Welcome to Dashboard',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
            'Full Screen Flutter App with Sidebars',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green, width: 1),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.fullscreen, color: Colors.green, size: 20),
                SizedBox(width: 10),
                Text(
                  'Always Full Screen Mode',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageManagerView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.inventory,
            size: 80,
            color: Colors.white,
          ),
          const SizedBox(height: 30),
          const Text(
            'Package Manager Status',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Expanded(
            child: _packageManagers.isEmpty 
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.white70),
                      SizedBox(height: 16),
                      Text(
                        'Loading package managers...',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                )
              : Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: _packageManagers.length,
                    itemBuilder: (context, index) {
                      final manager = _packageManagers[index];
                      return _buildPackageManagerCardFromData(manager);
                    },
                  ),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageManagerCardFromData(Map<String, dynamic> manager) {
    final name = manager['displayName'] ?? manager['name'] ?? 'Unknown';
    final iconName = manager['icon'] ?? 'inventory';
    final colorHex = manager['color'] ?? '#2196F3';
    final status = manager['status'] ?? 'unknown';
    final version = manager['version'] ?? '';
    
    // Parse hex color
    Color color;
    try {
      color = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    } catch (e) {
      color = Colors.blue;
    }
    
    // Get icon
    IconData icon = _getPackageManagerIcon(iconName);
    
    // Get status color
    Color statusColor;
    String statusText;
    switch (status) {
      case 'available':
        statusColor = Colors.green;
        statusText = 'Available';
        break;
      case 'unavailable':
        statusColor = Colors.red;
        statusText = 'Unavailable';
        break;
      case 'error':
        statusColor = Colors.orange;
        statusText = 'Error';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Unknown';
    }
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
            color: color,
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          if (version.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              'v$version',
              style: TextStyle(
                fontSize: 10,
                color: Colors.white70,
              ),
            ),
          ],
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                fontSize: 12,
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPackageManagerIcon(String iconName) {
    switch (iconName) {
      case 'inventory_2': return Icons.inventory_2;
      case 'cake': return Icons.cake;
      case 'flight': return Icons.flight;
      case 'code': return Icons.code;
      case 'terminal': return Icons.terminal;
      case 'package': return Icons.inventory;
      case 'build': return Icons.build;
      default: return Icons.inventory;
    }
  }

  Widget _buildServerManagementView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.dns,
            size: 100,
            color: Colors.white,
          ),
          const SizedBox(height: 30),
          const Text(
            'Server Management',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
            'Server management tools and services',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCommonToolsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.build,
            size: 100,
            color: Colors.white,
          ),
          const SizedBox(height: 30),
          const Text(
            'Common Tools',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
            'Common development and system tools',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRightSidebar() {
    return Container(
      width: 300,
      decoration: const BoxDecoration(
        color: Color(0xFF0f1419),
        border: Border(
          left: BorderSide(color: Colors.white24, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Sidebar Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white24, width: 1),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.dashboard, color: Colors.white, size: 24),
                const SizedBox(width: 10),
                const Text(
                  'Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _toggleRightSidebar,
                  icon: const Icon(Icons.close, color: Colors.white70),
                ),
              ],
            ),
          ),
          
          // Dashboard Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'System Status',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  FutureBuilder<Map<String, dynamic>?>(
                    future: PrismaClient.instance.getSystemStatus(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final status = snapshot.data!;
                        return Column(
                          children: [
                            _buildStatusCard('CPU Usage', '${status['cpuUsage']?.toStringAsFixed(1) ?? '45.0'}%', Icons.memory, Colors.green),
                            const SizedBox(height: 10),
                            _buildStatusCard('Memory', '${status['memoryUsage']?.toStringAsFixed(1) ?? '2.1'}GB / 8GB', Icons.storage, Colors.orange),
                            const SizedBox(height: 10),
                            _buildStatusCard('Network', status['networkStatus'] ?? 'Connected', Icons.wifi, Colors.blue),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          _buildStatusCard('CPU Usage', '45%', Icons.memory, Colors.green),
                          const SizedBox(height: 10),
                          _buildStatusCard('Memory', '2.1GB / 8GB', Icons.storage, Colors.orange),
                          const SizedBox(height: 10),
                          _buildStatusCard('Network', 'Connected', Icons.wifi, Colors.blue),
                        ],
                      );
                    },
                  ),
                  
                  const SizedBox(height: 30),
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildActionButton('Refresh', Icons.refresh),
                  const SizedBox(height: 10),
                  _buildActionButton('Settings', Icons.settings),
                  const SizedBox(height: 10),
                  _buildActionButton('Help', Icons.help_outline),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Top Controls
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _toggleLeftSidebar,
                  icon: Icon(
                    _leftSidebarVisible ? Icons.menu_open : Icons.menu,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const Text(
                  'Full Screen Flutter App',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: _toggleRightSidebar,
                  icon: Icon(
                    _rightSidebarVisible ? Icons.dashboard_outlined : Icons.dashboard,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          
          // Main Content
          Expanded(
            child: _buildContentForSelectedCategory(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                Text(
                  value,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 16),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.withOpacity(0.2),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  IconData _getNavbarIcon(String? iconName) {
    switch (iconName) {
      case 'dashboard': return Icons.dashboard;
      case 'package': return Icons.inventory;
      case 'server': return Icons.dns;
      case 'tools': return Icons.build;
      default: return Icons.circle;
    }
  }

  IconData _getMenuIcon(int index) {
    switch (index) {
      case 0: return Icons.home;
      case 1: return Icons.dashboard;
      case 2: return Icons.settings;
      case 3: return Icons.person;
      case 4: return Icons.help;
      default: return Icons.circle;
    }
  }
}
