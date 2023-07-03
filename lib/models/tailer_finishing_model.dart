import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hmanage/models/color_quantity_model.dart';
import 'package:hmanage/models/cutter_finishing_model.dart';
import 'package:hmanage/models/employee_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
part 'tailer_finishing_model.g.dart';

var uuid = const Uuid();

@JsonSerializable()
class TailerFinishingModel {
  final DateTime date;
  final String tailerAssignID;
  final String batchId;
  final EmployeeModel employID;
  final CutterFinishingModel productID;
  final ColorQuantityModel color;
  final double assignedQuantity;
  final double damage;
  double quantity;
  var tailerFinishID = uuid.v4();

  TailerFinishingModel(
      {required this.tailerAssignID,
      required this.assignedQuantity,
      required this.damage,
      required this.batchId,
      required this.date,
      required this.employID,
      required this.productID,
      required this.color,
      required this.quantity});

  factory TailerFinishingModel.fromJson(Map<String, dynamic> json) =>
      _$TailerFinishingModelFromJson(json);
  Map<String, dynamic> toJson() => _$TailerFinishingModelToJson(this);
}
//   date: (json['date'] as Timestamp).toDate(),