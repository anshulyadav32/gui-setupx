import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';
import 'dashboard_view.dart';
import 'package_manager_view.dart';
import 'common_tools_view.dart';
import 'dev_tools_view.dart';
import 'cross_platform_dev_tools_view.dart';
import '../models/package_manager.dart';
import '../models/common_tool.dart';
import '../models/dev_tool.dart';
import '../models/cross_platform_dev_tool.dart';
import '../models/wsl_tool.dart';

class MainContent extends StatelessWidget {
  final String selectedCategory;
  final List<PackageManager> packageManagers;
  final List<CommonTool> commonTools;
  final List<DevTool> devTools;
  final List<CrossPlatformDevTool> crossPlatformDevTools;
  final List<WSLTool> wslTools;
  final bool isLoadingPackageManagers;
  final bool isLoadingCommonTools;
  final bool isLoadingDevTools;
  final bool isLoadingCrossPlatformDevTools;
  final bool isLoadingWSLTools;
  final VoidCallback onInstallAllPackageManagers;
  final Function(PackageManager) onInstallPackageManager;
  final Function(PackageManager) onCheckPackageManager;
  final Function(PackageManager) onTestPackageManager;
  final Function(PackageManager) onRemovePackageManager;
  final Function(PackageManager) onReinstallPackageManager;
  final Function(PackageManager) onUpdatePackageManager;
  final VoidCallback onInstallAllCommonTools;
  final Function(CommonTool) onInstallCommonTool;
  final Function(CommonTool) onCheckCommonTool;
  final Function(CommonTool) onTestCommonTool;
  final Function(CommonTool) onRemoveCommonTool;
  final Function(CommonTool) onReinstallCommonTool;
  final Function(CommonTool) onUpdateCommonTool;
  final VoidCallback onInstallAllDevTools;
  final Function(DevTool) onInstallDevTool;
  final Function(DevTool) onCheckDevTool;
  final Function(DevTool) onTestDevTool;
  final Function(DevTool) onRemoveDevTool;
  final Function(DevTool) onReinstallDevTool;
  final Function(DevTool) onUpdateDevTool;
  final VoidCallback onInstallAllCrossPlatformDevTools;
  final Function(CrossPlatformDevTool) onInstallCrossPlatformDevTool;
  final Function(CrossPlatformDevTool) onCheckCrossPlatformDevTool;
  final Function(CrossPlatformDevTool) onTestCrossPlatformDevTool;
  final Function(CrossPlatformDevTool) onRemoveCrossPlatformDevTool;
  final Function(CrossPlatformDevTool) onReinstallCrossPlatformDevTool;
  final Function(CrossPlatformDevTool) onUpdateCrossPlatformDevTool;
  final VoidCallback onInstallAllWSLTools;
  final Function(WSLTool) onInstallWSLTool;
  final Function(WSLTool) onCheckWSLTool;
  final Function(WSLTool) onTestWSLTool;
  final Function(WSLTool) onRemoveWSLTool;
  final Function(WSLTool) onReinstallWSLTool;
  final Function(WSLTool) onUpdateWSLTool;
  final Function(String) onNavigateToModule;

