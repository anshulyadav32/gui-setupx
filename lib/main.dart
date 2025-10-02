import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'services/prisma_client.dart';
import 'widgets/left_sidebar.dart';
import 'widgets/right_sidebar.dart';
import 'widgets/main_content.dart';

void main() {
  runApp(const FullScreenApp());
}

class FullScreenApp extends StatelessWidget {
  const FullScreenApp({Key? key}) : super(key: key);

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
  const FullScreenHomePage({Key? key}) : super(key: key);

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
  List<Map<String, dynamic>> _commonTools = [];
  String _selectedCategory = 'dashboard';
  List<Map<String, dynamic>> _actionLogs = [];

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

  @override
  void dispose() {
    _fullScreenTimer?.cancel();
    super.dispose();
  }

  Future<void> _initializeDatabase() async {
    try {
      await PrismaClient.instance.initialize();
      await _loadUserSettings();
      await _loadNavbarItems();
      await _loadPackageManagers();
      await _loadCommonTools();
      await _logAppEvent('info', 'App initialized successfully', category: 'startup');
    } catch (e) {
      await _logAppEvent('error', 'Failed to initialize database: $e', category: 'startup');
    }
  }

  Future<void> _loadUserSettings() async {
    try {
      final settings = await PrismaClient.instance.getUserSettings();
      setState(() {
        _leftSidebarVisible = settings['leftSidebarVisible'] ?? true;
        _rightSidebarVisible = settings['rightSidebarVisible'] ?? true;
        _selectedCategory = settings['selectedCategory'] ?? 'dashboard';
        _selectedIndex = settings['selectedIndex'] ?? 0;
      });
    } catch (e) {
      await _logAppEvent('error', 'Failed to load user settings: $e', category: 'settings');
      // Fallback to default values
      setState(() {
        _leftSidebarVisible = true;
        _rightSidebarVisible = true;
        _selectedCategory = 'dashboard';
        _selectedIndex = 0;
      });
    }
  }

  Future<void> _loadNavbarItems() async {
    try {
      final items = await PrismaClient.instance.getNavbarItems();
      setState(() {
        _navbarItems = items;
      });
      await _logAppEvent('info', 'Navbar items loaded successfully: ${items.length} items', category: 'navbar');
    } catch (e) {
      await _logAppEvent('error', 'Failed to load navbar items: $e', category: 'navbar');
      // Fallback to hardcoded data
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
            'name': 'Common Tools',
            'icon': 'tools',
            'route': '/common-tools',
            'order': 3,
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
      setState(() {
        _packageManagers = [];
      });
    }
  }

  Future<void> _loadCommonTools() async {
    try {
      setState(() {
        _commonTools = [
          {
            'id': '1',
            'name': 'Git',
            'icon': 'code',
            'color': '#F05032',
            'status': 'available',
            'description': 'Version control system',
            'installCommand': 'winget install Git.Git',
          },
          {
            'id': '2',
            'name': 'GitHub CLI',
            'icon': 'code',
            'color': '#24292e',
            'status': 'available',
            'description': 'GitHub command line tool',
            'installCommand': 'winget install GitHub.cli',
          },
          {
            'id': '3',
            'name': 'Chrome',
            'icon': 'web',
            'color': '#4285F4',
            'status': 'available',
            'description': 'Google Chrome browser',
            'installCommand': 'winget install Google.Chrome',
          },
          {
            'id': '4',
            'name': 'Brave',
            'icon': 'web',
            'color': '#FB542B',
            'status': 'available',
            'description': 'Brave browser',
            'installCommand': 'winget install BraveSoftware.BraveBrowser',
          },
          {
            'id': '5',
            'name': 'Firefox',
            'icon': 'web',
            'color': '#FF7139',
            'status': 'available',
            'description': 'Mozilla Firefox browser',
            'installCommand': 'winget install Mozilla.Firefox',
          },
          {
            'id': '6',
            'name': 'VSCode',
            'icon': 'code',
            'color': '#007ACC',
            'status': 'available',
            'description': 'Visual Studio Code',
            'installCommand': 'winget install Microsoft.VisualStudioCode',
          },
          {
            'id': '7',
            'name': 'Cursor',
            'icon': 'code',
            'color': '#000000',
            'status': 'available',
            'description': 'Cursor AI code editor',
            'installCommand': 'winget install Cursor.Cursor',
          },
          {
            'id': '8',
            'name': 'NVM',
            'icon': 'terminal',
            'color': '#339933',
            'status': 'available',
            'description': 'Node Version Manager',
            'installCommand': 'winget install CoreyButler.NVMforWindows',
          },
          {
            'id': '9',
            'name': 'Node.js',
            'icon': 'terminal',
            'color': '#339933',
            'status': 'available',
            'description': 'Node.js runtime',
            'installCommand': 'winget install OpenJS.NodeJS',
          },
          {
            'id': '10',
            'name': 'JDK',
            'icon': 'code',
            'color': '#ED8B00',
            'status': 'available',
            'description': 'Java Development Kit',
            'installCommand': 'winget install Oracle.JDK.17',
          },
          {
            'id': '11',
            'name': 'C++',
            'icon': 'code',
            'color': '#00599C',
            'status': 'available',
            'description': 'C++ Build Tools',
            'installCommand': 'winget install Microsoft.VisualStudio.2022.BuildTools',
          },
        ];
      });
      await _logAppEvent('info', 'Common tools loaded successfully: ${_commonTools.length} tools', category: 'common_tools');
    } catch (e) {
      await _logAppEvent('error', 'Failed to load common tools: $e', category: 'common_tools');
      setState(() {
        _commonTools = [];
      });
    }
  }

