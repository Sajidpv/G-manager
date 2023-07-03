// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tailer_finishing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TailerFinishingModel _$TailerFinishingModelFromJson(
        Map<String, dynamic> json) =>
    TailerFinishingModel(
      tailerAssignID: json['tailerAssignID'] as String,
      assignedQuantity: (json['assignedQuantity'] as num).toDouble(),
      damage: (json['damage'] as num).toDouble(),
      batchId: json['batchId'] as String,
      date: (json['date'] as Timestamp).toDate(),
      employID:
          EmployeeModel.fromJson(json['employID'] as Map<String, dynamic>),
      productID: CutterFinishingModel.fromJson(
          json['productID'] as Map<String, dynamic>),
      color: ColorQuantityModel.fromJson(json['color'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toDouble(),
    )..tailerFinishID = json['tailerFinishID'] as String;

Map<String, dynamic> _$TailerFinishingModelToJson(
        TailerFinishingModel instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'tailerAssignID': instance.tailerAssignID,
      'batchId': instance.batchId,
      'employID': instance.employID,
      'productID': instance.productID,
      'color': instance.color,
      'assignedQuantity': instance.assignedQuantity,
      'damage': instance.damage,
      'quantity': instance.quantity,
      'tailerFinishID': instance.tailerFinishID,
    };
