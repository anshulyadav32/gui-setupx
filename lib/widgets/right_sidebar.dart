import 'package:flutter/material.dart';

class RightSidebar extends StatelessWidget {
  final List<Map<String, dynamic>> actionLogs;
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
        final isMobile = constraints.maxWidth < 600;
        final sidebarWidth = isMobile ? 250.0 : 300.0;
        
        return Container(
          width: sidebarWidth,
          decoration: const BoxDecoration(
            color: Color(0xFF0f1419),
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
                    Icon(Icons.dashboard, color: Colors.white, size: isMobile ? 20 : 24),
                    SizedBox(width: isMobile ? 8 : 10),
                    Text(
                      'Action Logs',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: onToggleSidebar,
                      icon: Icon(Icons.close, color: Colors.white70, size: isMobile ? 18 : 24),
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
                              fontSize: isMobile ? 14 : 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: onClearLogs,
                            icon: Icon(Icons.clear, color: Colors.white70, size: isMobile ? 16 : 20),
                            tooltip: 'Clear Logs',
                          ),
                        ],
                      ),
                      SizedBox(height: isMobile ? 10 : 15),
                      Expanded(
                        child: actionLogs.isEmpty
                            ? Center(
                                child: Text(
                                  'No actions performed yet',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: isMobile ? 12 : 14,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: actionLogs.length,
                                itemBuilder: (context, index) {
                                  final log = actionLogs[index];
                                  return _buildActionLogItem(log);
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

  Widget _buildActionLogItem(Map<String, dynamic> log) {
    final message = log['message'] ?? '';
    final level = log['level'] ?? 'info';
    final timestamp = log['timestamp'] as DateTime?;
    
    Color levelColor;
    IconData levelIcon;
    
    switch (level) {
      case 'success':
        levelColor = Colors.green;
        levelIcon = Icons.check_circle;
        break;
      case 'error':
        levelColor = Colors.red;
        levelIcon = Icons.error;
        break;
      case 'warning':
        levelColor = Colors.orange;
        levelIcon = Icons.warning;
        break;
      case 'info':
      default:
        levelColor = Colors.blue;
        levelIcon = Icons.info;
        break;
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: levelColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            levelIcon,
            color: levelColor,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
                if (timestamp != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
