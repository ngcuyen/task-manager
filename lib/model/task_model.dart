class Task {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String category;
  final String status;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.category,
    this.status = 'TO DO',
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'category': category,
      'status': status,
    };
  }

  factory Task.fromMap(String id, Map<String, dynamic> map) {
    return Task(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      category: map['category'] ?? '',
      status: map['status'] ?? 'pending',
    );
  }
}
