import 'package:hmanage/models/employee_model.dart';
import 'package:hmanage/models/item_add_model.dart';

import 'package:hmanage/models/stock_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
part 'cutter_assigned_model.g.dart';

var uuid = const Uuid();

@JsonSerializable()
class CutterAssignModel {
  final DateTime date = DateTime.now();
  final String batchID;
  final ProductAddModel product;
  final StockModel stockID;
  final EmployeeModel employID;
  final double assignedQuantity;
  double quantity;
  var proAssignID = uuid.v4();

  CutterAssignModel(
      {required this.assignedQuantity,
      required this.batchID,
      required this.product,
      required this.stockID,
      required this.employID,
      required this.quantity});
  factory CutterAssignModel.fromJson(Map<String, dynamic> json) =>
      _$CutterAssignModelFromJson(json);
  Map<String, dynamic> toJson() => _$CutterAssignModelToJson(this);
}
