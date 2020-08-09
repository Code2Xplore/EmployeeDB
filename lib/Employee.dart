import 'package:flutter/material.dart';

class Employee {
  int id;
  String name;
  String location;

  Employee({@required this.name, @required this.location, this.id});

  Map<String, dynamic> toMap() {
    return {'name': name, 'location':location};
  }
}
