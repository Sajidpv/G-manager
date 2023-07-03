// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierModel _$SupplierModelFromJson(Map<String, dynamic> json) =>
    SupplierModel(
      json['name'] as String,
      json['address'] as String,
      $enumDecode(_$StatusEnumMap, json['status']),
    )..suppID = json['suppID'] as String;

Map<String, dynamic> _$SupplierModelToJson(SupplierModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'status': _$StatusEnumMap[instance.status]!,
      'suppID': instance.suppID,
    };

const _$StatusEnumMap = {
  Status.Active: 'Active',
  Status.Inactive: 'Inactive',
  Status.Suspended: 'Suspended',
};
