// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finish_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinishModel _$FinishModelFromJson(Map<String, dynamic> json) => FinishModel(
      date: (json['date'] as Timestamp).toDate(),
      finishedQuantity: (json['finishedQuantity'] as num).toDouble(),
      damage: (json['damage'] as num).toDouble(),
      batchId: json['batchId'] as String,
      finisherAssignID: json['finisherAssignID'] as String,
      employID:
          EmployeeModel.fromJson(json['employID'] as Map<String, dynamic>),
      productID: TailerFinishingModel.fromJson(
          json['productID'] as Map<String, dynamic>),
      color: ColorQuantityModel.fromJson(json['color'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toDouble(),
    )..finishedID = json['finishedID'] as String;

Map<String, dynamic> _$FinishModelToJson(FinishModel instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'batchId': instance.batchId,
      'employID': instance.employID,
      'productID': instance.productID,
      'color': instance.color,
      'finishedQuantity': instance.finishedQuantity,
      'quantity': instance.quantity,
      'damage': instance.damage,
      'finishedID': instance.finishedID,
      'finisherAssignID': instance.finisherAssignID
    };
