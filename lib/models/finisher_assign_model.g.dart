// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finisher_assign_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinisherAssignModel _$FinisherAssignModelFromJson(Map<String, dynamic> json) =>
    FinisherAssignModel(
      date: (json['date'] as Timestamp).toDate(),
      batchId: json['batchId'] as String,
      employID:
          EmployeeModel.fromJson(json['employID'] as Map<String, dynamic>),
      productID: TailerFinishingModel.fromJson(
          json['productID'] as Map<String, dynamic>),
      color: ColorQuantityModel.fromJson(json['color'] as Map<String, dynamic>),
      assignedQuantity: (json['assignedQuantity'] as num).toDouble(),
      quantity: (json['quantity'] as num).toDouble(),
    )..finisherAssignID = json['finisherAssignID'] as String;

Map<String, dynamic> _$FinisherAssignModelToJson(
        FinisherAssignModel instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'batchId': instance.batchId,
      'employID': instance.employID,
      'productID': instance.productID,
      'color': instance.color,
      'assignedQuantity': instance.assignedQuantity,
      'quantity': instance.quantity,
      'finisherAssignID': instance.finisherAssignID,
    };
