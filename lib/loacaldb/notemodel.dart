import 'package:uuid/uuid.dart';

class Note {
  final String id;
  final String userId;
  final String title;
  final String content;
  final int importance;
  final DateTime created;
  final DateTime updated;
  final DateTime? deletedat;
  Note({
    String? id,
    required this.userId,
    required this.title,
    required this.content,
    required this.importance,
    DateTime? created,
    DateTime? updated,
    this.deletedat,
  }) : assert(importance == 1 || importance == 2),
       id = id ?? const Uuid().v4(),
       created = created ?? DateTime.now(),
       updated = updated ?? DateTime.now();
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as String,
      userId: map['userId'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      importance: map['importance'] as int,
      created: DateTime.parse(map['created']),
      updated: DateTime.parse(map['updated']),
      deletedat: map['deletedat'] != null
          ? DateTime.parse(map['deletedat'])
          : null,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'importance': importance,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
      'deletedat': deletedat?.toIso8601String(),
    };
  }

  Note copyWith({
    String? title,
    String? content,
    int? importance,
    DateTime? updated,
    DateTime? deletedat,
  }) {
    return Note(
      id: id,
      userId: userId,
      title: title ?? this.title,
      content: content ?? this.content,
      importance: importance ?? this.importance,
      created: created,
      updated: DateTime.now(),
      deletedat: deletedat ?? deletedat,
    );
  }
}
