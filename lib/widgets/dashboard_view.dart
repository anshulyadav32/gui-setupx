import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';
import '../models/package_manager.dart';
import '../models/common_tool.dart';

class DashboardView extends StatelessWidget {
  final List<PackageManager> packageManagers;
  final List<CommonTool> commonTools;
  final VoidCallback onInstallAllPackageManagers;
  final VoidCallback onInstallAllCommonTools;
  final Function(PackageManager) onCheckPackageManager;
  final Function(CommonTool) onCheckCommonTool;

  const DashboardView({
    Key? key,
    required this.packageManagers,
    required this.commonTools,
    required this.onInstallAllPackageManagers,
    required this.onInstallAllCommonTools,
    required this.onCheckPackageManager,
    required this.onCheckCommonTool,
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
                    Icon(
                      Icons.dashboard,
                      size: isMobile ? 32 : 40,
                      color: Colors.white,
                    ),
                    SizedBox(width: isMobile ? 12 : 16),
                    Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: isMobile ? 24 : 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 20 : 30),

                // Statistics Cards
                _buildStatisticsCards(context, isMobile),
                SizedBox(height: isMobile ? 20 : 30),

                // Package Managers Section
                _buildPackageManagersSection(context, isMobile),
                SizedBox(height: isMobile ? 20 : 30),

                // Common Tools Section
                _buildCommonToolsSection(context, isMobile),
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
    final totalPackageManagers = packageManagers.length;
    final totalCommonTools = commonTools.length;

    return Row(
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
}
