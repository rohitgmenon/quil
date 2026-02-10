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

class Tasks {
  final String id;
  final String userId;
  final String task;
  final bool isdone;
  final DateTime updated;
  final bool isdelete;
  Tasks({
    String? id,
    required this.userId,
    required this.task,
    required this.isdone,
    DateTime? updated,
    this.isdelete = false,
  }) : id = id ?? const Uuid().v4(),
       updated = updated ?? DateTime.now();
  factory Tasks.fromMap(Map<String, dynamic> map) {
    return Tasks(
      id: map['id'] as String,
      userId: map['userId'] as String,
      task: map['task'] as String,
      isdone: map['isdone'] == 1,
      updated: DateTime.parse(map['updated']),
    );
  }
  Map<String, dynamic> tomap() {
    return {
      'id': id,
      'task': task,
      'userId': userId,
      'isdone': isdone,
      'updated': updated.toIso8601String(),
      'isdelete': isdelete ? 1 : 0,
    };
  }

  Tasks copyWith({String? task, bool? isdone, bool? isdelete}) {
    return Tasks(
      id: id, // never changes
      task: task ?? this.task,
      isdone: isdone ?? this.isdone,
      isdelete: isdelete ?? this.isdelete,
      updated: DateTime.now(),
      userId: userId,
      // always update on change
    );
  }
}

class Code {
  final int? id;
  final String filename;
  final String code;
  final String lang;

  Code({
    required this.filename,
    required this.code,
    required this.lang,
    this.id,
  });

  factory Code.fromMap(Map<String, dynamic> map) {
    return Code(
      id: map['id'] as int,
      filename: map['filename'] as String,
      code: map['code'] as String,
      lang: map['lang'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'filename': filename, 'code': code, 'lang': lang};
  }

  Code copyWith({int? id, String? filename, String? code, String? lang}) {
    return Code(
      id: id ?? this.id,
      filename: filename ?? this.filename,
      code: code ?? this.code,
      lang: lang ?? this.lang,
    );
  }
}
