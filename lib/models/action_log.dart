class ActionLog {
  final String id;
  final String level;
  final String message;
  final String? category;
  final Map<String, dynamic>? metadata;
  final DateTime timestamp;

  ActionLog({
    required this.id,
    required this.level,
    required this.message,
    this.category,
    this.metadata,
    required this.timestamp,
  });

  factory ActionLog.fromMap(Map<String, dynamic> map) {
    return ActionLog(
      id: map['id'] ?? '',
      level: map['level'] ?? 'info',
      message: map['message'] ?? '',
      category: map['category'],
      metadata: map['metadata'],
      timestamp: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'level': level,
      'message': message,
      'category': category,
      'metadata': metadata,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ActionLog.create({
    required String level,
    required String message,
    String? category,
    Map<String, dynamic>? metadata,
  }) {
    return ActionLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      level: level,
      message: message,
      category: category,
      metadata: metadata,
      timestamp: DateTime.now(),
    );
  }
}
