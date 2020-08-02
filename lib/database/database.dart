import 'package:my_doctors/models/doctor.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DoctorDataBase {
  String tableName = "Doctors";
  Database database;

//   void openDB() async {
//    var databasesPath = await getDatabasesPath();
//    String path = join(databasesPath, 'demo.db');
//
//    print("omar");
//
//    database = await openDatabase(path, version: 1,
//        onCreate: (Database db, int version) async {
//          // When creating the db, create the table
//          await db.execute(
//              'CREATE TABLE $tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, rate REAL, speciality TEXT)');
//        });
//
//    print("shafiiik");
//    print(database);
//    print(database.isOpen);
//  }


  Future openDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
create table if not exists $tableName ( 
  id integer primary key autoincrement, 
  name text not null,
  rate REAL,
   speciality text,
   long REAL,
   lat REAL)
''');

        });
  }


  Future<void> insert(Doctor doctor) async {
    await database.insert(tableName, doctor.toJson());
  }

  Future<List<Doctor>> getDoctors() async {

    if(database==null){
      await openDB();
    }

    List<Map<String, dynamic>> maps = await database.query(
      tableName,
      columns: ["id","name", "rate", "speciality","long","lat"],
    );
    print(maps.length);
    if (maps.length > 0) {
      List<Doctor> doctors = [];
      maps.forEach((element) {
        doctors.add(Doctor.fromJson(element));
      }
      );
      return doctors;
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await database.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Doctor doctor) async {
    return await database.update(tableName, doctor.toJson(),
        where: 'id = ?', whereArgs: [doctor.id]);
  }

}
