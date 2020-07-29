import 'package:flutter/foundation.dart';

class Doctor {
  String name;
  double long;
  double lat;
  double rate;
  String speciality;

  Doctor({this.name, this.long, this.lat, this.rate, this.speciality});

  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "rate": this.rate,
      "speciality": this.speciality,
    };
  }


  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(name: json["name"],rate: json["rate"],speciality: json["speciality"]);
  }
}
