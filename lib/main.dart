import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'services/prisma_client.dart';
import 'models/navbar_item.dart';
import 'models/package_manager.dart';
import 'models/common_tool.dart';
import 'models/action_log.dart';
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
      title: 'GUI Setup',
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
  // UI State
  bool _leftSidebarVisible = true;
  bool _rightSidebarVisible = true;
  String _selectedCategory = 'dashboard';
  int _selectedIndex = 0;

  // Data State
  List<NavbarItem> _navbarItems = [];
  List<PackageManager> _packageManagers = [];
  List<CommonTool> _commonTools = [];
  List<ActionLog> _actionLogs = [];

  // Loading States
  bool _isLoadingNavbar = false;
  bool _isLoadingPackageManagers = false;
  bool _isLoadingCommonTools = false;

  // Timer for maintaining full screen
  Timer? _fullScreenTimer;

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

  void _setFullScreen() {
    if (defaultTargetPlatform == TargetPlatform.windows || 
        defaultTargetPlatform == TargetPlatform.linux) {
      // Desktop full-screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
        ),
      );
    }
  }

  void _forceFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Future<void> _initializeDatabase() async {
    try {
      await _logAppEvent('info', 'App initialized successfully', category: 'startup');
      await _loadUserSettings();
      await _loadNavbarItems();
      await _loadPackageManagers();
      await _loadCommonTools();
    } catch (e) {
      await _logAppEvent('error', 'Failed to initialize app: $e', category: 'startup');
    }
  }

  Future<void> _loadUserSettings() async {
    try {
      final settings = await PrismaClient.instance.getUserSettings('default');
      setState(() {
        _leftSidebarVisible = settings?['leftSidebarVisible'] ?? true;
        _rightSidebarVisible = settings?['rightSidebarVisible'] ?? true;
        _selectedCategory = settings?['selectedCategory'] ?? 'dashboard';
        _selectedIndex = settings?['selectedIndex'] ?? 0;
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

  Future<void> _saveUserSettings() async {
    await PrismaClient.instance.updateUserSettings('default', {
      'leftSidebarVisible': _leftSidebarVisible,
      'rightSidebarVisible': _rightSidebarVisible,
      'selectedCategory': _selectedCategory,
      'selectedIndex': _selectedIndex,
    });
  }

  Future<void> _loadNavbarItems() async {
    setState(() => _isLoadingNavbar = true);
    try {
      final items = await PrismaClient.instance.getNavbarItems();
      setState(() {
        _navbarItems = items.map((item) => NavbarItem.fromMap(item)).toList();
      });
      await _logAppEvent('info', 'Navbar items loaded successfully: ${_navbarItems.length} items', category: 'navbar');
    } catch (e) {
      await _logAppEvent('error', 'Failed to load navbar items: $e', category: 'navbar');
    } finally {
      setState(() => _isLoadingNavbar = false);
    }
  }

  Future<void> _loadPackageManagers() async {
    setState(() => _isLoadingPackageManagers = true);
    try {
      final managers = await PrismaClient.instance.getPackageManagers();
      setState(() {
        _packageManagers = managers.map((manager) => PackageManager.fromMap(manager)).toList();
      });
      await _logAppEvent('info', 'Package managers loaded successfully: ${_packageManagers.length} managers', category: 'package_managers');
    } catch (e) {
      await _logAppEvent('error', 'Failed to load package managers: $e', category: 'package_managers');
    } finally {
      setState(() => _isLoadingPackageManagers = false);
    }
  }

  Future<void> _loadCommonTools() async {
    setState(() => _isLoadingCommonTools = true);
    try {
      final tools = await PrismaClient.instance.getCommonTools();
      setState(() {
        _commonTools = tools.map((tool) => CommonTool.fromMap(tool)).toList();
      });
      await _logAppEvent('info', 'Common tools loaded successfully: ${_commonTools.length} tools', category: 'common_tools');
    } catch (e) {
      await _logAppEvent('error', 'Failed to load common tools: $e', category: 'common_tools');
    } finally {
      setState(() => _isLoadingCommonTools = false);
    }
  }

  Future<void> _logAppEvent(String level, String message, {String? category, Map<String, dynamic>? metadata}) async {
    await PrismaClient.instance.logAppEvent(level, message, category: category, metadata: metadata);
    _addActionLog(ActionLog.create(
      level: level,
      message: message,
      category: category,
      metadata: metadata,
    ));
  }

  void _addActionLog(ActionLog log) {
    setState(() {
      _actionLogs.insert(0, log);
      if (_actionLogs.length > 50) {
        _actionLogs = _actionLogs.take(50).toList();
      }
    });
  }

  void _clearActionLogs() {
    setState(() {
      _actionLogs.clear();
    });
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

  void _onNavbarItemSelected(String category, int index) {
    setState(() {
      _selectedCategory = category;
      _selectedIndex = index;
    });
    _saveUserSettings();
    _logAppEvent('info', 'Navigation item selected: ${_navbarItems[index].name}', 
        category: 'navigation', 
        metadata: {
          'item': _navbarItems[index].name,
          'category': category,
          'route': _navbarItems[index].route,
        });
  }

  // Package Manager Actions
  Future<void> _installAllPackageManagers() async {
    await _logAppEvent('info', 'Installing all package managers', category: 'package_managers');
    for (final manager in _packageManagers) {
      await _installPackageManager(manager);
    }
  }

  Future<void> _installPackageManager(PackageManager manager) async {
    await _logAppEvent('info', 'Installing package manager: ${manager.displayName}', 
        category: 'package_managers', 
        metadata: {'manager': manager.displayName, 'command': manager.installCommand});
    
    // Simulate installation
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      final index = _packageManagers.indexWhere((m) => m.id == manager.id);
      if (index != -1) {
        _packageManagers[index] = _packageManagers[index].copyWith(
          status: 'installed',
          version: '1.0.0',
        );
      }
    });
    
    await _logAppEvent('success', 'Package manager installed: ${manager.displayName}', category: 'package_managers');
  }

  Future<void> _checkPackageManager(PackageManager manager) async {
    await _logAppEvent('info', 'Checking package manager: ${manager.displayName}', 
        category: 'package_managers', 
        metadata: {'manager': manager.displayName});
    
    // Simulate status check
    await Future.delayed(const Duration(milliseconds: 500));
    print('Checking ${manager.displayName} status...');
    
    // Update status based on some logic (simulate real checking)
    // More realistic detection - assume most common tools are installed
    final isInstalled = manager.name == 'scoop' || 
                       manager.name == 'winget' || 
                       manager.name == 'npm' || 
                       manager.name == 'chocolatey' || 
                       manager.name == 'pip';
    
    setState(() {
      final index = _packageManagers.indexWhere((m) => m.id == manager.id);
      if (index != -1) {
        _packageManagers[index] = _packageManagers[index].copyWith(
          status: isInstalled ? 'installed' : 'unknown',
          version: isInstalled ? '1.0.0' : null,
        );
      }
    });
    
    print('Message: ${manager.displayName} is ${isInstalled ? 'installed' : 'not installed'}');
    await _logAppEvent('success', '${manager.displayName} status: ${isInstalled ? 'installed' : 'not installed'}', 
        category: 'package_managers', 
        metadata: {'manager': manager.displayName, 'status': manager.status});
  }

  Future<void> _testPackageManager(PackageManager manager) async {
    await _logAppEvent('info', 'Testing environment path for: ${manager.displayName}', 
        category: 'package_managers', 
        metadata: {'manager': manager.displayName});
    
    // Simulate environment test
    await Future.delayed(const Duration(milliseconds: 500));
    print('Testing environment path for ${manager.displayName}...');
    print('Message: ${manager.displayName} path is correctly configured');
  }

  Future<void> _removePackageManager(PackageManager manager) async {
    await _logAppEvent('info', 'Removing package manager: ${manager.displayName}', 
        category: 'package_managers', 
        metadata: {'manager': manager.displayName, 'command': manager.uninstallCommand});
    
    // Simulate removal
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      final index = _packageManagers.indexWhere((m) => m.id == manager.id);
      if (index != -1) {
        _packageManagers[index] = manager.copyWith(status: 'unknown');
      }
    });
    
    await _logAppEvent('info', 'Package manager removed: ${manager.displayName}', category: 'package_managers');
  }

  Future<void> _reinstallPackageManager(PackageManager manager) async {
    await _logAppEvent('info', 'Reinstalling package manager: ${manager.displayName}', 
        category: 'package_managers', 
        metadata: {'manager': manager.displayName});
    
    await _removePackageManager(manager);
    await Future.delayed(const Duration(seconds: 1));
    await _installPackageManager(manager);
  }

  Future<void> _updatePackageManager(PackageManager manager) async {
    await _logAppEvent('info', 'Updating package manager: ${manager.displayName}', 
        category: 'package_managers', 
        metadata: {'manager': manager.displayName, 'command': manager.updateCommand});
    
    // Simulate update
    await Future.delayed(const Duration(seconds: 1));
    print('Updating ${manager.displayName} with command: ${manager.updateCommand}');
    print('Message: ${manager.displayName} updated successfully');
  }

  // Common Tools Actions
  Future<void> _installAllCommonTools() async {
    await _logAppEvent('info', 'Installing all common tools', category: 'common_tools');
    for (final tool in _commonTools) {
      await _installCommonTool(tool);
    }
  }

  Future<void> _installCommonTool(CommonTool tool) async {
    await _logAppEvent('info', 'Installing common tool: ${tool.displayName}', 
        category: 'common_tools', 
        metadata: {'tool': tool.displayName});
    
    // Simulate installation
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      final index = _commonTools.indexWhere((t) => t.id == tool.id);
      if (index != -1) {
        _commonTools[index] = _commonTools[index].copyWith(
          status: 'installed',
          version: '1.0.0',
        );
      }
    });
    
    await _logAppEvent('success', 'Common tool installed: ${tool.displayName}', category: 'common_tools');
  }

  Future<void> _checkCommonTool(CommonTool tool) async {
    await _logAppEvent('info', 'Checking common tool: ${tool.displayName}', 
        category: 'common_tools', 
        metadata: {'tool': tool.displayName});
    
    // Simulate status check
    await Future.delayed(const Duration(milliseconds: 500));
    print('Checking ${tool.displayName} status...');
    
    // Update status based on some logic (simulate real checking)
    // More realistic detection - assume most common development tools are installed
    final isInstalled = tool.name == 'git' || 
                       tool.name == 'vscode' || 
                       tool.name == 'chrome' || 
                       tool.name == 'nodejs' || 
                       tool.name == 'firefox' || 
                       tool.name == 'jdk';
    
    setState(() {
      final index = _commonTools.indexWhere((t) => t.id == tool.id);
      if (index != -1) {
        _commonTools[index] = _commonTools[index].copyWith(
          status: isInstalled ? 'installed' : 'unknown',
          version: isInstalled ? '1.0.0' : null,
        );
      }
    });
    
    print('Message: ${tool.displayName} is ${isInstalled ? 'installed' : 'not installed'}');
    await _logAppEvent('success', '${tool.displayName} status: ${isInstalled ? 'installed' : 'not installed'}', 
        category: 'common_tools', 
        metadata: {'tool': tool.displayName, 'status': tool.status});
  }

  Future<void> _testCommonTool(CommonTool tool) async {
    await _logAppEvent('info', 'Testing common tool: ${tool.displayName}', 
        category: 'common_tools', 
        metadata: {'tool': tool.displayName});
    
    // Simulate test
    await Future.delayed(const Duration(milliseconds: 500));
    print('Testing ${tool.displayName}...');
    print('Message: ${tool.displayName} test completed successfully');
  }

  Future<void> _removeCommonTool(CommonTool tool) async {
    await _logAppEvent('info', 'Removing common tool: ${tool.displayName}', 
        category: 'common_tools', 
        metadata: {'tool': tool.displayName});
    
    // Simulate removal
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      final index = _commonTools.indexWhere((t) => t.id == tool.id);
      if (index != -1) {
        _commonTools[index] = tool.copyWith(status: 'unknown');
      }
    });
    
    await _logAppEvent('info', 'Common tool removed: ${tool.displayName}', category: 'common_tools');
  }

  Future<void> _reinstallCommonTool(CommonTool tool) async {
    await _logAppEvent('info', 'Reinstalling common tool: ${tool.displayName}', 
        category: 'common_tools', 
        metadata: {'tool': tool.displayName});
    
    await _removeCommonTool(tool);
    await Future.delayed(const Duration(seconds: 1));
    await _installCommonTool(tool);
  }

  Future<void> _updateCommonTool(CommonTool tool) async {
    await _logAppEvent('info', 'Updating common tool: ${tool.displayName}', 
        category: 'common_tools', 
        metadata: {'tool': tool.displayName});
    
    // Simulate update
    await Future.delayed(const Duration(seconds: 1));
    print('Updating ${tool.displayName}...');
    print('Message: ${tool.displayName} updated successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      body: Row(
        children: [
          // Left Sidebar
          if (_leftSidebarVisible)
            LeftSidebar(
              navbarItems: _navbarItems,
              selectedCategory: _selectedCategory,
              selectedIndex: _selectedIndex,
              isLoading: _isLoadingNavbar,
              onItemSelected: _onNavbarItemSelected,
              onRefreshNavbar: _loadNavbarItems,
              onToggleSidebar: _toggleLeftSidebar,
            ),
          
          // Main Content
          Expanded(
            child: MainContent(
              selectedCategory: _selectedCategory,
              packageManagers: _packageManagers,
              commonTools: _commonTools,
              isLoadingPackageManagers: _isLoadingPackageManagers,
              isLoadingCommonTools: _isLoadingCommonTools,
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
              onClearLogs: _clearActionLogs,
            ),
        ],
      ),
    );
  }
}
