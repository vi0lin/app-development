import 'dart:convert';

class Article {
  
  int idArticle;
  String caption;
  String text;
  DateTime modified;
  DateTime created;

  Article({
    this.idArticle,
    this.caption,
    this.text,
    this.modified,
    this.created,
  });

  Article copyWith({
    int idArticle,
    String caption,
    String text,
    DateTime modified,
    DateTime created,
  }) {
    return Article(
      idArticle: idArticle ?? this.idArticle,
      caption: caption ?? this.caption,
      text: text ?? this.text,
      modified: modified ?? this.modified,
      created: created ?? this.created,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idArticle': idArticle,
      'caption': caption,
      'text': text,
      'modified': modified?.millisecondsSinceEpoch,
      'created': created?.millisecondsSinceEpoch,
    };
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Article(
      idArticle: map['idArticle'],
      caption: map['caption'],
      text: map['text'],
      modified: DateTime.fromMillisecondsSinceEpoch(map['modified']),
      created: DateTime.fromMillisecondsSinceEpoch(map['created']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Article.fromJson(String source) => Article.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Article(idArticle: $idArticle, caption: $caption, text: $text, modified: $modified, created: $created)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Article &&
      o.idArticle == idArticle &&
      o.caption == caption &&
      o.text == text &&
      o.modified == modified &&
      o.created == created;
  }

  @override
  int get hashCode {
    return idArticle.hashCode ^
      caption.hashCode ^
      text.hashCode ^
      modified.hashCode ^
      created.hashCode;
  }
}
