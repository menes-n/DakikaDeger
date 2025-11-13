class Note {
  final String id;
  final DateTime date;
  final String content;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.date,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
