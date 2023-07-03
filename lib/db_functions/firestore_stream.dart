import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hmanage/db_functions/collections.dart';
import 'package:hmanage/models/cutter_assigned_model.dart';
import 'package:hmanage/models/cutter_finishing_model.dart';
import 'package:hmanage/models/employee_model.dart';
import 'package:hmanage/models/finish_model.dart';
import 'package:hmanage/models/finisher_assign_model.dart';
import 'package:hmanage/models/item_add_model.dart';
import 'package:hmanage/models/stock_model.dart';
import 'package:hmanage/models/supplier_model.dart';
import 'package:hmanage/models/tailer_assign_model.dart';
import 'package:hmanage/models/tailer_finishing_model.dart';

class FirestoreStreams {
  //USER Stream
  Stream<List<EmployeeModel>> getUsersStream() {
    try {
      final usersRef = FirebaseFirestore.instance
          .collection(employeeCollection)
          .withConverter<EmployeeModel>(
            fromFirestore: (snapshot, _) =>
                EmployeeModel.fromJson(snapshot.data()!),
            toFirestore: (users, _) => users.toJson(),
          );

      return usersRef.snapshots().map((querySnapshot) {
        return querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      return Stream.error('Failed to load users. Please try again.');
    }
  }

  //STOCK Stream
  Stream<List<StockModel>> getStockStream() {
    try {
      final stockRef = FirebaseFirestore.instance
          .collection(stockCollections)
          .withConverter<StockModel>(
            fromFirestore: (snapshot, _) =>
                StockModel.fromJson(snapshot.data()!),
            toFirestore: (users, _) => users.toJson(),
          );

      return stockRef.snapshots().map((querySnapshot) {
        return querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      return Stream.error('Failed to load users. Please try again.');
    }
  }

  //SUPPLIER Stream

  Stream<List<SupplierModel>> getSuppliersStream() {
    try {
      final supplierRef = FirebaseFirestore.instance
          .collection(supplierCollection)
          .withConverter<SupplierModel>(
              fromFirestore: (snapshot, _) =>
                  SupplierModel.fromJson(snapshot.data()!),
              toFirestore: (suppliers, _) => suppliers.toJson());

      return supplierRef.snapshots().map((querySnapshot) {
        return querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      return Stream.error('Failed to load Suppliers. Please try again.');
    }
  }

  //PRODUCT Stream
  Stream<List<ProductAddModel>> getProductStream() {
    try {
      final proRef = FirebaseFirestore.instance
          .collection(productCollection)
          .withConverter<ProductAddModel>(
            fromFirestore: (snapshot, _) =>
                ProductAddModel.fromJson(snapshot.data()!),
            toFirestore: (users, _) => users.toJson(),
          );

      return proRef.snapshots().map((querySnapshot) {
        return querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      return Stream.error('Failed to load users. Please try again.');
    }
  }

  Stream<List<TailerFinishingModel>> getTailerFinishStream(String userId) {
    try {
      final itemRef = FirebaseFirestore.instance
          .collection(tailerFinishCollection)
          .where('employID.empID', isEqualTo: userId)
          .withConverter<TailerFinishingModel>(
            fromFirestore: (snapshot, _) =>
                TailerFinishingModel.fromJson(snapshot.data()!),
            toFirestore: (users, _) => users.toJson(),
          );

      return itemRef.snapshots().map((querySnapshot) {
        return querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      return Stream.error('Failed to load users. Please try again.');
    }
  }

  Stream<List<FinishModel>> getFinisherFinishStream(String userId) {
    try {
      final itemRef = FirebaseFirestore.instance
          .collection(finishCollection)
          .where('employID.empID', isEqualTo: userId)
          .withConverter<FinishModel>(
            fromFirestore: (snapshot, _) =>
                FinishModel.fromJson(snapshot.data()!),
            toFirestore: (users, _) => users.toJson(),
          );

      return itemRef.snapshots().map((querySnapshot) {
        return querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      return Stream.error('Failed to load users. Please try again.');
    }
  }

  Stream<List<CutterFinishingModel>> getCutterFinishStream(String userId) {
    try {
      final itemRef = FirebaseFirestore.instance
          .collection(cutterFinishCollection)
          .where('employId.empID', isEqualTo: userId)
          .withConverter<CutterFinishingModel>(
            fromFirestore: (snapshot, _) =>
                CutterFinishingModel.fromJson(snapshot.data()!),
            toFirestore: (users, _) => users.toJson(),
          );

      return itemRef.snapshots().map((querySnapshot) {
        return querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      return Stream.error('Failed to load users. Please try again.');
    }
  }

  //CUTTER Assignments Stream
  Stream<List<CutterAssignModel>> getCutterAssignmentStream(String userId) {
    try {
      final itemRef = FirebaseFirestore.instance
          .collection(cutterAssignCollection)
          .where('employID.empID', isEqualTo: userId)
          .withConverter<CutterAssignModel>(
            fromFirestore: (snapshot, _) =>
                CutterAssignModel.fromJson(snapshot.data()!),
            toFirestore: (users, _) => users.toJson(),
          );

      return itemRef.snapshots().map((querySnapshot) {
        return querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      return Stream.error('Failed to load users. Please try again.');
    }
  }

  //TAILER Assignments Stream
  Stream<List<TailerAssignModel>> getTailerAssignmentStream(String userId) {
    try {
      final itemRef = FirebaseFirestore.instance
          .collection(tailerAssignCollection)
          .where('employId.empID', isEqualTo: userId)
          .withConverter<TailerAssignModel>(
            fromFirestore: (snapshot, _) =>
                TailerAssignModel.fromJson(snapshot.data()!),
            toFirestore: (users, _) => users.toJson(),
          );

      return itemRef.snapshots().map((querySnapshot) {
        return querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      return Stream.error('Failed to load users. Please try again.');
    }
  }

  //FINISHER Assignments Stream
  Stream<List<FinisherAssignModel>> getFinisherAssignmentStream(String userId) {
    try {
      final itemRef = FirebaseFirestore.instance
          .collection(finisherAssignCollection)
          .where('employID.empID', isEqualTo: userId)
          .withConverter<FinisherAssignModel>(
            fromFirestore: (snapshot, _) =>
                FinisherAssignModel.fromJson(snapshot.data()!),
            toFirestore: (users, _) => users.toJson(),
          );

      return itemRef.snapshots().map((querySnapshot) {
        return querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      return Stream.error('Failed to load users. Please try again.');
    }
  }
}
