import 'package:denuncia_wakala/models/comment.dart';

class Post {
  static const String tableName = 'Post';

  int? id;
  String sector = '';
  String descripcion = '';
  String autor = '';
  String urlFoto1 = '';
  String urlFoto2 = '';
  String sigueAhi = '';
  String yaNoEsta = '';
  List<dynamic> comentarios = [];
  DateTime fechaPublicacion = DateTime.now();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic?>{
      'id': id,
      'sector': sector,
      'descripcion': descripcion,
      'autor': autor,
      'urlFoto1': urlFoto1,
      'urlFoto2': urlFoto2,
      'sigueAhi': sigueAhi,
      'yaNoEsta': yaNoEsta,
      'comentarios': comentarios,
      'fechaPublicacion': fechaPublicacion,
    };
    return map;
  }

  Post({
    this.id,
    required this.sector,
    required this.descripcion,
    required this.autor,
    required this.urlFoto1,
    required this.urlFoto2,
    required this.sigueAhi,
    required this.yaNoEsta,
    required this.comentarios,
  });

  Post.fromMap(Map<String, Object?> map) {
    id = map['id'] as int;
    sector = map['sector'] as String;
    descripcion = map['descripcion'] as String;
    autor = map['autor'] as String;
    urlFoto1 = map['urlFoto1'] as String;
    urlFoto1 = map['urlFoto1'] as String;
    sigueAhi = map['sigueAhi'] as String;
    yaNoEsta = map['yaNoEsta'] as String;
    comentarios = map['comentarios'] as List<dynamic>;
    fechaPublicacion = map['fechaPublicacion'] as DateTime;
  }
}
