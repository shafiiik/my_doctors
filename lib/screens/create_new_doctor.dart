import 'package:flutter/material.dart';

class CreateNewDoctor extends StatefulWidget {
  @override
  _CreateNewDoctorState createState() => _CreateNewDoctorState();
}

class _CreateNewDoctorState extends State<CreateNewDoctor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Doctor"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  labelText: "Enter Doctor Name", border: OutlineInputBorder()),
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: "Enter Doctor Rate", border: OutlineInputBorder()),
            ),

            Row(
              children: <Widget>[
                 Text ("Enter doctor Spec"),
                Spacer (),
                DropdownButton(
                  items: [
                    DropdownMenuItem(
                      child: Text("bones"),
                    ),
                  DropdownMenuItem(
                      child: Text("chest"),
                    ),
                  DropdownMenuItem(
                      child: Text("heart"),
                    )
                  ],
                  onChanged: (value){},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
