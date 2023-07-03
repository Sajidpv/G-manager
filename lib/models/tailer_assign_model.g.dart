// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tailer_assign_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TailerAssignModel _$TailerAssignModelFromJson(Map<String, dynamic> json) =>
    TailerAssignModel(
      date: (json['date'] as Timestamp).toDate(),
      batchId: json['batchId'] as String,
      employId:
          EmployeeModel.fromJson(json['employId'] as Map<String, dynamic>),
      productId: CutterFinishingModel.fromJson(
          json['productId'] as Map<String, dynamic>),
      color: ColorQuantityModel.fromJson(json['color'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toDouble(),
      assignedQuantity: (json['assignedQuantity'] as num).toDouble(),
    )..tailerAssignID = json['tailerAssignID'] as String;

Map<String, dynamic> _$TailerAssignModelToJson(TailerAssignModel instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'batchId': instance.batchId,
      'employId': instance.employId,
      'productId': instance.productId,
      'color': instance.color,
      'quantity': instance.quantity,
      'tailerAssignID': instance.tailerAssignID,
      'assignedQuantity': instance.assignedQuantity
    };
