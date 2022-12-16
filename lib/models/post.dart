class Post {
  static const String tableName = 'Post';

  int? id;
  String title = '';
  String text = '';
  String username = '';
  DateTime date = DateTime.now();

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'title': title,
      'text': text,
      'username': username,
      'date': date,
    };
    map['id'] = id;
    return map;
  }

  Post({
    this.id,
    required this.title,
    required this.text,
    required this.username,
  });

  Post.fromMap(Map<String, Object?> map) {
    id = map['id'] as int;
    title = map['title'] as String;
    text = map['text'] as String;
    username = map['username'] as String;
    date = map['date'] as DateTime;
  }
}
