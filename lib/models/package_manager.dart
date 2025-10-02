class PackageManager {
  final String id;
  final String name;
  final String displayName;
  final String? icon;
  final String? color;
  final String status;
  final String? version;
  final String? description;
  final bool isActive;
  final int order;
  final String? installCommand;
  final String? updateCommand;
  final String? uninstallCommand;

  PackageManager({
    required this.id,
    required this.name,
    required this.displayName,
    this.icon,
    this.color,
    required this.status,
    this.version,
    this.description,
    required this.isActive,
    required this.order,
    this.installCommand,
    this.updateCommand,
    this.uninstallCommand,
  });

  factory PackageManager.fromMap(Map<String, dynamic> map) {
    return PackageManager(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      displayName: map['displayName'] ?? '',
      icon: map['icon'],
      color: map['color'],
      status: map['status'] ?? 'unknown',
      version: map['version'],
      description: map['description'],
      isActive: map['isActive'] ?? true,
      order: map['order'] ?? 0,
      installCommand: map['installCommand'],
      updateCommand: map['updateCommand'],
      uninstallCommand: map['uninstallCommand'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'displayName': displayName,
      'icon': icon,
      'color': color,
      'status': status,
      'version': version,
      'description': description,
      'isActive': isActive,
      'order': order,
      'installCommand': installCommand,
      'updateCommand': updateCommand,
      'uninstallCommand': uninstallCommand,
    };
  }

  PackageManager copyWith({
    String? id,
    String? name,
    String? displayName,
    String? icon,
    String? color,
    String? status,
    String? version,
    String? description,
    bool? isActive,
    int? order,
    String? installCommand,
    String? updateCommand,
    String? uninstallCommand,
  }) {
    return PackageManager(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      status: status ?? this.status,
      version: version ?? this.version,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      order: order ?? this.order,
      installCommand: installCommand ?? this.installCommand,
      updateCommand: updateCommand ?? this.updateCommand,
      uninstallCommand: uninstallCommand ?? this.uninstallCommand,
    );
  }
}
