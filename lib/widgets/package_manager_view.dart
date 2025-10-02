import 'package:flutter/material.dart';
import '../models/package_manager.dart';
import '../utils/icon_helper.dart';
import '../utils/responsive_helper.dart';

class PackageManagerView extends StatelessWidget {
  final List<PackageManager> packageManagers;
  final bool isLoading;
  final VoidCallback onInstallAll;
  final Function(PackageManager) onInstall;
  final Function(PackageManager) onCheck;
  final Function(PackageManager) onTest;
  final Function(PackageManager) onRemove;
  final Function(PackageManager) onReinstall;
  final Function(PackageManager) onUpdate;

  const PackageManagerView({
    Key? key,
    required this.packageManagers,
    required this.isLoading,
    required this.onInstallAll,
    required this.onInstall,
    required this.onCheck,
    required this.onTest,
    required this.onRemove,
    required this.onReinstall,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = ResponsiveHelper.isMobile(context);
        final isTablet = ResponsiveHelper.isTablet(context);
        
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inventory,
                size: isMobile ? 60 : 80,
                color: Colors.white,
              ),
              SizedBox(height: isMobile ? 20 : 30),
              Text(
                'Package Manager Status',
                style: TextStyle(
                  fontSize: isMobile ? 24 : 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isMobile ? 20 : 30),
              
              // Install All Button
              if (!isLoading && packageManagers.isNotEmpty)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
                  child: ElevatedButton.icon(
                    onPressed: onInstallAll,
                    icon: const Icon(Icons.download),
                    label: const Text('Install All Package Managers'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 20 : 30,
                        vertical: isMobile ? 12 : 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              
              SizedBox(height: isMobile ? 20 : 30),
              
              // Package Managers Grid
              if (isLoading)
                const Center(
                  child: Column(
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
              else if (packageManagers.isEmpty)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: isMobile ? 60 : 80,
                        color: Colors.white54,
                      ),
                      SizedBox(height: isMobile ? 16 : 20),
                      Text(
                        'No package managers found',
                        style: TextStyle(
                          fontSize: isMobile ? 18 : 22,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: isMobile ? 8 : 12),
                      Text(
                        'Check your database connection',
                        style: TextStyle(
                          fontSize: isMobile ? 14 : 16,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final horizontalMargin = ResponsiveHelper.getGridMargin(context);
                      
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
                        child: ListView.builder(
                          itemCount: packageManagers.length,
                          itemBuilder: (context, index) {
                            final manager = packageManagers[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: isMobile ? 8 : 12),
                              child: _buildPackageManagerCard(context, manager, isMobile),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPackageManagerCard(BuildContext context, PackageManager manager, bool isMobile) {
    final isInstalled = manager.status == 'installed';
    final color = manager.color != null 
        ? Color(int.parse(manager.color!.replaceFirst('#', '0xFF')))
        : Colors.blue;
    
    return Container(
      constraints: BoxConstraints(
        minHeight: isMobile ? 90 : 110,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icon
              Icon(
                IconHelper.getPackageManagerIcon(manager.icon ?? 'inventory_2'),
                size: isMobile ? 32 : 40,
                color: color,
              ),
              SizedBox(width: isMobile ? 12 : 16),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      manager.displayName,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isMobile ? 2 : 4),
                    Text(
                      manager.description ?? '',
                      style: TextStyle(
                        fontSize: isMobile ? 11 : 13,
                        color: Colors.white70,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isMobile ? 4 : 6),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 6 : 8,
                        vertical: isMobile ? 2 : 3,
                      ),
                      decoration: BoxDecoration(
                        color: isInstalled ? Colors.green : Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isInstalled ? 'Installed' : 'Not Installed',
                        style: TextStyle(
                          fontSize: isMobile ? 9 : 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Action buttons
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Status check button
                  ElevatedButton.icon(
                    onPressed: () => onCheck(manager),
                    icon: const Icon(Icons.info, size: 16),
                    label: const Text('Check'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Action buttons based on status
                  if (!isInstalled) ...[
                    ElevatedButton.icon(
                      onPressed: () => onInstall(manager),
                      icon: const Icon(Icons.download, size: 16),
                      label: const Text('Install'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ] else ...[
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => onTest(manager),
                          icon: const Icon(Icons.route, size: 14),
                          label: const Text('Test'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        ElevatedButton.icon(
                          onPressed: () => onReinstall(manager),
                          icon: const Icon(Icons.refresh, size: 14),
                          label: const Text('Reinstall'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => onUpdate(manager),
                          icon: const Icon(Icons.upgrade, size: 14),
                          label: const Text('Update'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        ElevatedButton.icon(
                          onPressed: () => onRemove(manager),
                          icon: const Icon(Icons.delete, size: 14),
                          label: const Text('Remove'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
