import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';
import '../models/package_manager.dart';
import '../models/common_tool.dart';
import '../models/dev_tool.dart';
import '../models/cross_platform_dev_tool.dart';
import '../models/wsl_tool.dart';

class DashboardView extends StatelessWidget {
  final List<PackageManager> packageManagers;
  final List<CommonTool> commonTools;
  final List<DevTool> devTools;
  final List<CrossPlatformDevTool> crossPlatformDevTools;
  final List<WSLTool> wslTools;
  final VoidCallback onInstallAllPackageManagers;
  final VoidCallback onInstallAllCommonTools;
  final VoidCallback onInstallAllDevTools;
  final VoidCallback onInstallAllCrossPlatformDevTools;
  final VoidCallback onInstallAllWSLTools;
  final Function(PackageManager) onCheckPackageManager;
  final Function(CommonTool) onCheckCommonTool;
  final Function(DevTool) onCheckDevTool;
  final Function(CrossPlatformDevTool) onCheckCrossPlatformDevTool;
  final Function(WSLTool) onCheckWSLTool;
  final Function(String) onNavigateToModule;

  const DashboardView({
    Key? key,
    required this.packageManagers,
    required this.commonTools,
    required this.devTools,
    required this.crossPlatformDevTools,
    required this.wslTools,
    required this.onInstallAllPackageManagers,
    required this.onInstallAllCommonTools,
    required this.onInstallAllDevTools,
    required this.onInstallAllCrossPlatformDevTools,
    required this.onInstallAllWSLTools,
    required this.onCheckPackageManager,
    required this.onCheckCommonTool,
    required this.onCheckDevTool,
    required this.onCheckCrossPlatformDevTool,
    required this.onCheckWSLTool,
    required this.onNavigateToModule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = ResponsiveHelper.isMobile(context);
        
        return Padding(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: isMobile ? 40 : 48,
                      height: isMobile ? 40 : 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: isMobile ? 12 : 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SetupX',
                          style: TextStyle(
                            fontSize: isMobile ? 24 : 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Development Environment Setup',
                          style: TextStyle(
                            fontSize: isMobile ? 12 : 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 20 : 30),

                // Statistics Cards
                _buildStatisticsCards(context, isMobile),
                SizedBox(height: isMobile ? 20 : 30),

                // Module Navigation Section
                _buildModuleNavigationSection(context, isMobile),
                SizedBox(height: isMobile ? 20 : 30),

                // Package Managers Section
                _buildPackageManagersSection(context, isMobile),
                SizedBox(height: isMobile ? 20 : 30),

                // Common Tools Section
                _buildCommonToolsSection(context, isMobile),
                SizedBox(height: isMobile ? 20 : 30),

                // Dev Tools Section
                _buildDevToolsSection(context, isMobile),
                SizedBox(height: isMobile ? 20 : 30),

                // Cross-Platform Dev Tools Section
                _buildCrossPlatformDevToolsSection(context, isMobile),
                SizedBox(height: isMobile ? 20 : 30),

                // WSL Tools Section
                _buildWSLToolsSection(context, isMobile),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatisticsCards(BuildContext context, bool isMobile) {
    final installedPackageManagers = packageManagers.where((p) => p.status == 'installed').length;
    final installedCommonTools = commonTools.where((t) => t.status == 'installed').length;
    final installedDevTools = devTools.where((t) => t.status == 'installed').length;
    final installedCrossPlatformDevTools = crossPlatformDevTools.where((t) => t.status == 'installed').length;
    final installedWSLTools = wslTools.where((t) => t.status == 'installed').length;
    
    final totalPackageManagers = packageManagers.length;
    final totalCommonTools = commonTools.length;
    final totalDevTools = devTools.length;
    final totalCrossPlatformDevTools = crossPlatformDevTools.length;
    final totalWSLTools = wslTools.length;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Package Managers',
                '$installedPackageManagers/$totalPackageManagers',
                'Installed',
                Icons.inventory_2,
                Colors.blue,
                isMobile,
              ),
            ),
            SizedBox(width: isMobile ? 12 : 16),
            Expanded(
              child: _buildStatCard(
                'Common Tools',
                '$installedCommonTools/$totalCommonTools',
                'Installed',
                Icons.build,
                Colors.green,
                isMobile,
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 12 : 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Dev Tools',
                '$installedDevTools/$totalDevTools',
                'Installed',
                Icons.code,
                Colors.orange,
                isMobile,
              ),
            ),
            SizedBox(width: isMobile ? 12 : 16),
            Expanded(
              child: _buildStatCard(
                'Cross-Platform Dev',
                '$installedCrossPlatformDevTools/$totalCrossPlatformDevTools',
                'Installed',
                Icons.devices,
                Colors.purple,
                isMobile,
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 12 : 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'WSL Tools',
                '$installedWSLTools/$totalWSLTools',
                'Installed',
                Icons.terminal,
                Colors.teal,
                isMobile,
              ),
            ),
            SizedBox(width: isMobile ? 12 : 16),
            Expanded(
              child: _buildStatCard(
                'Total Components',
                '${installedPackageManagers + installedCommonTools + installedDevTools + installedCrossPlatformDevTools + installedWSLTools}/${totalPackageManagers + totalCommonTools + totalDevTools + totalCrossPlatformDevTools + totalWSLTools}',
                'Installed',
                Icons.dashboard,
                Colors.indigo,
                isMobile,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModuleNavigationSection(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Module Navigation',
          style: TextStyle(
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isMobile ? 2 : 3,
          childAspectRatio: isMobile ? 1.2 : 1.5,
          crossAxisSpacing: isMobile ? 12 : 16,
          mainAxisSpacing: isMobile ? 12 : 16,
          children: [
            _buildModuleCard(
              'Package Manager',
              Icons.inventory_2,
              Colors.blue,
              'package_manager',
              isMobile,
            ),
            _buildModuleCard(
              'Common Tools',
              Icons.build,
              Colors.green,
              'common_tools',
              isMobile,
            ),
            _buildModuleCard(
              'Dev Tools',
              Icons.code,
              Colors.orange,
              'dev_tools',
              isMobile,
            ),
            _buildModuleCard(
              'Cross-Platform Dev',
              Icons.devices,
              Colors.purple,
              'cross_platform_dev',
              isMobile,
            ),
            _buildModuleCard(
              'WSL Tools',
              Icons.terminal,
              Colors.teal,
              'wsl',
              isMobile,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModuleCard(String title, IconData icon, Color color, String category, bool isMobile) {
    return GestureDetector(
      onTap: () => onNavigateToModule(category),
      child: Container(
        padding: EdgeInsets.all(isMobile ? 16 : 20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: isMobile ? 32 : 40, color: color),
            SizedBox(height: isMobile ? 8 : 12),
            Text(
              title,
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle, IconData icon, Color color, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: isMobile ? 32 : 40, color: color),
          SizedBox(height: isMobile ? 8 : 12),
          Text(
            value,
            style: TextStyle(
              fontSize: isMobile ? 20 : 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: isMobile ? 12 : 14,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: isMobile ? 4 : 8),
          Text(
            title,
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPackageManagersSection(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.inventory_2, size: isMobile ? 24 : 28, color: Colors.blue),
                  SizedBox(width: isMobile ? 8 : 12),
                  Text(
                    'Package Managers',
                    style: TextStyle(
                      fontSize: isMobile ? 18 : 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: onInstallAllPackageManagers,
                icon: const Icon(Icons.download, size: 16),
                label: const Text('Install All'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 12 : 16,
                    vertical: isMobile ? 8 : 10,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 16 : 20),
          _buildPackageManagerList(isMobile),
        ],
      ),
    );
  }

  Widget _buildPackageManagerList(bool isMobile) {
    return Column(
      children: packageManagers.take(3).map((manager) {
        final isInstalled = manager.status == 'installed';
        return Container(
          margin: EdgeInsets.only(bottom: isMobile ? 8 : 12),
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.inventory_2,
                size: isMobile ? 20 : 24,
                color: isInstalled ? Colors.green : Colors.orange,
              ),
              SizedBox(width: isMobile ? 12 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      manager.displayName,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      isInstalled ? 'Installed' : 'Not Installed',
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 14,
                        color: isInstalled ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => onCheckPackageManager(manager),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 8 : 12,
                    vertical: isMobile ? 4 : 6,
                  ),
                ),
                child: Text(
                  'Check',
                  style: TextStyle(fontSize: isMobile ? 12 : 14),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCommonToolsSection(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.build, size: isMobile ? 24 : 28, color: Colors.green),
                  SizedBox(width: isMobile ? 8 : 12),
                  Text(
                    'Common Tools',
                    style: TextStyle(
                      fontSize: isMobile ? 18 : 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: onInstallAllCommonTools,
                icon: const Icon(Icons.download, size: 16),
                label: const Text('Install All'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 12 : 16,
                    vertical: isMobile ? 8 : 10,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 16 : 20),
          _buildCommonToolsList(isMobile),
        ],
      ),
    );
  }

  Widget _buildCommonToolsList(bool isMobile) {
    return Column(
      children: commonTools.take(3).map((tool) {
        final isInstalled = tool.status == 'installed';
        return Container(
          margin: EdgeInsets.only(bottom: isMobile ? 8 : 12),
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.build,
                size: isMobile ? 20 : 24,
                color: isInstalled ? Colors.green : Colors.orange,
              ),
              SizedBox(width: isMobile ? 12 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tool.displayName,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      isInstalled ? 'Installed' : 'Not Installed',
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 14,
                        color: isInstalled ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => onCheckCommonTool(tool),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 8 : 12,
                    vertical: isMobile ? 4 : 6,
                  ),
                ),
                child: Text(
                  'Check',
                  style: TextStyle(fontSize: isMobile ? 12 : 14),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDevToolsSection(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.code, size: isMobile ? 24 : 28, color: Colors.orange),
                  SizedBox(width: isMobile ? 8 : 12),
                  Text(
                    'Dev Tools',
                    style: TextStyle(
                      fontSize: isMobile ? 18 : 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: onInstallAllDevTools,
                icon: const Icon(Icons.download, size: 16),
                label: const Text('Install All'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 12 : 16,
                    vertical: isMobile ? 8 : 10,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 16 : 20),
          _buildDevToolsList(isMobile),
        ],
      ),
    );
  }

  Widget _buildDevToolsList(bool isMobile) {
    return Column(
      children: devTools.take(3).map((tool) {
        final isInstalled = tool.status == 'installed';
        return Container(
          margin: EdgeInsets.only(bottom: isMobile ? 8 : 12),
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.code,
                color: isInstalled ? Colors.green : Colors.orange,
                size: isMobile ? 20 : 24,
              ),
              SizedBox(width: isMobile ? 8 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tool.displayName,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      isInstalled ? 'Installed' : 'Not Installed',
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 14,
                        color: isInstalled ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => onCheckDevTool(tool),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 8 : 12,
                    vertical: isMobile ? 4 : 6,
                  ),
                ),
                child: Text(
                  'Check',
                  style: TextStyle(fontSize: isMobile ? 12 : 14),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCrossPlatformDevToolsSection(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.devices, size: isMobile ? 24 : 28, color: Colors.purple),
                  SizedBox(width: isMobile ? 8 : 12),
                  Text(
                    'Cross-Platform Dev Tools',
                    style: TextStyle(
                      fontSize: isMobile ? 18 : 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: onInstallAllCrossPlatformDevTools,
                icon: const Icon(Icons.download, size: 16),
                label: const Text('Install All'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 12 : 16,
                    vertical: isMobile ? 8 : 10,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 16 : 20),
          _buildCrossPlatformDevToolsList(isMobile),
        ],
      ),
    );
  }

  Widget _buildCrossPlatformDevToolsList(bool isMobile) {
    return Column(
      children: crossPlatformDevTools.take(3).map((tool) {
        final isInstalled = tool.status == 'installed';
        return Container(
          margin: EdgeInsets.only(bottom: isMobile ? 8 : 12),
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.devices,
                color: isInstalled ? Colors.green : Colors.purple,
                size: isMobile ? 20 : 24,
              ),
              SizedBox(width: isMobile ? 8 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tool.displayName,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      isInstalled ? 'Installed' : 'Not Installed',
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 14,
                        color: isInstalled ? Colors.green : Colors.purple,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => onCheckCrossPlatformDevTool(tool),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 8 : 12,
                    vertical: isMobile ? 4 : 6,
                  ),
                ),
                child: Text(
                  'Check',
                  style: TextStyle(fontSize: isMobile ? 12 : 14),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWSLToolsSection(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.terminal, size: isMobile ? 24 : 28, color: Colors.teal),
                  SizedBox(width: isMobile ? 8 : 12),
                  Text(
                    'WSL Tools',
                    style: TextStyle(
                      fontSize: isMobile ? 18 : 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: onInstallAllWSLTools,
                icon: const Icon(Icons.download, size: 16),
                label: const Text('Install All'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 12 : 16,
                    vertical: isMobile ? 8 : 10,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 16 : 20),
          _buildWSLToolsList(isMobile),
        ],
      ),
    );
  }

  Widget _buildWSLToolsList(bool isMobile) {
    return Column(
      children: wslTools.take(3).map((tool) {
        final isInstalled = tool.status == 'installed';
        return Container(
          margin: EdgeInsets.only(bottom: isMobile ? 8 : 12),
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.terminal,
                color: isInstalled ? Colors.green : Colors.teal,
                size: isMobile ? 20 : 24,
              ),
              SizedBox(width: isMobile ? 8 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tool.displayName,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      isInstalled ? 'Installed' : 'Not Installed',
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 14,
                        color: isInstalled ? Colors.green : Colors.teal,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => onCheckWSLTool(tool),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 8 : 12,
                    vertical: isMobile ? 4 : 6,
                  ),
                ),
                child: Text(
                  'Check',
                  style: TextStyle(fontSize: isMobile ? 12 : 14),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
