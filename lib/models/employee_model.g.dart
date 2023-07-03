// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeModel _$EmployeeModelFromJson(Map<String, dynamic> json) =>
    EmployeeModel(
      empID: json['empID'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      type: $enumDecode(_$UserTypeEnumMap, json['type']),
      status: $enumDecode(_$StatusEnumMap, json['status']),
      password: json['password'] as String,
    );

Map<String, dynamic> _$EmployeeModelToJson(EmployeeModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'type': _$UserTypeEnumMap[instance.type]!,
      'status': _$StatusEnumMap[instance.status]!,
      'password': instance.password,
      'empID': instance.empID,
    };

const _$UserTypeEnumMap = {
  UserType.Admin: 'Admin',
  UserType.Production: 'Production',
  UserType.Purchaser: 'Purchaser',
  UserType.Sales: 'Sales',
  UserType.Accountant: 'Accountant',
  UserType.Cutter: 'Cutter',
  UserType.Tailer: 'Tailer',
  UserType.Finisher: 'Finisher',
};

const _$StatusEnumMap = {
  Status.Active: 'Active',
  Status.Inactive: 'Inactive',
  Status.Suspended: 'Suspended',
};
