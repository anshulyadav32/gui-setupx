import 'package:flutter/material.dart';

class LeftSidebar extends StatelessWidget {
  final List<Map<String, dynamic>> navbarItems;
  final String selectedCategory;
  final int selectedIndex;
  final VoidCallback onToggleSidebar;
  final VoidCallback onRefreshNavbar;
  final Function(String, int) onItemSelected;

  const LeftSidebar({
    Key? key,
    required this.navbarItems,
    required this.selectedCategory,
    required this.selectedIndex,
    required this.onToggleSidebar,
    required this.onRefreshNavbar,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final sidebarWidth = isMobile ? 200.0 : 250.0;
        
        return Container(
          width: sidebarWidth,
          decoration: const BoxDecoration(
            color: Color(0xFF0f1419),
            border: Border(
              right: BorderSide(color: Colors.white24, width: 1),
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
                    Icon(Icons.menu, color: Colors.white, size: isMobile ? 20 : 24),
                    SizedBox(width: isMobile ? 8 : 10),
                    Expanded(
                      child: Text(
                        'Navigation',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isMobile ? 16 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: onRefreshNavbar,
                      icon: Icon(Icons.refresh, color: Colors.white70, size: isMobile ? 18 : 20),
                      tooltip: 'Refresh Navigation',
                    ),
                    IconButton(
                      onPressed: onToggleSidebar,
                      icon: Icon(Icons.close, color: Colors.white70, size: isMobile ? 18 : 24),
                    ),
                  ],
                ),
              ),
              
              // Menu Items
              Expanded(
                child: navbarItems.isEmpty 
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.white70),
                          SizedBox(height: 16),
                          Text(
                            'Loading navigation...',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: navbarItems.length,
                      itemBuilder: (context, index) {
                        final item = navbarItems[index];
                        final isSelected = selectedCategory == item['category'];
                        
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 10, vertical: 2),
                          child: ListTile(
                            selected: isSelected,
                            selectedTileColor: Colors.blue.withOpacity(0.2),
                            leading: Icon(
                              _getNavbarIcon(item['icon']),
                              color: isSelected ? Colors.blue : Colors.white70,
                              size: isMobile ? 18 : 20,
                            ),
                            title: Text(
                              item['name'],
                              style: TextStyle(
                                color: isSelected ? Colors.blue : Colors.white,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                fontSize: isMobile ? 13 : 14,
                              ),
                            ),
                            onTap: () => onItemSelected(item['category'], index),
                          ),
                        );
                      },
                    ),
              ),
              
              // Sidebar Footer
              Container(
                padding: EdgeInsets.all(isMobile ? 12 : 20),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.white24, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.white70, size: isMobile ? 16 : 20),
                    SizedBox(width: isMobile ? 8 : 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Full Screen App',
                            style: TextStyle(color: Colors.white70, fontSize: isMobile ? 10 : 12),
                          ),
                          Text(
                            '${navbarItems.length} nav items',
                            style: TextStyle(color: Colors.white54, fontSize: isMobile ? 9 : 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getNavbarIcon(String iconName) {
    switch (iconName) {
      case 'dashboard': return Icons.dashboard;
      case 'package': return Icons.inventory_2;
      case 'tools': return Icons.build;
      case 'server': return Icons.dns;
      default: return Icons.help_outline;
    }
  }
}
