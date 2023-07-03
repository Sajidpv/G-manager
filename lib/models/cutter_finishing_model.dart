import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hmanage/models/color_quantity_model.dart';
import 'package:hmanage/models/employee_model.dart';
import 'package:hmanage/models/item_add_model.dart';
import 'package:hmanage/models/stock_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
part 'cutter_finishing_model.g.dart';

var uuid = const Uuid();

@JsonSerializable()
class CutterFinishingModel {
  final DateTime date;
  final String proAssignID;
  final String batchID;
  final ProductAddModel productId;
  final EmployeeModel employId;
  final StockModel materialId;
  final double layerCount;
  final double meterLayer;
  final double pieceLayer;
  List<ColorQuantityModel> quantity;
  double balance;
  double damage;
  double wastage;
  final double usedFabrics;
  var id = uuid.v4();
//date: (json['date'] as Timestamp).toDate(),
  CutterFinishingModel(this.balance, this.damage, this.wastage,
      {required this.proAssignID,
      required this.date,
      required this.batchID,
      required this.productId,
      required this.quantity,
      required this.employId,
      required this.materialId,
      required this.layerCount,
      required this.meterLayer,
      required this.pieceLayer,
      required this.usedFabrics});

  factory CutterFinishingModel.fromJson(Map<String, dynamic> json) =>
      _$CutterFinishingModelFromJson(json);
  Map<String, dynamic> toJson() => _$CutterFinishingModelToJson(this);
}
//  'date': Timestamp.fromDate(instance.date),date: timestamp.toDate(),