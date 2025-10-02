class NavbarItem {
  final String id;
  final String name;
  final String icon;
  final String route;
  final int order;
  final bool isActive;
  final String category;

  NavbarItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.route,
    required this.order,
    required this.isActive,
    required this.category,
  });

  factory NavbarItem.fromMap(Map<String, dynamic> map) {
    return NavbarItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      icon: map['icon'] ?? '',
      route: map['route'] ?? '',
      order: map['order'] ?? 0,
      isActive: map['isActive'] ?? true,
      category: map['category'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'route': route,
      'order': order,
      'isActive': isActive,
      'category': category,
    };
  }
}
