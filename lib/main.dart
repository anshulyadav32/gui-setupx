import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

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

  final List<String> _menuItems = [
    'Home',
    'Dashboard',
    'Settings',
    'Profile',
    'Help',
  ];

  @override
  void initState() {
    super.initState();
    // Set full screen mode on Windows
    _setFullScreen();
    
    // Start timer to continuously maintain full screen mode
    _fullScreenTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        _forceFullScreen();
      }
    });
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
  }

  void _toggleRightSidebar() {
    setState(() {
      _rightSidebarVisible = !_rightSidebarVisible;
    });
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
                  onPressed: _toggleLeftSidebar,
                  icon: const Icon(Icons.close, color: Colors.white70),
                ),
              ],
            ),
          ),
          
          // Menu Items
          Expanded(
            child: ListView.builder(
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: ListTile(
                    selected: _selectedIndex == index,
                    selectedTileColor: Colors.blue.withOpacity(0.2),
                    leading: Icon(
                      _getMenuIcon(index),
                      color: _selectedIndex == index ? Colors.blue : Colors.white70,
                    ),
                    title: Text(
                      _menuItems[index],
                      style: TextStyle(
                        color: _selectedIndex == index ? Colors.blue : Colors.white,
                        fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
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
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.white70, size: 20),
                SizedBox(width: 10),
                Text(
                  'Full Screen App',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
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
                  _buildStatusCard('CPU Usage', '45%', Icons.memory, Colors.green),
                  const SizedBox(height: 10),
                  _buildStatusCard('Memory', '2.1GB / 8GB', Icons.storage, Colors.orange),
                  const SizedBox(height: 10),
                  _buildStatusCard('Network', 'Connected', Icons.wifi, Colors.blue),
                  
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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.fullscreen,
                    size: 100,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Welcome to ${_menuItems[_selectedIndex]}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'This app runs in full screen mode on Windows',
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
                  const SizedBox(height: 30),
                  const Text(
                    'This app runs in permanent full screen mode',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
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
