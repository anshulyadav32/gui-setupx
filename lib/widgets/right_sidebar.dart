import 'package:flutter/material.dart';
import '../models/action_log.dart';
import '../utils/icon_helper.dart';
import '../utils/responsive_helper.dart';

class RightSidebar extends StatelessWidget {
  final List<ActionLog> actionLogs;
  final VoidCallback onToggleSidebar;
  final VoidCallback onClearLogs;

  const RightSidebar({
    Key? key,
    required this.actionLogs,
    required this.onToggleSidebar,
    required this.onClearLogs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = ResponsiveHelper.isMobile(context);
        final sidebarWidth = ResponsiveHelper.getRightSidebarWidth(context);
        
        return Container(
          width: sidebarWidth,
          decoration: const BoxDecoration(
            color: Color(0xFF34495E),
            border: Border(
              left: BorderSide(color: Colors.white24, width: 1),
            ),
          ),
          child: Column(
            children: [
              // Sidebar Header
              Container(
                padding: EdgeInsets.all(isMobile ? 16 : 20),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.white24, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.dashboard, color: Colors.white, size: isMobile ? 16 : 20),
                    SizedBox(width: isMobile ? 6 : 8),
                    Expanded(
                      child: Text(
                        'Action Logs',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isMobile ? 14 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: onToggleSidebar,
                      icon: Icon(Icons.close, color: Colors.white70, size: isMobile ? 16 : 18),
                      constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                      padding: EdgeInsets.all(isMobile ? 4 : 6),
                    ),
                  ],
                ),
              ),
              
              // Action Logs Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 12 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Recent Actions',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isMobile ? 16 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: onClearLogs,
                            icon: Icon(Icons.clear_all, size: isMobile ? 16 : 18, color: Colors.white70),
                            label: Text(
                              'Clear',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: isMobile ? 12 : 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isMobile ? 8 : 12),
                      Expanded(
                        child: actionLogs.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.history,
                                      size: isMobile ? 40 : 60,
                                      color: Colors.white54,
                                    ),
                                    SizedBox(height: isMobile ? 10 : 16),
                                    Text(
                                      'No actions yet',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: isMobile ? 14 : 16,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: actionLogs.length,
                                itemBuilder: (context, index) {
                                  final log = actionLogs[index];
                                  return _buildActionLogItem(context, log, isMobile);
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionLogItem(BuildContext context, ActionLog log, bool isMobile) {
    final icon = IconHelper.getActionLogIcon(log.level);
    final color = IconHelper.getActionLogColor(log.level);
    
    return Container(
      margin: EdgeInsets.only(bottom: isMobile ? 8 : 12),
      padding: EdgeInsets.all(isMobile ? 8 : 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: isMobile ? 16 : 18),
              SizedBox(width: isMobile ? 6 : 8),
              Expanded(
                child: Text(
                  log.message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 12 : 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (log.category != null) ...[
            SizedBox(height: isMobile ? 4 : 6),
            Text(
              'Category: ${log.category}',
              style: TextStyle(
                color: Colors.white70,
                fontSize: isMobile ? 10 : 12,
              ),
            ),
          ],
          if (log.metadata != null && log.metadata!.isNotEmpty) ...[
            SizedBox(height: isMobile ? 4 : 6),
            Text(
              'Metadata: ${log.metadata}',
              style: TextStyle(
                color: Colors.white60,
                fontSize: isMobile ? 10 : 12,
              ),
            ),
          ],
          SizedBox(height: isMobile ? 4 : 6),
          Text(
            _formatTimestamp(log.timestamp),
            style: TextStyle(
              color: Colors.white54,
              fontSize: isMobile ? 10 : 12,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
