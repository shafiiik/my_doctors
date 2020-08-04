import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_doctors/database/database.dart';
import 'package:my_doctors/models/doctor.dart';

enum Specialties { Bones, Chest, Heart }

class CreateNewDoctor extends StatefulWidget {
  final Function getTheDoctors;
  final Doctor doctorToBeUpdated;

  const CreateNewDoctor({Key key, this.getTheDoctors, this.doctorToBeUpdated})
      : super(key: key);

  @override
  _CreateNewDoctorState createState() => _CreateNewDoctorState();
}

class _CreateNewDoctorState extends State<CreateNewDoctor> {
  DoctorDataBase db = DoctorDataBase();

  TextEditingController nameController;

  TextEditingController rateController;

  Specialties doctorSpeciality = Specialties.Bones;
  double rating = 0.0;
  Position position;
  final formKey = GlobalKey<FormState>();
  bool autoValidate = false;

  @override
  void initState() {
    super.initState();
    rateController = TextEditingController(
        text: widget.doctorToBeUpdated?.rate?.toString() ?? "");
    nameController =
        TextEditingController(text: widget.doctorToBeUpdated?.name ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add & Update Doctor"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: formKey,
            autovalidate: autoValidate,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Write Doctor's name",
                        labelText: "Enter Doctor Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30))),
                    controller: nameController,
                    validator: (text) {
                      if (text.length < 3)
                        return "name must be more than 2 char";
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Write Doctor's rate",
                        labelText: "Enter Doctor Rate",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30))),
                    controller: rateController,
                    validator: (text) {
                      try {
                        rating = double.parse(text);
                        if (rating < 0 || rating > 5)
                          return "rating must be a number between 0 and 5";
                        return null;
                      } catch (error) {
                        print(error);
                        return "rating must be a number";
                      }
                    },
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text("Enter doctor Spec"),
                    Spacer(),
                    DropdownButton(
                      iconSize: 50.0,
                      dropdownColor: Colors.deepPurpleAccent,
                      iconEnabledColor: Colors.blue,
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
                Row(
                  children: <Widget>[
                    Text("Add location"),
                    Spacer(),
                    FlatButton(
                        child: Icon(
                          Icons.location_on,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          _getCurrentLocation();
                        }),
                  ],
                ),
                RaisedButton(
                  child: Text("Save Doctor"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  color: Colors.deepPurpleAccent,
                  onPressed: saveDoctor,
                )
              ],
            ),
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

      if (widget.doctorToBeUpdated == null) {
        await db.insert(Doctor(
            name: nameController.text,
            rate: rating,
            speciality: speciality,
            lat: position?.latitude,
            long: position?.longitude));
      } else {
        widget.doctorToBeUpdated.name = nameController.text;
        widget.doctorToBeUpdated.rate = double.parse(rateController.text);

        await db.update(widget.doctorToBeUpdated);
      }
      widget.getTheDoctors();
      Navigator.pop(context);
    } else {
      autoValidate = true;
      setState(() {});
    }
  }
}
