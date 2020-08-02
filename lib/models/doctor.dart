import 'package:flutter/foundation.dart';

class Doctor {
  int id;
  String name;
  double long;
  double lat;
  double rate;
  String speciality;

  Doctor({this.id,this.name, this.long, this.lat, this.rate, this.speciality});

  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "rate": this.rate,
      "speciality": this.speciality,
      "long":this.long,
      "lat":this.lat,
    };
  }

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
        id: json["id"],
        name: json["name"],
        rate: json["rate"],
        speciality: json["speciality"],
        long: json["long"],
        lat: json["lat"]);
  }
}
