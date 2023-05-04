
import 'package:flutter/material.dart';

import 'package:semester/db_query.dart';
import 'package:semester/semester_file.dart';
import 'package:semester/semester_file.dart';
import 'package:semester/semester_file.dart';
import 'package:semester/semester_tile.dart';
import 'package:semester/db_helper.dart';

import 'semester_file.dart';
import 'semester_file.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String? Semester;
  late DateTime? dateTime;
  late TimeOfDay? timeOfDay;
  TextEditingController controller = TextEditingController();
  DBQuery dbQuery = DBQuery();
  late Future<List<Semester>> myList;

  @override
  void initState() {
    super.initState();
    myList = dbQuery.getAllSemester();
    dateTime = null;
    timeOfDay= null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semester App'),
      ),
      body:
      FutureBuilder(
        future: myList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Semester>? Semesters = snapshot.data as List<Semester>?;
            return ListView.builder(
                itemCount: Semesters!.length,
                itemBuilder: (context, index) {
                  return MySemesterTile(semt:Semesters[index],update:updateSemester, delete:deleteSemester, );
                }
            );
          }
          else if (snapshot.hasError ) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottom();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // to show BottomSheet
  void  showBottom(){
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
              width: 250,
              height: 400,
              margin: const EdgeInsets.only(left: 8, right: 8),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Expanded(flex: 1, child: Text('Semester Name:')),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: controller,
                            onSubmitted: (val) {
                              setState(() {
                                Semester = controller.text;
                                controller.clear();
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Expanded(flex: 1, child: Text('Semester Date')),
                        Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              child: const Text('Pick Date'),
                              onPressed: () {
                                showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(DateTime.now().year + 1))
                                    .then((value) {
                                  showTimePicker(context: context, initialTime:
                                  TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute)).
                                  then((value) {setState(() {timeOfDay= value!;});print(value.toString());});
                                  setState(() {
                                    dateTime = value;

                                  });
                                });
                              },
                            ))
                      ],
                    ),
                  ),
                  RawMaterialButton(
                      child: const Text('Add Semester'),
                      onPressed: () {
                        if (Semester != null && dateTime != null && timeOfDay !=null) {
                          setState(() {
                            semesterTime time = semesterTime(
                                hour: timeOfDay!.hour,
                                minute: timeOfDay!.minute,
                                day: dateTime!.day,
                                dayName: dateTime!.day.toString(),
                                month: dateTime!.month,
                                year: dateTime!.year);
                            Semester t = Semester(t_id: null,t_name: Semester!, time: time);
                            dbQuery.SaveSemester(t);
                            Semester = null;
                            dateTime = null;
                            myList = dbQuery.getAllSemester();
                          });
                          Navigator.pop(context);
                        }
                        else {
                          return;
                        }
                      })
                ],
              ));
        });
  }

  // Call this method when we need to update a Semester
  updateSemester(Semester oldSemester){
    TextEditingController editingController= TextEditingController();
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title:const Text('Edit'),
        content: SizedBox(
          height: 150,
          child: Column(
            children: [
              TextField(controller: editingController,),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(onPressed: ()async{
                      if(editingController.text.isEmpty)
                      {
                        return ;
                      }
                      else{
                        try{
                          oldSemester.t_name = editingController.text;
                          await dbQuery.updateSemester(oldSemester);
                          setState(() {
                            myList= dbQuery.getAllSemester();
                          });
                          Navigator.pop(context);
                        }
                        catch(e){ print(e.toString());}
                      }
                    }, child: const Text('OK'),
                    ),

                    MaterialButton(onPressed: (){
                      Navigator.pop(context);
                    }, child: const Text('Cancel'))
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  // Call this method when you need to remove a Semester from db
  void deleteSemester(int id){
    dbQuery.deleteSemesterk(id);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    dbQuery.closeDB();
    super.dispose();
  }
}



