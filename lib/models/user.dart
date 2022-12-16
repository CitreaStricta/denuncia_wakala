class User {
  static const String tableName = 'User';

  int? id;
  String username = '';
  String password = '';
  String name = '';

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'username': username,
      'password': password,
      'name': name,
    };
    map['id'] = id;
    return map;
  }

  User({
    this.id,
    required this.username,
    required this.password,
    required this.name,
  });

  User.fromMap(Map<String, Object?> map) {
    id = map['id'] as int;
    username = map['username'] as String;
    password = map['password'] as String;
    name = map['name'] as String;
  }
}
