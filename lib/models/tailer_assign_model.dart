import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hmanage/models/color_quantity_model.dart';
import 'package:hmanage/models/cutter_finishing_model.dart';
import 'package:hmanage/models/employee_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
part 'tailer_assign_model.g.dart';

var uuid = const Uuid();

@JsonSerializable()
class TailerAssignModel {
  final DateTime date;
  final String batchId;
  final EmployeeModel employId;
  final CutterFinishingModel productId;
  final ColorQuantityModel color;
  final double assignedQuantity;
  double quantity;
  var tailerAssignID = uuid.v4();

  TailerAssignModel(
      {required this.assignedQuantity,
      required this.date,
      required this.batchId,
      required this.employId,
      required this.productId,
      required this.color,
      required this.quantity});

  factory TailerAssignModel.fromJson(Map<String, dynamic> json) =>
      _$TailerAssignModelFromJson(json);
  Map<String, dynamic> toJson() => _$TailerAssignModelToJson(this);
}
//date: (json['date'] as Timestamp).toDate(),