
import 'package:semester/semester_file.dart';
import 'package:semester/db_helper.dart';
class DBQuery{
  DBHelper dbHelper = DBHelper();

  // Query to insert into Database
  Future<Semester> SaveSemester (Semester semester) async{
    var dbClient = await dbHelper.datebase;
    semester.t_id = await dbClient.insert( DBHelper.semesterTable, semester.toMap());
    print('semester has been saved' + '   ${semester.t_id}');
    return semester;
  }

// Query to get All Semester in the Database
  Future<List<Semester>>  getAllSemester()async{
    final dbClient= await dbHelper.datebase;

    final List<Map<String, dynamic>> myList = await dbClient.query(DBHelper.semesterTable);
    return List.generate(myList.length, (index)
    {
      semesterTime time=  semesterTime(
          hour: myList[index]['t_hour'],
          minute: myList[index]['t_minute'],
          day:myList[index]['t_day'],
          dayName:myList[index]['dayName'],
          month: myList[index]['t_month'],
          year:myList[index] ['t_year']);

      return Semester(t_id:  myList[index]['t_id'],t_name: myList[index]['t_name'], time: time);
    });
  }

  // Update a Raw in DB
  Future<int> updateSemester(Semester semester) async{
    var dbClient = await dbHelper.datebase;
    return await dbClient.update(DBHelper.semesterTable,semester.toMap(),
        where: '${DBHelper.t_id} = ?', whereArgs: [semester.t_id]);
  }


//Delete a Raw in DB
  Future<int> deleteSemesterk(int id) async{
    var dbClient= await dbHelper.datebase;
    return await dbClient.delete(DBHelper.semesterTable,where: '${DBHelper.t_id} = ?', whereArgs: [id]);
  }

  Future<void> closeDB()async{
    print('Closing Database');
    await DBHelper.db!.close();
  }
}