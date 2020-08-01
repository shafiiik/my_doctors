import 'package:flutter/material.dart';
import 'package:my_doctors/database/database.dart';
import 'package:my_doctors/models/doctor.dart';

import 'create_new_doctor.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DoctorDataBase db = DoctorDataBase();
  List<Doctor> doctors;

  @override
  void initState() {
    super.initState();
    getTheDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("shafik"),
      ),
      body: doctors == null
          ? CircularProgressIndicator()
          : ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, i) {
                return ListTile(
                  isThreeLine: true,
                  title: Text(doctors[i].name),
                  subtitle: Text(doctors[i].rate.toString()),
                  leading: Image.network(
                      "https://img.freepik.com/free-photo/front-view-doctor-with-medical-mask-posing-with-crossed-arms_23-2148445082.jpg?size=626&ext=jpg"),
                  trailing: Column(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                            onTap: () {
                              doctors[i].name = "bassem";
                              setState(() {});
                            },
                            child: Icon(Icons.edit)),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            doctors.removeAt(i);
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
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //doctors.add(Doctor(name: "bassem", rate: 2.5, speciality: "tez"));

          setState(() {});
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CreateNewDoctor(getTheDoctors: getTheDoctors);
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void getTheDoctors() async{
    doctors = await db.getDoctors();
    setState(() {

    });
  }
}
