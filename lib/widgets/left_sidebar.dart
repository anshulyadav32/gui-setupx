import 'package:flutter/material.dart';
import '../models/navbar_item.dart';
import '../utils/icon_helper.dart';
import '../utils/responsive_helper.dart';

class LeftSidebar extends StatelessWidget {
  final List<NavbarItem> navbarItems;
  final String selectedCategory;
  final int selectedIndex;
  final bool isLoading;
  final Function(String, int) onItemSelected;
  final VoidCallback onRefreshNavbar;
  final VoidCallback onToggleSidebar;

  const LeftSidebar({
    Key? key,
    required this.navbarItems,
    required this.selectedCategory,
    required this.selectedIndex,
    required this.isLoading,
    required this.onItemSelected,
    required this.onRefreshNavbar,
    required this.onToggleSidebar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = ResponsiveHelper.isMobile(context);
        final sidebarWidth = ResponsiveHelper.getSidebarWidth(context);
        
        return Container(
          width: sidebarWidth,
          decoration: const BoxDecoration(
            color: Color(0xFF2C3E50),
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
                    Icon(Icons.menu, color: Colors.white, size: isMobile ? 16 : 20),
                    SizedBox(width: isMobile ? 6 : 8),
                    Expanded(
                      child: Text(
                        'Navigation',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isMobile ? 14 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: onRefreshNavbar,
                      icon: Icon(Icons.refresh, color: Colors.white70, size: isMobile ? 16 : 18),
                      tooltip: 'Refresh Navigation',
                      constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                      padding: EdgeInsets.all(isMobile ? 4 : 6),
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
              
              // Menu Items
              Expanded(
                child: navbarItems.isEmpty || isLoading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isLoading)
                              const CircularProgressIndicator(color: Colors.white70)
                            else
                              Icon(
                                Icons.menu_open,
                                size: isMobile ? 40 : 60,
                                color: Colors.white54,
                              ),
                            SizedBox(height: isMobile ? 10 : 16),
                            Text(
                              isLoading ? 'Loading...' : 'No navigation items',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: isMobile ? 14 : 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: navbarItems.length,
                        itemBuilder: (context, index) {
                          final item = navbarItems[index];
                          final isSelected = selectedCategory == item.category && selectedIndex == index;
                          
                          return Container(
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
                              border: isSelected
                                  ? const Border(
                                      left: BorderSide(color: Colors.blue, width: 3),
                                    )
                                  : null,
                            ),
                            child: ListTile(
                              leading: Icon(
                                IconHelper.getNavbarIcon(item.icon),
                                color: isSelected ? Colors.blue : Colors.white70,
                                size: isMobile ? 20 : 24,
                              ),
                              title: Text(
                                item.name,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.white70,
                                  fontSize: isMobile ? 14 : 16,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              onTap: () => onItemSelected(item.category, index),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 12 : 16,
                                vertical: isMobile ? 4 : 8,
                              ),
                            ),
                          );
                        },
                      ),
              ),
              
              // Debug Info (only in debug mode)
              if (navbarItems.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(isMobile ? 8 : 12),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.white24, width: 1),
                    ),
                  ),
                  child: Text(
                    'Items: ${navbarItems.length}',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: isMobile ? 10 : 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
