import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:activity_register/models/users.dart';
import 'package:activity_register/models/vivencias.dart';

class OperationUser {
  static Future<Database> _openDb() async {
    //Future se utiliza debido a que se espera la respuesta a futuro
    return openDatabase(join(await getDatabasesPath(), 'user.db'),
        onCreate: (db, version) {
      return db.execute(
        //query
        'CREATE TABLE users(id INTEGER PRIMARY KEY, nombre TEXT, foto TEXT, hasEvidencia INTEGER)',
      );
    }, version: 1);
  }

  static Future<void> insert(User user) async {
    final database = await _openDb();
    await database.insert('users', user.ToMap());
  }

  static Future<void> delete(User user) async {
    final database = await _openDb();
    await database.delete('users', where: 'id = ?', whereArgs: [user.id]);
  }

  static Future<void> update(User user) async {
    final database = await _openDb();
    await database
        .update('users', user.ToMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  static Future<List<User>> users() async {
    final database = await _openDb();
    final List<Map<String, dynamic>> userMap = await database.query("users");
    return List.generate(
        userMap.length,
        (index) => User(
              id: userMap[index]['id'],
              nombre: userMap[index]['nombre'],
              foto: userMap[index]['foto'],
              hasEvidencia: userMap[index]['hasEvidencia'],
            ));
  }
}

class OperationVivencias {
  static Future<Database> _openDb() async {
    //Future se utiliza debido a que se espera la respuesta a futuro
    return openDatabase(join(await getDatabasesPath(), 'vivencias.db'),
        onCreate: (db, version) {
      return db.execute(
        //query
        'CREATE TABLE vivencias(id INTEGER PRIMARY KEY, user INTEGER, titulo TEXT, fecha TEXT, descripcion TEXT, fotoVivencia TEXT, pathAudio TEXT)',
      );
    }, version: 1);
  }

  static Future<void> insert(Vivencias vivencias) async {
    // insertar en tabla
    final database = await _openDb();
    await database.insert('vivencias', vivencias.ToMap());
  }

  static Future<void> delete(Vivencias vivencias) async {
    // borrar tabla
    final database = await _openDb();
    await database
        .delete('vivencias', where: 'id = ?', whereArgs: [vivencias.id]);
  }

  static Future<void> update(Vivencias vivencias) async {
    // Actualizar tabla
    final database = await _openDb();
    await database.update('vivencias', vivencias.ToMap(),
        where: 'id =?', whereArgs: [vivencias.id]);
  }

  static Future<List<Vivencias>> vivencias() async {
    final database = await _openDb();
    final List<Map<String, dynamic>> vivenciasMap =
        await database.query('vivencias');
    return List.generate(
        //obtener lista de vivencias

        vivenciasMap.length,
        (index) => Vivencias(
              id: vivenciasMap[index]['id'],
              user: vivenciasMap[index]['user'],
              titulo: vivenciasMap[index]['titulo'],
              fecha: vivenciasMap[index]['fecha'],
              descripcion: vivenciasMap[index]['descripcion'],
              fotoVivencia: vivenciasMap[index]['fotoVivencia'],
              //     pathAudio: vivenciasMap[index]['pathAudio'],
            ));
  }
}
