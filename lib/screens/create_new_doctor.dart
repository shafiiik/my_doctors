import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_doctors/database/database.dart';
import 'package:my_doctors/models/doctor.dart';

enum Specialties { Bones, Chest, Heart }

class CreateNewDoctor extends StatefulWidget {
  final Function getTheDoctors;

  const CreateNewDoctor({Key key, this.getTheDoctors}) : super(key: key);


  @override
  _CreateNewDoctorState createState() => _CreateNewDoctorState();
}



class _CreateNewDoctorState extends State<CreateNewDoctor> {

  DoctorDataBase db = DoctorDataBase();

  TextEditingController nameController = TextEditingController();
  TextEditingController rateController = TextEditingController();

  Specialties doctorSpeciality = Specialties.Bones;
  double rating = 0.0;
  Position position;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Doctor"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: formKey,
          autovalidate: true,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Write Doctor's name",
                    labelText: "Enter Doctor Name",
                    border: OutlineInputBorder()),
                controller: nameController,
                validator: (text) {
                  if (text.length < 3) return "name must be more than 2 char";
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Write Doctor's rate",
                    labelText: "Enter Doctor Rate",
                    border: OutlineInputBorder()),
                controller: rateController,
                validator: (text) {
                  try {
                    rating = double.parse(rateController.text);
                    if (rating < 0 || rating > 5)
                      return "rating must be a number between 0 and 5";
                    return null;
                  } catch (error) {
                    return "rating must be a number";
                  }
                },
              ),
              Row(
                children: <Widget>[
                  Text("Enter doctor Spec"),
                  Spacer(),
                  DropdownButton(
                    value: doctorSpeciality,
                    items: [
                      DropdownMenuItem(
                        child: Text("bones"),
                        value: Specialties.Bones,
                      ),
                      DropdownMenuItem(
                        child: Text("chest"),
                        value: Specialties.Chest,
                      ),
                      DropdownMenuItem(
                        child: Text("heart"),
                        value: Specialties.Heart,
                      )
                    ],
                    onChanged: (Specialties value) {
                      doctorSpeciality = value;
                      setState(() {});
                    },
                  ),
                ],
              ),
              FlatButton(
                  child: Icon(Icons.location_on),
                  onPressed: () {
                _getCurrentLocation();
              }),
              RaisedButton(
                child: Text("Save Doctor"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                color: Colors.red,
                onPressed: saveDoctor,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _getCurrentLocation() async {
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }



  void saveDoctor() async {
    if (formKey.currentState.validate() && doctorSpeciality != null) {
      await db.openDB();
      print(db);
      print(db.database);
      print(db.database.isOpen);

      String speciality;

      switch (doctorSpeciality) {
        case Specialties.Bones:
          speciality = "Bones";
          break;
        case Specialties.Chest:
          speciality = "Chest";
          break;
        case Specialties.Heart:
          speciality = "Heart";
          break;
      }

      await db.insert(Doctor(
          name: nameController.text, rate: rating, speciality: speciality,lat: position?.latitude,long: position?.longitude));
      widget.getTheDoctors();
    }
  }
}
