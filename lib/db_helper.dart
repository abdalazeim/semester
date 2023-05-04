import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{
  static Database? db;
  //Constance for the fields we need
  static const String dbName= 'semesterDB';
  static const String semesterTable= 'semesterTable';
  static const String t_name= 't_name';
  static const String t_id ='t_id';
  static const String t_day = 't_day';
  static const String t_month = 't_month';
  static const String t_year = 't_year';
  static const String dayName = 'dayName';
  static const String t_hour = 't_hour';
  static const String t_minute = 't_minute';
  static String? path ;


  // a getter for db
  Future<Database> get datebase async {
    if(db != null){
      return db! ;
    }
    db = await initDatabase();
    return db! ;
  }

  // To initialize db and Create it
  initDatabase()async {
    var documentDirectory = await getDatabasesPath();
    path = join(documentDirectory , dbName);
    var db = await openDatabase(path! , version: 1 , onCreate: onCreate);
    return db;
  }

  //To Create tables for db
  onCreate(Database db , int version) async{
    // create task table
    await db.execute(
        "CREATE TABLE $semesterTable "
            "( $t_id INTEGER PRIMARY KEY ,"
            "$t_name TEXT ,"
            " $t_day INTEGER ,"
            "$t_month INTEGER ,"
            " $t_year INTEGER ,"
            "$t_hour INTEGER ,"
            " $t_minute INTEGER ,"
            "$dayName TEXT )"
    );
  }
}