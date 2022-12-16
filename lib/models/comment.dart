class Comment {
  static const String tableName = 'Comment';

  int? id;
  String text = '';
  String username = '';

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'text': text,
      'username': username,
    };
    map['id'] = id;
    return map;
  }

  Comment({
    this.id,
    required this.text,
    required this.username,
  });

  Comment.fromMap(Map<String, Object?> map) {
    id = map['id'] as int;
    text = map['text'] as String;
    username = map['username'] as String;
  }
}
