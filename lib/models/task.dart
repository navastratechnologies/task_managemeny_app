class Task {
  final int? id;
  final String title;
  final String description;
  final String deadline;
  final String priority;
  final String status;
  bool isSelected;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.priority,
    required this.status,
    this.isSelected = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      deadline: json['deadline'] ?? '',
      priority: json['priority'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'deadline': deadline,
      'priority': priority,
      'status': status,
    };
  }
}
