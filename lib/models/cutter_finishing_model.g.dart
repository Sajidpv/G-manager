// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cutter_finishing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CutterFinishingModel _$CutterFinishingModelFromJson(
        Map<String, dynamic> json) =>
    CutterFinishingModel(
      (json['balance'] as num).toDouble(),
      (json['damage'] as num).toDouble(),
      (json['wastage'] as num).toDouble(),
      proAssignID: json['proAssignID'] as String,
      date: (json['date'] as Timestamp).toDate(),
      batchID: json['batchID'] as String,
      productId:
          ProductAddModel.fromJson(json['productId'] as Map<String, dynamic>),
      quantity: (json['quantity'] as List<dynamic>)
          .map((e) => ColorQuantityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      employId:
          EmployeeModel.fromJson(json['employId'] as Map<String, dynamic>),
      materialId:
          StockModel.fromJson(json['materialId'] as Map<String, dynamic>),
      layerCount: (json['layerCount'] as num).toDouble(),
      meterLayer: (json['meterLayer'] as num).toDouble(),
      pieceLayer: (json['pieceLayer'] as num).toDouble(),
      usedFabrics: (json['usedFabrics'] as num).toDouble(),
    )..id = json['id'] as String;

Map<String, dynamic> _$CutterFinishingModelToJson(
        CutterFinishingModel instance) =>
    <String, dynamic>{
      'proAssignID': instance.proAssignID,
      'date': instance.date.toIso8601String(),
      'batchID': instance.batchID,
      'productId': instance.productId,
      'employId': instance.employId,
      'materialId': instance.materialId,
      'layerCount': instance.layerCount,
      'meterLayer': instance.meterLayer,
      'pieceLayer': instance.pieceLayer,
      'quantity': instance.quantity,
      'balance': instance.balance,
      'damage': instance.damage,
      'wastage': instance.wastage,
      'usedFabrics': instance.usedFabrics,
      'id': instance.id,
    };
