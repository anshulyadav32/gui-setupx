import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';
import 'dashboard_view.dart';
import 'package_manager_view.dart';
import 'common_tools_view.dart';
import '../models/package_manager.dart';
import '../models/common_tool.dart';

class MainContent extends StatelessWidget {
  final String selectedCategory;
  final List<PackageManager> packageManagers;
  final List<CommonTool> commonTools;
  final bool isLoadingPackageManagers;
  final bool isLoadingCommonTools;
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

  const MainContent({
    Key? key,
    required this.selectedCategory,
    required this.packageManagers,
    required this.commonTools,
    required this.isLoadingPackageManagers,
    required this.isLoadingCommonTools,
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
      case 'dashboard':
      default:
        return DashboardView(
          packageManagers: packageManagers,
          commonTools: commonTools,
          onInstallAllPackageManagers: onInstallAllPackageManagers,
          onInstallAllCommonTools: onInstallAllCommonTools,
          onCheckPackageManager: onCheckPackageManager,
          onCheckCommonTool: onCheckCommonTool,
        );
    }
  }

  IconData _getCategoryIcon() {
    switch (selectedCategory) {
      case 'package_manager':
        return Icons.inventory;
      case 'common_tools':
        return Icons.build;
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
      case 'dashboard':
      default:
        return 'Dashboard';
    }
  }
}
