import 'package:flutter/material.dart';
import '../models/common_tool.dart';
import '../utils/responsive_helper.dart';
import '../utils/icon_helper.dart';

class CommonToolsView extends StatelessWidget {
  final List<CommonTool> commonTools;
  final VoidCallback onInstallAll;
  final Function(CommonTool) onInstall;
  final Function(CommonTool) onCheck;
  final Function(CommonTool) onTest;
  final Function(CommonTool) onRemove;
  final Function(CommonTool) onReinstall;
  final Function(CommonTool) onUpdate;

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
    final isMobile = ResponsiveHelper.isMobile(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            // Header with Install All button
            Container(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Common Tools',
                    style: TextStyle(
                      fontSize: isMobile ? 24 : 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: onInstallAll,
                    icon: const Icon(Icons.download),
                    label: const Text('Install All'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Tools list
            if (commonTools.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Loading common tools...',
                        style: TextStyle(
                          fontSize: isMobile ? 16 : 18,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
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
                        itemCount: commonTools.length,
                        itemBuilder: (context, index) {
                          final tool = commonTools[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: isMobile ? 8 : 12),
                            child: _buildCommonToolCard(context, tool, isMobile),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildCommonToolCard(BuildContext context, CommonTool tool, bool isMobile) {
    final isInstalled = tool.status == 'installed';
    final color = tool.color != null 
        ? Color(int.parse(tool.color!.replaceFirst('#', '0xFF')))
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
                IconHelper.getCommonToolIcon(tool.icon ?? 'build'),
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
                      tool.displayName,
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
                      tool.description ?? '',
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
                    onPressed: () => onCheck(tool),
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
                      onPressed: () => onInstall(tool),
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
                          onPressed: () => onTest(tool),
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
                          onPressed: () => onReinstall(tool),
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
                          onPressed: () => onUpdate(tool),
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
                          onPressed: () => onRemove(tool),
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