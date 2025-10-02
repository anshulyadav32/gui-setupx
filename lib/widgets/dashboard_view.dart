import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final iconSize = isMobile ? 60.0 : 100.0;
        final titleFontSize = isMobile ? 24.0 : 32.0;
        final subtitleFontSize = isMobile ? 14.0 : 18.0;
        
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.dashboard,
                size: iconSize,
                color: Colors.white,
              ),
              SizedBox(height: isMobile ? 20 : 30),
              Text(
                'Welcome to Dashboard',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isMobile ? 15 : 20),
              Text(
                'Full Screen Flutter App with Sidebars',
                style: TextStyle(
                  fontSize: subtitleFontSize,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isMobile ? 30 : 50),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : 30, 
                  vertical: isMobile ? 12 : 15
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: isMobile ? 20 : 24,
                    ),
                    SizedBox(width: isMobile ? 8 : 12),
                    Text(
                      'Always Full Screen Mode',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.bold,
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
}
