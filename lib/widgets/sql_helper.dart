import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../global.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../models/comment.dart';

import 'package:http/http.dart' as http;

class SqlHelper {
  static final SqlHelper instance = SqlHelper.init();

  static Database? db;

  SqlHelper.init();

  Future<Database> get database async {
    if (db != null) return db!;
    db = await initDatabase('demo.db');
    return db!;
  }

  Future<Database> initDatabase(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, onCreate: createTables);
  }

  Future createTables(Database db, int version) async {
    await db.execute('''
      create table ${User.tableName} (
      'id' integer primary key autoincrement,
      'username' text,
      'password' text,
      'name' text)
      
      create table ${Post.tableName} (
      'id' integer primary key autoincrement,
      'title' text,
      'text' text,
      'username' text)
      
      create table ${Comment.tableName} (
      'id' integer primary key autoincrement,
      'text' text,
      'username' text)
      ''');
  }

  //posts
  Future<Post> insertPost(Post post) async {
    final db = await instance.database;
    post.id = await db.insert(Post.tableName, post.toMap());
    return post;
  }

  Future<List<Post>> getPosts() async {
    final db = await instance.database;
    List<Map> maps = await db.query(Post.tableName);
    List<Post> retPosts = List.generate(
        maps.length, (i) => Post.fromMap(maps[i] as Map<String, Object?>));
    return retPosts;
  }

  void deletePost(Post post) async {
    final db = await instance.database;
    db.delete(Post.tableName, where: 'id = ?', whereArgs: [post.id]);
  }

  Future<int> updatePost(Post post) async {
    final db = await instance.database;
    return await db.update(Post.tableName, post.toMap(),
        where: 'id = ?',
        whereArgs: [post.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //users
  Future<User> insertUser(User user) async {
    final db = await instance.database;
    user.id = await db.insert(User.tableName, user.toMap());
    return user;
  }

  Future<List<User>> getUsers() async {
    final db = await instance.database;
    List<Map> maps = await db.query(User.tableName);
    List<User> retUsers = List.generate(
        maps.length, (i) => User.fromMap(maps[i] as Map<String, Object?>));
    return retUsers;
  }

  void deleteUser(User user) async {
    final db = await instance.database;
    db.delete(User.tableName, where: 'id = ?', whereArgs: [user.id]);
  }

  Future<int> updateUser(User user) async {
    final db = await instance.database;
    return await db.update(User.tableName, user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //comments
  Future<Comment> insertComment(Comment comment) async {
    final db = await instance.database;
    comment.id = await db.insert(Comment.tableName, comment.toMap());
    return comment;
  }

  Future<List<Comment>> getComments() async {
    final db = await instance.database;
    List<Map> maps = await db.query(Comment.tableName);
    List<Comment> retComments = List.generate(
        maps.length, (i) => Comment.fromMap(maps[i] as Map<String, Object?>));
    return retComments;
  }

  void deleteComment(Comment comment) async {
    final db = await instance.database;
    db.delete(Comment.tableName, where: 'id = ?', whereArgs: [comment.id]);
  }

  Future<int> updateComment(Comment comment) async {
    final db = await instance.database;
    return await db.update(Comment.tableName, comment.toMap(),
        where: 'id = ?',
        whereArgs: [comment.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
