import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hmanage/models/color_quantity_model.dart';
import 'package:hmanage/models/employee_model.dart';
import 'package:hmanage/models/tailer_finishing_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
part 'finisher_assign_model.g.dart';

var uuid = const Uuid();

@JsonSerializable()
class FinisherAssignModel {
  final DateTime date;
  final String batchId;
  final EmployeeModel employID;
  final TailerFinishingModel productID;
  final ColorQuantityModel color;
  final double assignedQuantity;
  double quantity;
  var finisherAssignID = uuid.v4();

  FinisherAssignModel(
      {required this.assignedQuantity,
      required this.date,
      required this.batchId,
      required this.employID,
      required this.productID,
      required this.color,
      required this.quantity});
  factory FinisherAssignModel.fromJson(Map<String, dynamic> json) =>
      _$FinisherAssignModelFromJson(json);
  Map<String, dynamic> toJson() => _$FinisherAssignModelToJson(this);
}
//   date: (json['date'] as Timestamp).toDate(),