import 'package:flutter/material.dart';
import 'dashboard_view.dart';
import 'package_manager_view.dart';
import 'common_tools_view.dart';

class MainContent extends StatelessWidget {
  final String selectedCategory;
  final List<Map<String, dynamic>> packageManagers;
  final List<Map<String, dynamic>> commonTools;
  final VoidCallback onInstallAllPackageManagers;
  final Function(Map<String, dynamic>) onInstallPackageManager;
  final Function(Map<String, dynamic>) onCheckPackageManager;
  final Function(Map<String, dynamic>) onTestPackageManager;
  final Function(Map<String, dynamic>) onRemovePackageManager;
  final Function(Map<String, dynamic>) onReinstallPackageManager;
  final Function(Map<String, dynamic>) onUpdatePackageManager;
  final VoidCallback onInstallAllCommonTools;
  final Function(Map<String, dynamic>) onInstallCommonTool;
  final Function(Map<String, dynamic>) onCheckCommonTool;
  final Function(Map<String, dynamic>) onTestCommonTool;
  final Function(Map<String, dynamic>) onRemoveCommonTool;
  final Function(Map<String, dynamic>) onReinstallCommonTool;
  final Function(Map<String, dynamic>) onUpdateCommonTool;

  const MainContent({
    Key? key,
    required this.selectedCategory,
    required this.packageManagers,
    required this.commonTools,
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final iconSize = isMobile ? 24.0 : 30.0;
        final titleFontSize = isMobile ? 18.0 : 24.0;
        final padding = isMobile ? 12.0 : 20.0;
        
        return SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Top Controls
              Padding(
                padding: EdgeInsets.all(padding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {}, // Will be handled by parent
                      icon: Icon(
                        Icons.menu_open,
                        color: Colors.white,
                        size: iconSize,
                      ),
                    ),
                    Text(
                      isMobile ? 'Flutter App' : 'Full Screen Flutter App',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {}, // Will be handled by parent
                      icon: Icon(
                        Icons.dashboard_outlined,
                        color: Colors.white,
                        size: iconSize,
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
      },
    );
  }

  Widget _buildContentForSelectedCategory() {
    switch (selectedCategory) {
      case 'package_manager':
        return PackageManagerView(
          packageManagers: packageManagers,
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
      case 'dashboard':
      default:
        return const DashboardView();
    }
  }
}
