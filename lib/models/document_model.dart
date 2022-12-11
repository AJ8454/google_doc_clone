import 'dart:convert';

class DocumentModel {
  final String? uid;
  final String? title;
  final List? content;
  final DateTime? createAt;
  final String? id;

  DocumentModel({
    this.uid,
    this.title,
    this.content,
    this.createAt,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'title': title,
      'content': content,
      'createAt': createAt,
      'id': id,
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      uid: map['uid'],
      title: map['title'],
      content: map['content'],
      createAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      id: map['_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentModel.fromJson(String source) =>
      DocumentModel.fromMap(json.decode(source));
}
