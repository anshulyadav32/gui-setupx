import 'package:flutter/material.dart';

class IconHelper {
  static IconData getNavbarIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'dashboard':
        return Icons.dashboard;
      case 'package':
        return Icons.inventory_2;
      case 'tools':
        return Icons.build;
      case 'server':
        return Icons.dns;
      default:
        return Icons.help_outline;
    }
  }

  static IconData getPackageManagerIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'inventory_2':
        return Icons.inventory_2;
      case 'terminal':
        return Icons.terminal;
      case 'code':
        return Icons.code;
      case 'web':
        return Icons.web;
      default:
        return Icons.inventory_2;
    }
  }

  static IconData getCommonToolIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'code':
        return Icons.code;
      case 'web':
        return Icons.web;
      case 'terminal':
        return Icons.terminal;
      case 'storage':
        return Icons.storage;
      case 'desktop_windows':
        return Icons.desktop_windows;
      case 'settings':
        return Icons.settings;
      case 'chat':
        return Icons.chat;
      case 'medical_services':
        return Icons.medical_services;
      case 'message':
        return Icons.message;
      case 'security':
        return Icons.security;
      default:
        return Icons.build;
    }
  }

  static IconData getDevToolIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'terminal':
        return Icons.terminal;
      case 'storage':
        return Icons.storage;
      case 'cloud':
        return Icons.cloud;
      case 'code':
        return Icons.code;
      default:
        return Icons.code;
    }
  }

  static IconData getCrossPlatformDevToolIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'code':
        return Icons.code;
      case 'flutter_dash':
        return Icons.flutter_dash;
      case 'android':
        return Icons.android;
      case 'flash_on':
        return Icons.flash_on;
      case 'cloud':
        return Icons.cloud;
      default:
        return Icons.code;
    }
  }

  static IconData getWSLToolIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'settings':
        return Icons.settings;
      case 'upgrade':
        return Icons.upgrade;
      case 'computer':
        return Icons.computer;
      case 'terminal':
        return Icons.terminal;
      case 'update':
        return Icons.update;
      case 'security':
        return Icons.security;
      case 'desktop_windows':
        return Icons.desktop_windows;
      case 'storage':
        return Icons.storage;
      case 'network_check':
        return Icons.network_check;
      case 'folder':
        return Icons.folder;
      default:
        return Icons.terminal;
    }
  }

  static IconData getActionLogIcon(String level) {
    switch (level.toLowerCase()) {
      case 'info':
        return Icons.info;
      case 'success':
        return Icons.check_circle;
      case 'warning':
        return Icons.warning;
      case 'error':
        return Icons.error;
      default:
        return Icons.info;
    }
  }

  static Color getActionLogColor(String level) {
    switch (level.toLowerCase()) {
      case 'info':
        return Colors.blue;
      case 'success':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      case 'error':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
