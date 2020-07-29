import 'package:flutter/material.dart';
import 'package:my_doctors/database/database.dart';
import 'package:my_doctors/models/doctor.dart';

import 'create_new_doctor.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
//  List<Doctor> doctors = [
//    Doctor(name: "mina", rate: 4.5, speciality: "Bones"),
//    Doctor(name: "hatem", rate: 3.5, speciality: "chest"),
//  ];

  DoctorDataBase db=DoctorDataBase();
  Future<List<Doctor>> doctors;
  @override
  void initState() {

    super.initState();
    doctors=db.getDoctors();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("shafik"),
      ),
      body: FutureBuilder(
        future: db.getDoctors(),
        builder: (context ,snapshot){
          print(snapshot.hasData);
          if(snapshot.hasData){
            List<Doctor> results=snapshot.data;
            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, i) {
                return ListTile(
                  isThreeLine: true,
                  title: Text(results[i].name),
                  subtitle: Text(results[i].rate.toString()),
                  leading: Image.network(
                      "https://img.freepik.com/free-photo/front-view-doctor-with-medical-mask-posing-with-crossed-arms_23-2148445082.jpg?size=626&ext=jpg"),
                  trailing: Column(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                            onTap: () {
                              results[i].name = "bassem";
                              setState(() {});
                            },
                            child: Icon(Icons.edit)),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            results.removeAt(i);
                            setState(() {});
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          else if (snapshot.hasError){
            return Text("error");

          }
          else{
            return CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          //doctors.add(Doctor(name: "bassem", rate: 2.5, speciality: "tez"));
          await db.openDB();
          print(db);
          print(db.database);
          print(db.database.isOpen);
          db.insert(Doctor(name: "bassem", rate: 2.5, speciality: "tez"));
          setState(() {});
//          Navigator.push(context, MaterialPageRoute(builder: (context){
//            return CreateNewDoctor();
//          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
