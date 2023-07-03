import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hmanage/db_functions/collections.dart';
import 'package:hmanage/models/colors_model.dart';
import 'package:hmanage/models/cutter_assigned_model.dart';
import 'package:hmanage/models/cutter_finishing_model.dart';
import 'package:hmanage/models/employee_model.dart';
import 'package:hmanage/models/finish_model.dart';
import 'package:hmanage/models/finisher_assign_model.dart';
import 'package:hmanage/models/item_add_model.dart';
import 'package:hmanage/models/product_model.dart';
import 'package:hmanage/models/stock_model.dart';
import 'package:hmanage/models/supplier_model.dart';
import 'package:hmanage/models/tailer_assign_model.dart';
import 'package:hmanage/models/tailer_finishing_model.dart';
import 'package:hmanage/widgets/show_snack_bar.dart';
import 'package:collection/collection.dart';

final _firebase = FirebaseAuth.instance;

class FirestoreUtil {
//USERS Functions

  static Future<List<EmployeeModel>> getUsers(List<String>? ids) async {
    try {
      final usersRef = FirebaseFirestore.instance
          .collection(employeeCollection)
          .withConverter<EmployeeModel>(
              fromFirestore: (snapshot, _) =>
                  EmployeeModel.fromJson(snapshot.data()!),
              toFirestore: (users, _) => users.toJson());
      QuerySnapshot<EmployeeModel> usersDoc;
      if (ids != null && ids.isNotEmpty) {
        usersDoc = await usersRef.where('email', whereIn: ids).get();
      } else {
        usersDoc = await usersRef.get();
      }
      return usersDoc.docs.map((e) => e.data()).toList();
    } on FirebaseException catch (e, stacktrace) {
      print('Error while loading $stacktrace : ${e.code}');
    }
    return [];
  }

  static Future<List<EmployeeModel>> getFilterdUsers(UserType type) async {
    List<EmployeeModel> allUsers = await getUsers(null);
    List<EmployeeModel> filteredUsers =
        allUsers.where((user) => user.type == type).toList();
    return filteredUsers;
  }

