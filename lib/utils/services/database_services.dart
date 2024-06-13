import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/models/service_model.dart';
import 'package:ems/models/user_model.dart';
import 'package:ems/models/working_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class DatabaseServices {
  final _db = FirebaseFirestore.instance;
  final dateTime = DateFormat("dd MMM yyyy").format(DateTime.now());
  
  addUserData(UserModel userModel) async {
    await _db.collection("Users").doc(userModel.uid).set(userModel.toMap());
  }

  Future<UserModel> getUserData(UserModel userModel) async {
    final snapshot = await _db.collection("Users").doc(userModel.uid).get();
    return UserModel.fromDocumentSnapshot(snapshot);
  }

  Future<List<UserModel>> getAllUsers() async {
    final snapshot = await _db.collection("Users").get();
    return snapshot.docs.map((e) => UserModel.fromDocumentSnapshot(e)).toList();
  }

  Future<void> updateUserData(UserModel userModel) async {
    await _db.collection("Users").doc(userModel.uid).update({
      "username": userModel.username,
      "phone": userModel.phone,
      "dob": userModel.dob
    });
  }

  uploadImageAndUpdate(File image, UserModel userModel) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child("User_Image")
        .child(userModel.uid!);

    await storageRef.putFile(image);

    final imageUrl = await storageRef.getDownloadURL();

    _db.collection("Users").doc(userModel.uid).update({"image": imageUrl});
  }

  //Salary
  userCheckIn(WorkingModel workingModel) async {
    await _db
        .collection("checkIncheckOut")
        .doc(workingModel.userId)
        .collection("checkIn")
        .doc(dateTime)
        .set({
      "checkInTime": workingModel.checkInTime,
      "isCheckedIn": workingModel.isCheckedIn,
      "status": "Check In"
    });
  }

  userCheckInUpdate(WorkingModel workingModel) async {
    await _db
        .collection("checkIncheckOut")
        .doc(workingModel.userId)
        .collection("checkIn")
        .doc(dateTime)
        .update({
      "isCheckedIn": workingModel.isCheckedIn,
    });
  }

  userCheckOut(WorkingModel workingModel) async {
    await _db
        .collection("checkIncheckOut")
        .doc(workingModel.userId)
        .collection("checkOut")
        .doc(dateTime)
        .set(
            {"checkOutTime": workingModel.checkOutTime, "status": "Check Out"});
  }

  Future<WorkingModel> getCheckInData(WorkingModel workingModel) async {
    final snapshot = await _db
        .collection("checkIncheckOut")
        .doc(workingModel.userId)
        .collection("checkIn")
        .doc(dateTime)
        .get();
    return WorkingModel.fromDocumentSnapshot(snapshot);
  }

  Future<WorkingModel> getCheckOutData(WorkingModel workingModel) async {
    final snapshot = await _db
        .collection("checkIncheckOut")
        .doc(workingModel.userId)
        .collection("checkOut")
        .doc(dateTime)
        .get();
    return WorkingModel.fromDocumentSnapshot(snapshot);
  }

  Future<List<WorkingModel>> getAllCheckInData(
      WorkingModel workingModel) async {
    final snapshot = await _db
        .collection("checkIncheckOut")
        .doc(workingModel.userId)
        .collection("checkIn")
        .orderBy("checkInTime", descending: true)
        .get();
    return snapshot.docs
        .map((e) => WorkingModel.fromDocumentSnapshot(e))
        .toList();
  }

  Future<List<WorkingModel>> getAllCheckOutData(
      WorkingModel workingModel) async {
    final snapshot = await _db
        .collection("checkIncheckOut")
        .doc(workingModel.userId)
        .collection("checkOut")
        .orderBy("checkOutTime", descending: true)
        .get();
    return snapshot.docs
        .map((e) => WorkingModel.fromDocumentSnapshot(e))
        .toList();
  }

  Future<void> addDuration(WorkingModel workingModel) async {
    await _db
        .collection("durations")
        .doc(workingModel.userId)
        .collection("duration")
        .doc(dateTime)
        .set({"seconds": workingModel.seconds, "month": DateTime.now().month});
  }

  Future<WorkingModel> getDuration(WorkingModel workingModel) async {
    final snapshot = await _db
        .collection("durations")
        .doc(workingModel.userId)
        .collection("duration")
        .doc(dateTime)
        .get();

    return WorkingModel.fromDocumentSnapshot(snapshot);
  }

  Future<List<WorkingModel>> getAllDuration(WorkingModel workingModel) async {
    final snapshot = await _db
        .collection("durations")
        .doc(workingModel.userId)
        .collection("duration")
        .where(
          "month",
          isEqualTo: workingModel.month ?? DateTime.now().month,
        )
        .get();

    return snapshot.docs
        .map((e) => WorkingModel.fromDocumentSnapshot(e))
        .toList();
  }

  Future<void> addSalary(WorkingModel workingModel) async {
    await _db
        .collection("salary")
        .doc(workingModel.userId)
        .collection("salary")
        .doc(DateFormat("MMM yyyy").format(DateTime.now()))
        .set({"salary": workingModel.salary, "dateTime": DateTime.now()});
  }

  Future<WorkingModel> getSalary(WorkingModel workingModel) async {
    final snapshot = await _db
        .collection("salary")
        .doc(workingModel.userId)
        .collection("salary")
        .doc(DateFormat("MMM yyyy").format(DateTime.now()))
        .get();
    return WorkingModel.fromDocumentSnapshot(snapshot);
  }

  //Services

  addLeaveRequest(ServiceModel serviceModel) async {
    await _db.collection("leave_requests").doc().set(serviceModel.toMap());
  }

  Future<List<ServiceModel>> getLeavesData() async {
    final snapshot = await _db
        .collection("leave_requests")
        .orderBy("requestAt", descending: true)
        .get();
    return snapshot.docs
        .map((e) => ServiceModel.fromDocumentSnapshot(e))
        .toList();
  }

  Future<void> deleteLeaveData(ServiceModel serviceModel) async {
    await _db.collection("leave_requests").doc(serviceModel.uid).delete();
  }

  changeLeaveStatus(ServiceModel serviceModel) async {
    await _db
        .collection("leave_requests")
        .doc(serviceModel.uid)
        .update({"isApprove": serviceModel.isApprove});
  }

  Future<List<WorkingModel>> getAllSalaryData(WorkingModel workingModel) async {
    final snapshot = await _db
        .collection("salary")
        .doc(workingModel.userId)
        .collection("salary")
        .orderBy("dateTime", descending: true)
        .get();

    return snapshot.docs
        .map((e) => WorkingModel.fromDocumentSnapshot(e))
        .toList();
  }

  updateSalaryAndPosition(UserModel userModel) async {
    await _db.collection("Users").doc(userModel.uid).update({
      "position" : userModel.position,
      "salary" : userModel.salary
    });
  }
}
