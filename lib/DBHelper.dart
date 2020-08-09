import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'Employee.dart';

class DBHelper {
  Database _database;

  Future openDb() async {
    if (_database == null) {
      _database = await openDatabase(
          join(await getDatabasesPath(), 'employee.db'),
          version: 1, onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE Employee(id INTEGER PRIMARY KEY autoincrement, name TEXT, location TeXT)',
        );
      });
    }
  }

  Future<int> insertEmployee(Employee employee) async {
    await openDb();
    return await _database.insert('Employee', employee.toMap());
  }

  Future<List<Employee>> getEmployeeList() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.query('Employee');
    return List.generate(maps.length, (i) {
      return Employee(
          id: maps[i]['id'],
          name: maps[i]['name'],
          location: maps[i]['location']);
    });
  }

  Future<int> updateEmployee(Employee employee) async {
    await openDb();
    return await _database.update('Employee', employee.toMap(),
        where: "id = ?", whereArgs: [employee.id]);
  }

  Future<void> deleteEmployee(int id) async {
    await openDb();
    await _database.delete('Employee', where: "id = ?", whereArgs: [id]);
  }
}