  static Future<void> addEmployee(
      EmployeeModel model, BuildContext context) async {
    try {
      final usersDoc = FirebaseFirestore.instance
          .collection(employeeCollection)
          .doc(model.empID);

      final userSnapshot = await usersDoc.get();
      if (userSnapshot.exists) {
        showSnackBar(context, '${model.empID} already exist ');
      } else {
        await _firebase.createUserWithEmailAndPassword(
            email: model.email, password: model.password);

        String userTypeString = model.type.toString().split('.').last;
        String statusString = model.status.toString().split('.').last;

        await usersDoc.set({
          'createdAt': Timestamp.now(),
          'name': model.name,
          'email': model.email,
          'type': userTypeString,
          'status': statusString,
          'password': model.password,
          'empID': model.empID
        });
        showSnackBar(context, 'New Employee added ${model.name}');
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        //error handled
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      showSnackBar(context, error.message ?? 'Authentication Failed');
    }
  }

//SUPPLIER functions
  static Future<void> addSupplier(SupplierModel model, context) async {
    try {
      Navigator.pop(context);
      final String status = model.status.toString().split('.').last;
      await FirebaseFirestore.instance
          .collection(supplierCollection)
          .doc(model.suppID)
          .set({
        'createdAt': Timestamp.now(),
        'suppID': model.suppID,
        'name': model.name,
        'address': model.address,
        'status': status
      });
      showSnackBar(context, 'New Supplier added: ${model.name} ');
    } on FirebaseException catch (error) {
      showSnackBar(context, 'Error: $error');
    }
  }

  static Future<List<SupplierModel>> getSuppliers(List<String>? ids) async {
    try {
      final supplierRef = FirebaseFirestore.instance
          .collection(supplierCollection)
          .withConverter<SupplierModel>(
              fromFirestore: (snapshot, _) =>
                  SupplierModel.fromJson(snapshot.data()!),
              toFirestore: (suppliers, _) => suppliers.toJson());
      QuerySnapshot<SupplierModel> supplierDoc;
      if (ids != null && ids.isNotEmpty) {
        supplierDoc = await supplierRef.where('suppID', whereIn: ids).get();
      } else {
        supplierDoc = await supplierRef.get();
      }

      return supplierDoc.docs.map((e) => e.data()).toList();
    } on FirebaseException catch (e, stacktrace) {
      print('Error while loading $stacktrace : ${e.code}');
    }
    return [];
  }

//STOCK functions
  static Future<void> addStock(StockModel model, BuildContext context) async {
    try {
      final stockDoc = FirebaseFirestore.instance
          .collection(stockCollections)
          .doc(model.itemCode);

      final stockSnapshot = await stockDoc.get();
      if (stockSnapshot.exists) {
        // Stock item already exists, update the quantity
        final existingQuantity = stockSnapshot.get('quantity') as double;
        final newQuantity = existingQuantity + model.quantity;
        await stockDoc.update({
          'quantity': newQuantity,
        });

        showSnackBar(context, '${model.name} Quantity updated');
      } else {
        print(model.hsn);
        // Stock item does not exist, create a new entry
        await stockDoc.set({
          'createdAt': Timestamp.now(),
          'itemCode': model.itemCode,
          'name': model.name,
          'hsn': model.hsn,
          'quantity': model.quantity,
        });

        showSnackBar(context, 'New Stock added ${model.name} ');
      }
    } on FirebaseException catch (error) {
      print(error.code);
    }
  }

  static Future<List<StockModel>> getStock(List<String>? ids) async {
    try {
      final stockRef = FirebaseFirestore.instance
          .collection(stockCollections)
          .withConverter<StockModel>(
              fromFirestore: (snapshot, _) =>
                  StockModel.fromJson(snapshot.data()!),
              toFirestore: (material, _) => material.toJson());
      QuerySnapshot<StockModel> stockDoc;
      if (ids != null && ids.isNotEmpty) {
        stockDoc = await stockRef.where('itemCode', whereIn: ids).get();
      } else {
        stockDoc = await stockRef.get();
      }

      return stockDoc.docs.map((e) => e.data()).toList();
    } on FirebaseException catch (e, stacktrace) {
      print('Error while loading $stacktrace : ${e.code}');
    }
    return [];
  }

//MATERIAL_PRODUCT functions
  static Future<List<ProductMaterialModel>> getPurchase(
      List<String>? ids) async {
    try {
      final materialRef = FirebaseFirestore.instance
          .collection(materialCollection)
          .withConverter<ProductMaterialModel>(
              fromFirestore: (snapshot, _) =>
                  ProductMaterialModel.fromJson(snapshot.data()!),
              toFirestore: (items, _) => items.toJson());
      QuerySnapshot<ProductMaterialModel> materialDoc;
      if (ids != null && ids.isNotEmpty) {
        materialDoc = await materialRef.where('purID', whereIn: ids).get();
      } else {
        materialDoc = await materialRef.get();
      }
      return materialDoc.docs.map((e) => e.data()).toList();
    } on FirebaseException catch (e, stacktrace) {
      print('Error while loading $stacktrace : ${e.code}');
    }
    return [];
  }

  static Future<void> addPurchase(
      ProductMaterialModel model, BuildContext context) async {
    try {
      final String status = model.supplier.status.toString().split('.').last;
      final purchaseDoc = FirebaseFirestore.instance
          .collection(materialCollection)
          .doc(model.purID);
      final purchaseSnapshot = await purchaseDoc.get();
      if (purchaseSnapshot.exists) {
        showSnackBar(context, '${model.purID} Already Exist');
      } else {
        await purchaseDoc.set({
          'date': model.date,
          'purID': model.purID,
          'supplier': {
            'name': model.supplier.name,
            'address': model.supplier.address,
            'status': status,
            'suppID': model.supplier.suppID,
          },
          'invoice': model.invoice,
          'description': model.description,
          'totalAmount': model.totalAmount,
          'items': model.items.map((item) {
            //  addStock() for each item
            addStock(item.name, context);

            return {
              'name': {
                'name': item.name.name,
                'hsn': item.name.hsn,
                'itemCode': item.name.itemCode,
                'quantity': item.name.quantity,
              },
              'quantity': item.quantity,
              'amount': item.amount,
              'sum': item.sum,
              'proID': item.proID,
            };
          }).toList(),
        });
        if (context.mounted) showSnackBar(context, 'New Purchase added ');
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      showSnackBar(context, error.message ?? 'Authentication Failed');
    }
  }

//PRODUCT add function

  static Future<void> addProduct(
      ProductAddModel model, BuildContext context) async {
    try {
      final proDoc = FirebaseFirestore.instance
          .collection(productCollection)
          .doc(model.itemCode);

      final proSnapshot = await proDoc.get();
      if (proSnapshot.exists) {
        // final existingItem = proSnapshot.get('itemCode') as String;
        showSnackBar(context, '${model.itemCode} already exist ');
      } else {
        await proDoc.set({
          'createdAt': Timestamp.now(),
          'name': model.name,
          'itemCode': model.itemCode,
        });
        showSnackBar(context, '${model.name} Added ');
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      showSnackBar(context, error.message ?? 'Failed to add');
    }
  }

  static Future<List<ProductAddModel>> getProduct(List<String>? ids) async {
    try {
      final productRef = FirebaseFirestore.instance
          .collection(productCollection)
          .withConverter<ProductAddModel>(
              fromFirestore: (snapshot, _) =>
                  ProductAddModel.fromJson(snapshot.data()!),
              toFirestore: (items, _) => items.toJson());
      QuerySnapshot<ProductAddModel> productDoc;
      if (ids != null && ids.isNotEmpty) {
        productDoc = await productRef.where('itemCode', whereIn: ids).get();
      } else {
        productDoc = await productRef.get();
      }
      return productDoc.docs.map((e) => e.data()).toList();
    } on FirebaseException catch (e, stacktrace) {
      print('Error while loading $stacktrace : ${e.code}');
    }
    return [];
  }

  //COLOR add function

  static Future<void> addColors(ColorModel model, BuildContext context) async {
    try {
      final colorDoc =
          FirebaseFirestore.instance.collection(colorCollection).doc(model.id);

      final colorSnapshot = await colorDoc.get();
      if (colorSnapshot.exists) {
        showSnackBar(context, '${model.color} already exist ');
      } else {
        await colorDoc.set({
          'createdAt': Timestamp.now(),
          'color': model.color,
          'id': model.id
        });
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      showSnackBar(context, error.message ?? 'Failed to add');
    }
  }

  static Future<List<ColorModel>> getColors(List<String>? ids) async {
    try {
      final colorRef = FirebaseFirestore.instance
          .collection(colorCollection)
          .withConverter<ColorModel>(
              fromFirestore: (snapshot, _) =>
                  ColorModel.fromJson(snapshot.data()!),
              toFirestore: (items, _) => items.toJson());
      QuerySnapshot<ColorModel> colorDoc;
      if (ids != null && ids.isNotEmpty) {
        colorDoc = await colorRef.where('id', whereIn: ids).get();
      } else {
        colorDoc = await colorRef.get();
      }
      return colorDoc.docs.map((e) => e.data()).toList();
    } on FirebaseException catch (e, stacktrace) {
      print('Error while loading $stacktrace : ${e.code}');
    }
    return [];
  }

//CUTTER assign
  static Future<List<CutterAssignModel>> getAssignCutter(
      List<String>? ids) async {
    try {
      final cuttingRef = FirebaseFirestore.instance
          .collection(cutterAssignCollection)
          .withConverter<CutterAssignModel>(
              fromFirestore: (snapshot, _) =>
                  CutterAssignModel.fromJson(snapshot.data()!),
              toFirestore: (items, _) => items.toJson());
      QuerySnapshot<CutterAssignModel> cuttingDoc;
      if (ids != null && ids.isNotEmpty) {
        cuttingDoc = await cuttingRef.where('proAssignID', whereIn: ids).get();
      } else {
        cuttingDoc = await cuttingRef.get();
      }
      return cuttingDoc.docs.map((e) => e.data()).toList();
    } on FirebaseException catch (e, stacktrace) {
      print('Error while loading $stacktrace : ${e.code}');
    }
    return [];
  }

  static Future<void> assignCutter(
      CutterAssignModel model, BuildContext context) async {
    try {
      final stockDoc = await FirebaseFirestore.instance
          .collection(stockCollections)
          .doc(model.stockID.itemCode)
          .get();
      if (stockDoc.exists) {
        final stockData = stockDoc.data() as Map<String, dynamic>;
        final double currentQuantity = stockData['quantity'] as double;

        if (currentQuantity >= model.quantity) {
          final double newQuantity = currentQuantity - model.quantity;
          await stockDoc.reference.update({'quantity': newQuantity});

          await FirebaseFirestore.instance
              .collection(cutterAssignCollection)
              .doc(model.proAssignID)
              .set({
            'createdAt': model.date,
            'batchID': model.batchID,
            'product': {
              'name': model.product.name,
              'itemCode': model.product.itemCode
            },
            'stockID': {
              'name': model.stockID.name,
              'hsn': model.stockID.hsn,
              'quantity': model.stockID.quantity,
              'itemCode': model.stockID.itemCode
            },
            'employID': {
              'name': model.employID.name,
              'email': model.employID.email,
              'type': model.employID.type.toString().split('.').last,
              'status': model.employID.status.toString().split('.').last,
              'password': model.employID.password,
              'empID': model.employID.empID
            },
            'assignedQuantity': model.assignedQuantity,
            'quantity': model.quantity,
            'proAssignID': model.proAssignID
          });

          showSnackBar(context,
              ' Assigned to ${model.employID.name} - ${model.product.name}');
        } else {
          showSnackBar(context, 'Insufficient quantity');
          return;
        }
      } else {
        showSnackBar(context, 'Document not found');
        return;
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      showSnackBar(context, error.message ?? 'Authentication Failed');
    }
  }

//CUTTER finishing

  static Future<List<CutterFinishingModel>> getFinishCutter(
      List<String>? ids) async {
    try {
      final cuttingRef = FirebaseFirestore.instance
          .collection(cutterFinishCollection)
          .withConverter<CutterFinishingModel>(
              fromFirestore: (snapshot, _) =>
                  CutterFinishingModel.fromJson(snapshot.data()!),
              toFirestore: (items, _) => items.toJson());
      QuerySnapshot<CutterFinishingModel> cuttingDoc;
      if (ids != null && ids.isNotEmpty) {
        cuttingDoc = await cuttingRef.where('id', whereIn: ids).get();
      } else {
        cuttingDoc = await cuttingRef.get();
      }
      return cuttingDoc.docs.map((e) => e.data()).toList();
    } on FirebaseException catch (e, stacktrace) {
      print('Error while loading $stacktrace : ${e.code}');
    }
    return [];
  }

  static Future<CutterAssignModel?> getCutterAssignByBatch(
      String batchID, EmployeeModel employee) async {
    List<CutterAssignModel> allItems = await getAssignCutter(null);
    return allItems.firstWhereOrNull(
      (item) =>
          item.batchID == batchID && item.employID.empID == employee.empID,
    );
  }

  static Future<void> finishCutter(
      CutterFinishingModel model, BuildContext context) async {
    try {
      final stockDoc = await FirebaseFirestore.instance
          .collection(cutterAssignCollection)
          .doc(model.proAssignID)
          .get();
      if (stockDoc.exists) {
        final stockData = stockDoc.data() as Map<String, dynamic>;
        final double currentQuantity = stockData['quantity'] as double;

        if (currentQuantity >= model.usedFabrics) {
          final double newQuantity = currentQuantity - model.usedFabrics;
          await stockDoc.reference.update({'quantity': newQuantity});

          await FirebaseFirestore.instance
              .collection(cutterFinishCollection)
              .doc(model.id)
              .set({
            'date': model.date,
            'proAssignID': model.proAssignID,
            'batchID': model.batchID,
            'productId': {
              'name': model.productId.name,
              'itemCode': model.productId.itemCode
            },
            'materialId': {
              'name': model.materialId.name,
              'hsn': model.materialId.hsn,
              'quantity': model.materialId.quantity,
              'itemCode': model.materialId.itemCode
            },
            'employId': {
              'name': model.employId.name,
              'email': model.employId.email,
              'type': model.employId.type.toString().split('.').last,
              'status': model.employId.status.toString().split('.').last,
              'password': model.employId.password,
              'empID': model.employId.empID
            },
            'quantity': model.quantity.map((item) {
              return {
                'color': item.color,
                'quantity': item.quantity,
                'colorCode': item.colorCode,
              };
            }).toList(),
            'layerCount': model.layerCount,
            'meterLayer': model.meterLayer,
            'pieceLayer': model.pieceLayer,
            'balance': model.balance,
            'damage': model.damage,
            'wastage': model.wastage,
            'usedFabrics': model.usedFabrics,
            'id': model.id
          });

          if (context.mounted) {
            showSnackBar(context,
                ' Finished by ${model.employId.name} - ${model.productId.name}');
          }
        } else {
          showSnackBar(context, 'Insufficient quantity');
          return;
        }
      } else {
        showSnackBar(context, 'Document not found');
        return;
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      showSnackBar(context, error.message ?? 'Authentication Failed');
    }
  }

//Tailer assign
  static Future<List<TailerAssignModel>> getAssignTailer(
      List<String>? ids) async {
    try {
      final tailerRef = FirebaseFirestore.instance
          .collection(tailerAssignCollection)
          .withConverter<TailerAssignModel>(
              fromFirestore: (snapshot, _) =>
                  TailerAssignModel.fromJson(snapshot.data()!),
              toFirestore: (items, _) => items.toJson());
      QuerySnapshot<TailerAssignModel> tailerDoc;
      if (ids != null && ids.isNotEmpty) {
        tailerDoc = await tailerRef.where('tailerAssignID', whereIn: ids).get();
      } else {
        tailerDoc = await tailerRef.get();
      }
      return tailerDoc.docs.map((e) => e.data()).toList();
    } on FirebaseException catch (e, stacktrace) {
      print('Error while loading $stacktrace : ${e.code}');
    }
    return [];
  }

  static Future<void> assignTailer(
      TailerAssignModel model, BuildContext context) async {
    try {
      final cfDoc = await FirebaseFirestore.instance
          .collection(cutterFinishCollection)
          .doc(model.productId.id)
          .get();

      if (cfDoc.exists) {
        final cutterFinishingData = cfDoc.data() as Map<String, dynamic>;
        final List<dynamic> quantityList = cutterFinishingData['quantity'];

        for (var i = 0; i < quantityList.length; i++) {
          final Map<String, dynamic> colorQuantity =
              quantityList[i] as Map<String, dynamic>;
          final String color = colorQuantity['color'] as String;

          if (color == model.color.color) {
            final double currentQuantity = colorQuantity['quantity'] as double;

            if (currentQuantity >= model.quantity) {
              final double newQuantity = currentQuantity - model.quantity;
              quantityList[i]['quantity'] = newQuantity;
              await FirebaseFirestore.instance
                  .collection(tailerAssignCollection)
                  .doc(model.tailerAssignID)
                  .set({
                'date': model.date,
                'batchId': model.batchId,
                'productId': {
                  'proAssignID': model.productId.proAssignID,
                  'date': model.productId.date,
                  'batchID': model.productId.batchID,
                  'productId': {
                    'name': model.productId.productId.name,
                    'itemCode': model.productId.productId.itemCode
                  },
                  'materialId': {
                    'name': model.productId.materialId.name,
                    'hsn': model.productId.materialId.hsn,
                    'quantity': model.productId.materialId.quantity,
                    'itemCode': model.productId.materialId.itemCode
                  },
                  'employId': {
                    'name': model.productId.employId.name,
                    'email': model.productId.employId.email,
                    'type': model.productId.employId.type
                        .toString()
                        .split('.')
                        .last,
                    'status': model.productId.employId.status
                        .toString()
                        .split('.')
                        .last,
                    'password': model.productId.employId.password,
                    'empID': model.productId.employId.empID
                  },
                  'quantity': model.productId.quantity.map((item) {
                    return {
                      'color': item.color,
                      'quantity': item.quantity,
                      'colorCode': item.colorCode,
                    };
                  }).toList(),
                  'layerCount': model.productId.layerCount,
                  'meterLayer': model.productId.meterLayer,
                  'pieceLayer': model.productId.pieceLayer,
                  'balance': model.productId.balance,
                  'damage': model.productId.damage,
                  'wastage': model.productId.wastage,
                  'usedFabrics': model.productId.usedFabrics,
                  'id': model.productId.id
                },
                'employId': {
                  'name': model.employId.name,
                  'email': model.employId.email,
                  'type': model.employId.type.toString().split('.').last,
                  'status': model.employId.status.toString().split('.').last,
                  'password': model.employId.password,
                  'empID': model.employId.empID
                },
                'color': {
                  'colorCode': model.color.colorCode,
                  'color': model.color.color,
                  'quantity': model.color.quantity,
                },
                'assignedQuantity': model.assignedQuantity,
                'quantity': model.quantity,
                'tailerAssignID': model.tailerAssignID,
              });

              if (context.mounted) {
                showSnackBar(context,
                    ' Assigned to ${model.employId.name} - ${model.productId.productId.name}');
              }
              break;
            } else {
              showSnackBar(context, 'Insufficient quantity');
              return;
            }
          }
        }
        await cfDoc.reference.update({'quantity': quantityList});
      } else {
        showSnackBar(context, 'Document not found');
        return;
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      showSnackBar(context, error.message ?? 'Authentication Failed');
    }
  }

  //TAILER finishing

  static Future<List<TailerFinishingModel>> getFinishTailer(
      List<String>? ids) async {
    try {
      final tailerRef = FirebaseFirestore.instance
          .collection(tailerFinishCollection)
          .withConverter<TailerFinishingModel>(
              fromFirestore: (snapshot, _) =>
                  TailerFinishingModel.fromJson(snapshot.data()!),
              toFirestore: (items, _) => items.toJson());
      QuerySnapshot<TailerFinishingModel> tailerDoc;
      if (ids != null && ids.isNotEmpty) {
        tailerDoc = await tailerRef.where('tailerFinishID', whereIn: ids).get();
      } else {
        tailerDoc = await tailerRef.get();
      }
      return tailerDoc.docs.map((e) => e.data()).toList();
    } on FirebaseException catch (e, stacktrace) {
      print('Error while loading $stacktrace : ${e.code}');
    }
    return [];
  }

  static Future<TailerAssignModel?> getTailerAssignByBatch(
      String batchID, EmployeeModel employee) async {
    List<TailerAssignModel> allItems = await getAssignTailer(null);
    return allItems.firstWhereOrNull(
      (item) =>
          item.batchId == batchID && item.employId.empID == employee.empID,
    );
  }

  static Future<void> finishTailer(
      TailerFinishingModel model, BuildContext context) async {
    try {
      final stockDoc = await FirebaseFirestore.instance
          .collection(tailerAssignCollection)
          .doc(model.tailerAssignID)
          .get();
      if (stockDoc.exists) {
        final stockData = stockDoc.data() as Map<String, dynamic>;
        final double currentQuantity = stockData['quantity'] as double;

        if (currentQuantity >= model.quantity) {
          final double newQuantity =
              currentQuantity - (model.quantity + model.damage);
          await stockDoc.reference.update({'quantity': newQuantity});

          await FirebaseFirestore.instance
              .collection(tailerFinishCollection)
              .doc(model.tailerFinishID)
              .set({
            'date': model.date,
            'tailerAssignID': model.tailerAssignID,
            'batchId': model.batchId,
            'employID': {
              'name': model.employID.name,
              'email': model.employID.email,
              'type': model.employID.type.toString().split('.').last,
              'status': model.employID.status.toString().split('.').last,
              'password': model.employID.password,
              'empID': model.employID.empID
            },
            'productID': {
              'id': model.productID.id,
              'proAssignID': model.productID.proAssignID,
              'balance': model.productID.balance,
              'damage': model.productID.damage,
              'wastage': model.productID.wastage,
              'date': model.productID.date,
              'batchID': model.productID.batchID,
              'layerCount': model.productID.layerCount,
              'meterLayer': model.productID.meterLayer,
              'pieceLayer': model.productID.pieceLayer,
              'usedFabrics': model.productID.usedFabrics,
              'materialId': {
                'name': model.productID.materialId.name,
                'hsn': model.productID.materialId.hsn,
                'itemCode': model.productID.materialId.itemCode,
                'quantity': model.productID.materialId.quantity,
              },
              'employId': {
                'empID': model.productID.employId.empID,
                'name': model.productID.employId.name,
                'email': model.productID.employId.email,
                'type':
                    model.productID.employId.type.toString().split('.').last,
                'status':
                    model.productID.employId.status.toString().split('.').last,
                'password': model.productID.employId.password,
              },
              'quantity': model.productID.quantity.map((item) {
                return {
                  'color': item.color,
                  'quantity': item.quantity,
                  'colorCode': item.colorCode,
                };
              }).toList(),
              'productId': {
                'itemCode': model.productID.productId.itemCode,
                'name': model.productID.productId.name,
              },
            },
            'color': {
              'color': model.color.color,
              'quantity': model.color.quantity,
              'colorCode': model.color.colorCode,
            },
            'quantity': model.quantity,
            'assignedQuantity': model.assignedQuantity,
            'damage': model.damage,
            'tailerFinishID': model.tailerFinishID
          });

          if (context.mounted) {
            showSnackBar(context,
                ' Finished by ${model.employID.name} - ${model.productID.productId.name}');
          }
        } else {
          showSnackBar(context, 'Insufficient quantity');
          return;
        }
      } else {
        showSnackBar(context, 'Document not found');
        return;
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      showSnackBar(context, error.message ?? 'Authentication Failed');
    }
  }

//FINISHER assign
  static Future<List<FinisherAssignModel>> getAssignFinisher(
      List<String>? ids) async {
    try {
      final finisherRef = FirebaseFirestore.instance
          .collection(finisherAssignCollection)
          .withConverter<FinisherAssignModel>(
              fromFirestore: (snapshot, _) =>
                  FinisherAssignModel.fromJson(snapshot.data()!),
              toFirestore: (items, _) => items.toJson());
      QuerySnapshot<FinisherAssignModel> finisherDoc;
      if (ids != null && ids.isNotEmpty) {
        finisherDoc =
            await finisherRef.where('finisherAssignID', whereIn: ids).get();
      } else {
        finisherDoc = await finisherRef.get();
      }
      return finisherDoc.docs.map((e) => e.data()).toList();
    } on FirebaseException catch (e, stacktrace) {
      print('Error while loading $stacktrace : ${e.code}');
    }
    return [];
  }

  static Future<void> assignFinisher(
      FinisherAssignModel model, BuildContext context) async {
    try {
      final stockDoc = await FirebaseFirestore.instance
          .collection(tailerFinishCollection)
          .doc(model.productID.tailerFinishID)
          .get();
      if (stockDoc.exists) {
        final stockData = stockDoc.data() as Map<String, dynamic>;
        final double currentQuantity = stockData['quantity'] as double;

        if (currentQuantity >= model.quantity) {
          final double newQuantity = currentQuantity - model.quantity;
          await stockDoc.reference.update({'quantity': newQuantity});

          await FirebaseFirestore.instance
              .collection(finisherAssignCollection)
              .doc(model.finisherAssignID)
              .set({
            'date': model.date,
            'batchId': model.batchId,
            'productID': {
              'batchId': model.productID.batchId,
              'tailerFinishID': model.productID.tailerFinishID,
              'tailerAssignID': model.productID.tailerAssignID,
              'assignedQuantity': model.productID.assignedQuantity,
              'damage': model.productID.damage,
              'date': model.productID.date,
              'color': {
                'colorCode': model.productID.color.colorCode,
                'color': model.productID.color.color,
                'quantity': model.productID.color.quantity,
              },
              'quantity': model.productID.quantity,
              'employID': {
                'empID': model.productID.employID.empID,
                'name': model.productID.employID.name,
                'email': model.productID.employID.email,
                'type':
                    model.productID.employID.type.toString().split('.').last,
                'status':
                    model.productID.employID.status.toString().split('.').last,
                'password': model.productID.employID.password,
              },
              'productID': {
                'batchID': model.productID.productID.batchID,
                'balance': model.productID.productID.balance,
                'damage': model.productID.productID.damage,
                'wastage': model.productID.productID.wastage,
                'date': model.productID.productID.date,
                'productId': {
                  'itemCode': model.productID.productID.productId.itemCode,
                  'name': model.productID.productID.productId.name
                },
                'quantity': model.productID.productID.quantity.map((item) {
                  return {
                    'color': item.color,
                    'quantity': item.quantity,
                    'colorCode': item.colorCode,
                  };
                }).toList(),
                'employId': {
                  'empID': model.productID.productID.employId.empID,
                  'name': model.productID.productID.employId.name,
                  'email': model.productID.productID.employId.email,
                  'password': model.productID.productID.employId.password,
                  'type': model.productID.productID.employId.type
                      .toString()
                      .split('.')
                      .last,
                  'status': model.productID.productID.employId.status
                      .toString()
                      .split('.')
                      .last,
                },
                'materialId': {
                  'itemCode': model.productID.productID.materialId.itemCode,
                  'name': model.productID.productID.materialId.name,
                  'quantity': model.productID.productID.materialId.quantity,
                  'hsn': model.productID.productID.materialId.hsn,
                },
                'layerCount': model.productID.productID.layerCount,
                'meterLayer': model.productID.productID.meterLayer,
                'pieceLayer': model.productID.productID.pieceLayer,
                'usedFabrics': model.productID.productID.usedFabrics,
                'id': model.productID.productID.id,
                'proAssignID': model.productID.productID.proAssignID,
              }
            },
            'employID': {
              'name': model.employID.name,
              'email': model.employID.email,
              'type': model.employID.type.toString().split('.').last,
              'status': model.employID.status.toString().split('.').last,
              'password': model.employID.password,
              'empID': model.employID.empID
            },
            'color': {
              'colorCode': model.color.colorCode,
              'color': model.color.color,
              'quantity': model.color.quantity,
            },
            'assignedQuantity': model.assignedQuantity,
            'quantity': model.quantity,
            'finisherAssignID': model.finisherAssignID,
          });

          if (context.mounted) {
            showSnackBar(context,
                ' Assigned to ${model.employID.name} - ${model.productID.productID.materialId.name}');
          }
        } else {
          showSnackBar(context, 'Insufficient quantity');
          return;
        }
      } else {
        showSnackBar(context, 'document not found');
        return;
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      showSnackBar(context, error.message ?? 'Authentication Failed');
    }
  }

  //FINISHING

  static Future<List<FinishModel>> getFinishing(List<String>? ids) async {
    try {
      final finishRef = FirebaseFirestore.instance
          .collection(finishCollection)
          .withConverter<FinishModel>(
              fromFirestore: (snapshot, _) =>
                  FinishModel.fromJson(snapshot.data()!),
              toFirestore: (items, _) => items.toJson());
      QuerySnapshot<FinishModel> finishDoc;
      if (ids != null && ids.isNotEmpty) {
        finishDoc = await finishRef.where('finishedID', whereIn: ids).get();
      } else {
        finishDoc = await finishRef.get();
      }
      return finishDoc.docs.map((e) => e.data()).toList();
    } on FirebaseException catch (e, stacktrace) {
      print('Error while loading $stacktrace : ${e.code}');
    }
    return [];
  }

  static Future<void> finishing(FinishModel model, BuildContext context) async {
    try {
      final stockDoc = await FirebaseFirestore.instance
          .collection(finisherAssignCollection)
          .doc(model.finisherAssignID)
          .get();
      if (stockDoc.exists) {
        final stockData = stockDoc.data() as Map<String, dynamic>;
        final double currentQuantity = stockData['quantity'] as double;

        if (currentQuantity >= model.quantity) {
          final double newQuantity = currentQuantity - model.quantity;
          await stockDoc.reference.update({'quantity': newQuantity});

          await FirebaseFirestore.instance
              .collection(finishCollection)
              .doc(model.finishedID)
              .set({
            'date': model.date,
            'batchId': model.batchId,
            'color': {
              'color': model.color.color,
              'quantity': model.color.quantity,
              'colorCode': model.color.colorCode,
            },
            'damage': model.damage,
            'finishedQuantity': model.finishedQuantity,
            'quantity': model.quantity,
            'finishedID': model.finishedID,
            'finisherAssignID': model.finisherAssignID,
            'employID': {
              'name': model.employID.name,
              'email': model.employID.email,
              'type': model.employID.type.toString().split('.').last,
              'status': model.employID.status.toString().split('.').last,
              'password': model.employID.password,
              'empID': model.employID.empID
            },
            'productID': {
              'date': model.productID.date,
              'batchId': model.productID.batchId,
              'quantity': model.productID.quantity,
              'employID': {
                'name': model.productID.employID.name,
                'email': model.productID.employID.email,
                'type':
                    model.productID.employID.type.toString().split('.').last,
                'status':
                    model.productID.employID.status.toString().split('.').last,
                'password': model.productID.employID.password,
                'empID': model.productID.employID.empID
              },
              'productID': {
                'id': model.productID.productID.id,
                'proAssignID': model.productID.productID.proAssignID,
                'balance': model.productID.productID.balance,
                'damage': model.productID.productID.damage,
                'wastage': model.productID.productID.wastage,
                'date': model.productID.productID.date,
                'batchID': model.productID.productID.batchID,
                'layerCount': model.productID.productID.layerCount,
                'meterLayer': model.productID.productID.meterLayer,
                'pieceLayer': model.productID.productID.pieceLayer,
                'usedFabrics': model.productID.productID.usedFabrics,
                'materialId': {
                  'name': model.productID.productID.materialId.name,
                  'hsn': model.productID.productID.materialId.hsn,
                  'itemCode': model.productID.productID.materialId.itemCode,
                  'quantity': model.productID.productID.materialId.quantity,
                },
                'employId': {
                  'empID': model.productID.productID.employId.empID,
                  'name': model.productID.productID.employId.name,
                  'email': model.productID.productID.employId.email,
                  'type': model.productID.productID.employId.type
                      .toString()
                      .split('.')
                      .last,
                  'status': model.productID.productID.employId.status
                      .toString()
                      .split('.')
                      .last,
                  'password': model.productID.productID.employId.password,
                },
                'quantity': model.productID.productID.quantity.map((item) {
                  return {
                    'color': item.color,
                    'quantity': item.quantity,
                    'colorCode': item.colorCode,
                  };
                }).toList(),
                'productId': {
                  'itemCode': model.productID.productID.productId.itemCode,
                  'name': model.productID.productID.productId.name,
                },
              },
              'color': {
                'color': model.productID.color.color,
                'quantity': model.productID.color.quantity,
                'colorCode': model.productID.color.colorCode,
              },
              'assignedQuantity': model.productID.assignedQuantity,
              'damage': model.productID.damage,
              'tailerAssignID': model.productID.tailerAssignID,
              'tailerFinishID': model.productID.tailerFinishID
            },
          });

          if (context.mounted) {
            showSnackBar(context,
                ' Finished by ${model.employID.name} - ${model.productID.productID.productId.name}');
          }

          Navigator.pop(context);
        } else {
          showSnackBar(context, 'Insufficient quantity');
          return;
        }
      } else {
        showSnackBar(context, 'document not found');
        return;
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      showSnackBar(context, error.message ?? 'Authentication Failed');
    }
  }

  //DELETE function
  static Future<bool> deleteDocument(
      String collectionPath, String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionPath)
          .doc(documentId)
          .delete();
      print('$documentId successfully deleted from $collectionPath.');
      return true;
    } catch (error) {
      print('Error deleting document: $error');
      return false;
    }
  }

  //UPDATE Status function
  static Future<bool> updateEmployeeStatus(
      String collectionPath, String documentId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionPath)
          .doc(documentId)
          .update({'status': newStatus});

      return true;
    } catch (error) {
      return false;
    }
  }
}
