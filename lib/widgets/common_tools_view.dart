import 'package:flutter/material.dart';

class CommonToolsView extends StatelessWidget {
  final List<Map<String, dynamic>> commonTools;
  final VoidCallback onInstallAll;
  final Function(Map<String, dynamic>) onInstall;
  final Function(Map<String, dynamic>) onCheck;
  final Function(Map<String, dynamic>) onTest;
  final Function(Map<String, dynamic>) onRemove;
  final Function(Map<String, dynamic>) onReinstall;
  final Function(Map<String, dynamic>) onUpdate;

  const CommonToolsView({
    Key? key,
    required this.commonTools,
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
        final isMobile = constraints.maxWidth < 600;
        final isTablet = constraints.maxWidth < 1000;
        
        // Calculate grid columns based on screen size
        int crossAxisCount;
        double childAspectRatio;
        double horizontalMargin;
        double iconSize;
        double titleFontSize;
        
        if (isMobile) {
          crossAxisCount = 1;
          childAspectRatio = 2.5;
          horizontalMargin = 20;
          iconSize = 60;
          titleFontSize = 24;
        } else if (isTablet) {
          crossAxisCount = 2;
          childAspectRatio = 2.0;
          horizontalMargin = 30;
          iconSize = 70;
          titleFontSize = 26;
        } else {
          crossAxisCount = 3;
          childAspectRatio = 1.6;
          horizontalMargin = 40;
          iconSize = 80;
          titleFontSize = 28;
        }
        
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.build,
                size: iconSize,
                color: Colors.white,
              ),
              SizedBox(height: isMobile ? 20 : 30),
              Text(
                'Common Development Tools',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isMobile ? 15 : 20),
              // Install All Button
              Container(
                margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
                child: ElevatedButton.icon(
                  onPressed: onInstallAll,
                  icon: Icon(Icons.download, color: Colors.white),
                  label: Text(
                    'Install All Common Tools',
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 20 : 30, 
                      vertical: isMobile ? 12 : 15
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(height: isMobile ? 15 : 20),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: isMobile ? 10 : 20,
                      mainAxisSpacing: isMobile ? 10 : 20,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemCount: commonTools.length,
                    itemBuilder: (context, index) {
                      final tool = commonTools[index];
                      return _buildCommonToolCard(tool);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCommonToolCard(Map<String, dynamic> tool) {
    final name = tool['name'] ?? 'Unknown';
    final iconName = tool['icon'] ?? 'code';
    final colorHex = tool['color'] ?? '#007ACC';
    final status = tool['status'] ?? 'available';
    final description = tool['description'] ?? '';
    final isInstalled = status == 'installed';
    
    // Parse hex color
    Color color;
    try {
      color = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    } catch (e) {
      color = Colors.blue;
    }
    
    // Get icon
    IconData icon = _getCommonToolIcon(iconName);
    
    // Get status color
    Color statusColor;
    String statusText;
    switch (status) {
      case 'installed':
        statusColor = Colors.green;
        statusText = 'Installed';
        break;
      case 'unavailable':
        statusColor = Colors.red;
        statusText = 'Not Installed';
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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Header with icon and name
            Row(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: color,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      if (description.isNotEmpty)
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white70,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 10,
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Status check button (always visible)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => onCheck(tool),
                icon: const Icon(Icons.info, size: 16),
                label: const Text('Check Status', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            // Action buttons based on status
            if (!isInstalled) ...[
              // Install button for not installed
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => onInstall(tool),
                  icon: const Icon(Icons.download, size: 16),
                  label: const Text('Install', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ] else ...[
              // Action buttons for installed tools
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => onTest(tool),
                      icon: const Icon(Icons.route, size: 14),
                      label: const Text('Test Env', style: TextStyle(fontSize: 10)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => onReinstall(tool),
                      icon: const Icon(Icons.refresh, size: 14),
                      label: const Text('Reinstall', style: TextStyle(fontSize: 10)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => onUpdate(tool),
                      icon: const Icon(Icons.upgrade, size: 14),
                      label: const Text('Update', style: TextStyle(fontSize: 10)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => onRemove(tool),
                      icon: const Icon(Icons.delete, size: 14),
                      label: const Text('Remove', style: TextStyle(fontSize: 10)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getCommonToolIcon(String iconName) {
    switch (iconName) {
      case 'code': return Icons.code;
      case 'web': return Icons.web;
      case 'terminal': return Icons.terminal;
      case 'build': return Icons.build;
      default: return Icons.code;
    }
  }
}
