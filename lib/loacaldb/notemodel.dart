import 'package:uuid/uuid.dart';

class Note {
  final String id;
  final String userId;
  final String title;
  final String content;
  final String? summary;
  final int importance;
  final DateTime created;
  final DateTime updated;
  final DateTime? deletedat;
  final bool isSynced;
  final DateTime? isarchived;
  Note({
    String? id,
    required this.userId,
    required this.title,
    required this.content,
    required this.importance,
    this.summary,
    DateTime? created,
    DateTime? updated,
    this.deletedat,
    this.isSynced = false,
    this.isarchived,
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
      summary: map['summary'] as String?,
      importance: map['importance'] as int,
      created: DateTime.parse(map['created']),
      updated: DateTime.parse(map['updated']),
      deletedat: map['deletedat'] != null
          ? DateTime.parse(map['deletedat'])
          : null,
      isSynced: map['isSynced'] == 1,
      isarchived: map['isarchived'] != null
          ? DateTime.parse(map['isarchived'])
          : null,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'summary': summary,
      'importance': importance,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
      'deletedat': deletedat?.toIso8601String(),
      'isSynced': isSynced ? 1 : 0,
      'isarchived': isarchived?.toIso8601String(),
    };
  }

  Note copyWith({
    String? title,
    String? content,
    String? summary,
    int? importance,
    DateTime? updated,
    DateTime? deletedat,
    DateTime? isarchived,
    bool? isSynced,
  }) {
    return Note(
      id: id,
      userId: userId,
      title: title ?? this.title,
      content: content ?? this.content,
      summary: summary ?? this.summary,
      importance: importance ?? this.importance,
      created: created,
      updated: DateTime.now(),
      deletedat: deletedat ?? this.deletedat,
      isSynced: isSynced ?? this.isSynced,
      isarchived: isarchived ?? this.isarchived,
    );
  }
}