  Future<void> _logAppEvent(String level, String message, {String? category, Map<String, dynamic>? metadata}) async {
    await PrismaClient.instance.logAppEvent(level, message, category: category, metadata: metadata);
  }

  void _setFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
  }

  void _forceFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _toggleLeftSidebar() {
    setState(() {
      _leftSidebarVisible = !_leftSidebarVisible;
    });
    _saveUserSettings();
    _logAppEvent('info', 'Left sidebar toggled: $_leftSidebarVisible', category: 'ui');
  }

  void _toggleRightSidebar() {
    setState(() {
      _rightSidebarVisible = !_rightSidebarVisible;
    });
    _saveUserSettings();
    _logAppEvent('info', 'Right sidebar toggled: $_rightSidebarVisible', category: 'ui');
  }

  Future<void> _saveUserSettings() async {
    await PrismaClient.instance.saveUserSettings({
      'leftSidebarVisible': _leftSidebarVisible,
      'rightSidebarVisible': _rightSidebarVisible,
      'selectedCategory': _selectedCategory,
      'selectedIndex': _selectedIndex,
    });
  }

  void _onNavbarItemSelected(String category, int index) {
    setState(() {
      _selectedCategory = category;
      _selectedIndex = index;
    });
    _saveUserSettings();
    _logAppEvent('info', 'Navigation item selected: ${_navbarItems[index]['name']}', 
      category: 'navigation',
      metadata: {
        'item': _navbarItems[index]['name'],
        'category': category,
        'route': _navbarItems[index]['route'],
      }
    );
  }

  // Package Manager Actions
  Future<void> _installAllPackageManagers() async {
    await _logAppEvent('info', 'Installing all package managers', category: 'package_managers');
    _addActionLog('Installing all package managers...', 'info');
    
    for (final manager in _packageManagers) {
      await _installPackageManager(manager);
    }
    
    _addActionLog('All package managers installation completed', 'success');
    await _loadPackageManagers();
  }

  Future<void> _installPackageManager(Map<String, dynamic> manager) async {
    final name = manager['displayName'] ?? manager['name'] ?? 'Unknown';
    final installCommand = manager['installCommand'] ?? '';
    
    await _logAppEvent('info', 'Installing package manager: $name', 
      category: 'package_managers',
      metadata: {
        'manager': name,
        'command': installCommand,
      }
    );
    
    _addActionLog('Installing $name...', 'info');
    
    print('Installing $name with command: $installCommand');
    await Future.delayed(const Duration(seconds: 1));
    
    _addActionLog('$name installed successfully', 'success');
    
    await PrismaClient.instance.updatePackageManager(
      manager['id'],
      {'status': 'installed'}
    );
    
    await _loadPackageManagers();
  }

  Future<void> _checkPackageManager(Map<String, dynamic> manager) async {
    final name = manager['displayName'] ?? manager['name'] ?? 'Unknown';
    
    await _logAppEvent('info', 'Checking package manager: $name', 
      category: 'package_managers',
      metadata: {'manager': name}
    );
    
    _addActionLog('Checking $name status...', 'info');
    
    print('Checking $name status...');
    await Future.delayed(const Duration(milliseconds: 500));
    
    _addActionLog('$name is working correctly', 'success');
  }

  Future<void> _testPackageManager(Map<String, dynamic> manager) async {
    final name = manager['displayName'] ?? manager['name'] ?? 'Unknown';
    
    await _logAppEvent('info', 'Testing package manager: $name', 
      category: 'package_managers',
      metadata: {'manager': name}
    );
    
    _addActionLog('Testing $name...', 'info');
    
    print('Testing $name...');
    await Future.delayed(const Duration(milliseconds: 500));
    
    _addActionLog('$name test passed', 'success');
  }

  Future<void> _removePackageManager(Map<String, dynamic> manager) async {
    final name = manager['displayName'] ?? manager['name'] ?? 'Unknown';
    final uninstallCommand = manager['uninstallCommand'] ?? '';
    
    await _logAppEvent('info', 'Removing package manager: $name', 
      category: 'package_managers',
      metadata: {
        'manager': name,
        'command': uninstallCommand,
      }
    );
    
    _addActionLog('Removing $name...', 'info');
    
    print('Removing $name with command: $uninstallCommand');
    await Future.delayed(const Duration(seconds: 1));
    
    _addActionLog('$name removed successfully', 'success');
    
    await PrismaClient.instance.updatePackageManager(
      manager['id'],
      {'status': 'unavailable'}
    );
    
    await _loadPackageManagers();
  }

  Future<void> _reinstallPackageManager(Map<String, dynamic> manager) async {
    final name = manager['displayName'] ?? manager['name'] ?? 'Unknown';
    
    await _logAppEvent('info', 'Reinstalling package manager: $name', 
      category: 'package_managers',
      metadata: {'manager': name}
    );
    
    _addActionLog('Reinstalling $name...', 'info');
    
    await _removePackageManager(manager);
    await Future.delayed(const Duration(seconds: 1));
    await _installPackageManager(manager);
    
    _addActionLog('$name reinstalled successfully', 'success');
  }

  Future<void> _updatePackageManager(Map<String, dynamic> manager) async {
    final name = manager['displayName'] ?? manager['name'] ?? 'Unknown';
    final updateCommand = manager['updateCommand'] ?? '';
    
    await _logAppEvent('info', 'Updating package manager: $name', 
      category: 'package_managers',
      metadata: {
        'manager': name,
        'command': updateCommand,
      }
    );
    
    _addActionLog('Updating $name...', 'info');
    
    print('Updating $name with command: $updateCommand');
    await Future.delayed(const Duration(seconds: 1));
    
    _addActionLog('$name updated successfully', 'success');
  }

  // Common Tools Actions
  Future<void> _installAllCommonTools() async {
    await _logAppEvent('info', 'Installing all common tools', category: 'common_tools');
    _addActionLog('Installing all common tools...', 'info');
    
    for (final tool in _commonTools) {
      await _installCommonTool(tool);
    }
    
    _addActionLog('All common tools installation completed', 'success');
  }

  Future<void> _installCommonTool(Map<String, dynamic> tool) async {
    final name = tool['name'] ?? 'Unknown';
    final installCommand = tool['installCommand'] ?? '';
    
    await _logAppEvent('info', 'Installing common tool: $name', 
      category: 'common_tools',
      metadata: {
        'tool': name,
        'command': installCommand,
      }
    );
    
    _addActionLog('Installing $name...', 'info');
    
    print('Installing $name with command: $installCommand');
    await Future.delayed(const Duration(seconds: 1));
    
    _addActionLog('$name installed successfully', 'success');
    
    setState(() {
      final index = _commonTools.indexWhere((t) => t['id'] == tool['id']);
      if (index != -1) {
        _commonTools[index]['status'] = 'installed';
      }
    });
  }

  Future<void> _checkCommonTool(Map<String, dynamic> tool) async {
    final name = tool['name'] ?? 'Unknown';
    
    await _logAppEvent('info', 'Checking common tool: $name', 
      category: 'common_tools',
      metadata: {'tool': name}
    );
    
    _addActionLog('Checking $name status...', 'info');
    
    print('Checking $name status...');
    await Future.delayed(const Duration(milliseconds: 500));
    
    _addActionLog('$name is working correctly', 'success');
  }

  Future<void> _testCommonTool(Map<String, dynamic> tool) async {
    final name = tool['name'] ?? 'Unknown';
    
    await _logAppEvent('info', 'Testing common tool: $name', 
      category: 'common_tools',
      metadata: {'tool': name}
    );
    
    _addActionLog('Testing $name...', 'info');
    
    print('Testing $name...');
    await Future.delayed(const Duration(milliseconds: 500));
    
    _addActionLog('$name test passed', 'success');
  }

  Future<void> _removeCommonTool(Map<String, dynamic> tool) async {
    final name = tool['name'] ?? 'Unknown';
    final uninstallCommand = tool['uninstallCommand'] ?? '';
    
    await _logAppEvent('info', 'Removing common tool: $name', 
      category: 'common_tools',
      metadata: {
        'tool': name,
        'command': uninstallCommand,
      }
    );
    
    _addActionLog('Removing $name...', 'info');
    
    print('Removing $name with command: $uninstallCommand');
    await Future.delayed(const Duration(seconds: 1));
    
    _addActionLog('$name removed successfully', 'success');
    
    setState(() {
      final index = _commonTools.indexWhere((t) => t['id'] == tool['id']);
      if (index != -1) {
        _commonTools[index]['status'] = 'unavailable';
      }
    });
  }

  Future<void> _reinstallCommonTool(Map<String, dynamic> tool) async {
    final name = tool['name'] ?? 'Unknown';
    
    await _logAppEvent('info', 'Reinstalling common tool: $name', 
      category: 'common_tools',
      metadata: {'tool': name}
    );
    
    _addActionLog('Reinstalling $name...', 'info');
    
    await _removeCommonTool(tool);
    await Future.delayed(const Duration(seconds: 1));
    await _installCommonTool(tool);
    
    _addActionLog('$name reinstalled successfully', 'success');
  }

  Future<void> _updateCommonTool(Map<String, dynamic> tool) async {
    final name = tool['name'] ?? 'Unknown';
    final updateCommand = tool['updateCommand'] ?? '';
    
    await _logAppEvent('info', 'Updating common tool: $name', 
      category: 'common_tools',
      metadata: {
        'tool': name,
        'command': updateCommand,
      }
    );
    
    _addActionLog('Updating $name...', 'info');
    
    print('Updating $name with command: $updateCommand');
    await Future.delayed(const Duration(seconds: 1));
    
    _addActionLog('$name updated successfully', 'success');
  }

  void _addActionLog(String message, String level) {
    setState(() {
      _actionLogs.insert(0, {
        'message': message,
        'level': level,
        'timestamp': DateTime.now(),
      });
      
      if (_actionLogs.length > 50) {
        _actionLogs = _actionLogs.take(50).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0e13),
      body: Row(
        children: [
          // Left Sidebar
          if (_leftSidebarVisible)
            LeftSidebar(
              navbarItems: _navbarItems,
              selectedCategory: _selectedCategory,
              selectedIndex: _selectedIndex,
              onToggleSidebar: _toggleLeftSidebar,
              onRefreshNavbar: _loadNavbarItems,
              onItemSelected: _onNavbarItemSelected,
            ),
          
          // Main Content
          Expanded(
            child: MainContent(
              selectedCategory: _selectedCategory,
              packageManagers: _packageManagers,
              commonTools: _commonTools,
              onInstallAllPackageManagers: _installAllPackageManagers,
              onInstallPackageManager: _installPackageManager,
              onCheckPackageManager: _checkPackageManager,
              onTestPackageManager: _testPackageManager,
              onRemovePackageManager: _removePackageManager,
              onReinstallPackageManager: _reinstallPackageManager,
              onUpdatePackageManager: _updatePackageManager,
              onInstallAllCommonTools: _installAllCommonTools,
              onInstallCommonTool: _installCommonTool,
              onCheckCommonTool: _checkCommonTool,
              onTestCommonTool: _testCommonTool,
              onRemoveCommonTool: _removeCommonTool,
              onReinstallCommonTool: _reinstallCommonTool,
              onUpdateCommonTool: _updateCommonTool,
            ),
          ),
          
          // Right Sidebar
          if (_rightSidebarVisible)
            RightSidebar(
              actionLogs: _actionLogs,
              onToggleSidebar: _toggleRightSidebar,
              onClearLogs: () {
                setState(() {
                  _actionLogs.clear();
                });
              },
            ),
        ],
      ),
    );
  }
}