  const MainContent({
    Key? key,
    required this.selectedCategory,
    required this.packageManagers,
    required this.commonTools,
    required this.devTools,
    required this.crossPlatformDevTools,
    required this.wslTools,
    required this.isLoadingPackageManagers,
    required this.isLoadingCommonTools,
    required this.isLoadingDevTools,
    required this.isLoadingCrossPlatformDevTools,
    required this.isLoadingWSLTools,
    required this.onInstallAllPackageManagers,
    required this.onInstallPackageManager,
    required this.onCheckPackageManager,
    required this.onTestPackageManager,
    required this.onRemovePackageManager,
    required this.onReinstallPackageManager,
    required this.onUpdatePackageManager,
    required this.onInstallAllCommonTools,
    required this.onInstallCommonTool,
    required this.onCheckCommonTool,
    required this.onTestCommonTool,
    required this.onRemoveCommonTool,
    required this.onReinstallCommonTool,
    required this.onUpdateCommonTool,
    required this.onInstallAllDevTools,
    required this.onInstallDevTool,
    required this.onCheckDevTool,
    required this.onTestDevTool,
    required this.onRemoveDevTool,
    required this.onReinstallDevTool,
    required this.onUpdateDevTool,
    required this.onInstallAllCrossPlatformDevTools,
    required this.onInstallCrossPlatformDevTool,
    required this.onCheckCrossPlatformDevTool,
    required this.onTestCrossPlatformDevTool,
    required this.onRemoveCrossPlatformDevTool,
    required this.onReinstallCrossPlatformDevTool,
    required this.onUpdateCrossPlatformDevTool,
    required this.onInstallAllWSLTools,
    required this.onInstallWSLTool,
    required this.onCheckWSLTool,
    required this.onTestWSLTool,
    required this.onRemoveWSLTool,
    required this.onReinstallWSLTool,
    required this.onUpdateWSLTool,
    required this.onNavigateToModule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = ResponsiveHelper.isMobile(context);
        final iconSize = isMobile ? 24.0 : 30.0;
        final titleFontSize = isMobile ? 18.0 : 24.0;
        final padding = isMobile ? 12.0 : 20.0;
        
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1A1A2E),
                Color(0xFF16213E),
                Color(0xFF0F3460),
              ],
            ),
          ),
          child: Column(
            children: [
              // App Bar
              Container(
                padding: EdgeInsets.all(padding),
                decoration: const BoxDecoration(
                  color: Color(0xFF2C3E50),
                  border: Border(
                    bottom: BorderSide(color: Colors.white24, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getCategoryIcon(),
                      size: iconSize,
                      color: Colors.white,
                    ),
                    SizedBox(width: isMobile ? 8 : 12),
                    Text(
                      _getCategoryTitle(),
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 8 : 12,
                        vertical: isMobile ? 4 : 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.blue.withOpacity(0.5)),
                      ),
                      child: Text(
                        'Always Full Screen Mode',
                        style: TextStyle(
                          fontSize: isMobile ? 10 : 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: _buildContentForSelectedCategory(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContentForSelectedCategory() {
    switch (selectedCategory) {
      case 'package_manager':
        return PackageManagerView(
          packageManagers: packageManagers,
          isLoading: isLoadingPackageManagers,
          onInstallAll: onInstallAllPackageManagers,
          onInstall: onInstallPackageManager,
          onCheck: onCheckPackageManager,
          onTest: onTestPackageManager,
          onRemove: onRemovePackageManager,
          onReinstall: onReinstallPackageManager,
          onUpdate: onUpdatePackageManager,
        );
      case 'common_tools':
        return CommonToolsView(
          commonTools: commonTools,
          onInstallAll: onInstallAllCommonTools,
          onInstall: onInstallCommonTool,
          onCheck: onCheckCommonTool,
          onTest: onTestCommonTool,
          onRemove: onRemoveCommonTool,
          onReinstall: onReinstallCommonTool,
          onUpdate: onUpdateCommonTool,
        );
      case 'dev_tools':
        return DevToolsView(
          devTools: devTools,
          onInstallAll: onInstallAllDevTools,
          onInstall: onInstallDevTool,
          onCheck: onCheckDevTool,
          onTest: onTestDevTool,
          onRemove: onRemoveDevTool,
          onReinstall: onReinstallDevTool,
          onUpdate: onUpdateDevTool,
        );
      case 'cross_platform_dev':
        return CrossPlatformDevToolsView(
          crossPlatformDevTools: crossPlatformDevTools,
          onInstallAll: onInstallAllCrossPlatformDevTools,
          onInstall: onInstallCrossPlatformDevTool,
          onCheck: onCheckCrossPlatformDevTool,
          onTest: onTestCrossPlatformDevTool,
          onRemove: onRemoveCrossPlatformDevTool,
          onReinstall: onReinstallCrossPlatformDevTool,
          onUpdate: onUpdateCrossPlatformDevTool,
        );
      case 'dashboard':
      default:
        return DashboardView(
          packageManagers: packageManagers,
          commonTools: commonTools,
          devTools: devTools,
          crossPlatformDevTools: crossPlatformDevTools,
          wslTools: wslTools,
          onInstallAllPackageManagers: onInstallAllPackageManagers,
          onInstallAllCommonTools: onInstallAllCommonTools,
          onInstallAllDevTools: onInstallAllDevTools,
          onInstallAllCrossPlatformDevTools: onInstallAllCrossPlatformDevTools,
          onInstallAllWSLTools: onInstallAllWSLTools,
          onCheckPackageManager: onCheckPackageManager,
          onCheckCommonTool: onCheckCommonTool,
          onCheckDevTool: onCheckDevTool,
          onCheckCrossPlatformDevTool: onCheckCrossPlatformDevTool,
          onCheckWSLTool: onCheckWSLTool,
          onNavigateToModule: onNavigateToModule,
        );
    }
  }

  IconData _getCategoryIcon() {
    switch (selectedCategory) {
      case 'package_manager':
        return Icons.inventory;
      case 'common_tools':
        return Icons.build;
      case 'dev_tools':
        return Icons.code;
      case 'cross_platform_dev':
        return Icons.devices;
      case 'dashboard':
      default:
        return Icons.dashboard;
    }
  }

  String _getCategoryTitle() {
    switch (selectedCategory) {
      case 'package_manager':
        return 'Package Manager';
      case 'common_tools':
        return 'Common Tools';
      case 'dev_tools':
        return 'Dev Tools';
      case 'cross_platform_dev':
        return 'Cross-Platform Dev';
      case 'dashboard':
      default:
        return 'Dashboard';
    }
  }
}
