import 'package:uuid/uuid.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final int importance;
  final DateTime created;
  final DateTime updated;
  Note({
    String? id,
    required this.title,
    required this.content,
    required this.importance,
    DateTime? created,
    DateTime? updated,
  }) : assert(importance == 1 || importance == 2),
       id = id ?? const Uuid().v4(),
       created = created ?? DateTime.now(),
       updated = updated ?? DateTime.now();
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      importance: map['importance'] as int,
      created: DateTime.parse(map['created']),
      updated: DateTime.parse(map['updated']),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'importance': importance,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
    };
  }
}
