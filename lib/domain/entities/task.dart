class Task {
  final String id;
  final String title;
  final bool done;
  final DateTime createdAt;
  Task({
    required this.id,
    required this.title,
    required this.done,
    required this.createdAt,
  });

  Task copyWith({String? id, String? title, bool? done, DateTime? createdAt}) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      done: done ?? this.done,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
