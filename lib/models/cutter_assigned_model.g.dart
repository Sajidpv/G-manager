// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cutter_assigned_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CutterAssignModel _$CutterAssignModelFromJson(Map<String, dynamic> json) =>
    CutterAssignModel(
      batchID: json['batchID'] as String,
      product:
          ProductAddModel.fromJson(json['product'] as Map<String, dynamic>),
      stockID: StockModel.fromJson(json['stockID'] as Map<String, dynamic>),
      employID:
          EmployeeModel.fromJson(json['employID'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toDouble(),
      assignedQuantity: (json['assignedQuantity'] as num).toDouble(),
    )..proAssignID = json['proAssignID'] as String;

Map<String, dynamic> _$CutterAssignModelToJson(CutterAssignModel instance) =>
    <String, dynamic>{
      'batchID': instance.batchID,
      'product': instance.product,
      'stockID': instance.stockID,
      'employID': instance.employID,
      'assignedQuantity': instance.assignedQuantity,
      'quantity': instance.quantity,
      'proAssignID': instance.proAssignID,
    };
