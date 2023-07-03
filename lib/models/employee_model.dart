// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
part 'employee_model.g.dart';

var uuid = const Uuid();
int stockCounter = 0;

@JsonSerializable()
class EmployeeModel {
  final String name;
  final String email;
  final UserType type;
  final Status status;
  final String password;
  final String empID;

  EmployeeModel(
      {required this.empID,
      required this.name,
      required this.email,
      required this.type,
      required this.status,
      required this.password});

  factory EmployeeModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeModelFromJson(json);
  Map<String, dynamic> toJson() => _$EmployeeModelToJson(this);
}

String generateEmpID() {
  String stockID = '';
  stockID = 'S$stockCounter';
  stockCounter++;
  return stockID;
}

enum Status { Active, Inactive, Suspended }

enum UserType {
  Admin,
  Production,
  Purchaser,
  Sales,
  Accountant,
  Cutter,
  Tailer,
  Finisher,
}
