import 'package:flutter/material.dart';
import 'package:my_doctors/models/doctor.dart';

import 'create_new_doctor.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Doctor> doctors = [
    Doctor(name: "mina", rate: 4.5, speciality: "Bones"),
    Doctor(name: "hatem", rate: 3.5, speciality: "chest"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("shafik"),
      ),
      body: ListView.builder(
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
        onPressed: () {
          doctors.add(Doctor(name: "bassem", rate: 2.5, speciality: "tez"));
          setState(() {});
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return CreateNewDoctor();
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
