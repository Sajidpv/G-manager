import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hmanage/models/color_quantity_model.dart';
import 'package:hmanage/models/employee_model.dart';
import 'package:hmanage/models/tailer_finishing_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
part 'finish_model.g.dart';

var uuid = const Uuid();

@JsonSerializable()
class FinishModel {
  final DateTime date;
  final String batchId;
  final EmployeeModel employID;
  final TailerFinishingModel productID;
  final ColorQuantityModel color;
  final String finisherAssignID;
  final double finishedQuantity;
  final double damage;
  double quantity;
  var finishedID = uuid.v4();

  FinishModel(
      {required this.finishedQuantity,
      required this.damage,
      required this.date,
      required this.finisherAssignID,
      required this.batchId,
      required this.employID,
      required this.productID,
      required this.color,
      required this.quantity});
  factory FinishModel.fromJson(Map<String, dynamic> json) =>
      _$FinishModelFromJson(json);
  Map<String, dynamic> toJson() => _$FinishModelToJson(this);
}
//   date: (json['date'] as Timestamp).toDate(),