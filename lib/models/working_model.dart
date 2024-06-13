import 'package:cloud_firestore/cloud_firestore.dart';

class WorkingModel {
  final String? uid;
  final String? userId;
  final List<dynamic>? checkInTime;
  final List<dynamic>? checkOutTime;
  final Duration? todayWorkingHours;
  final double? salary;
  final int? seconds;
  final int? month;
  final Timestamp? dateTime;
  final int? allSeconds;
  final bool? isCheckedIn;
  final String? status;
  WorkingModel(
      {this.uid,
      this.checkInTime,
      this.checkOutTime,
      this.todayWorkingHours,
      this.userId,
      this.seconds,
      this.dateTime,
      this.month,
      this.allSeconds,
      this.status,
      this.isCheckedIn,
      this.salary});

  WorkingModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>?> doc)
      : uid = doc.id,
        checkInTime = doc.data()?["checkInTime"],
        checkOutTime = doc.data()?["checkOutTime"],
        userId = doc.data()?["userId"],
        status = doc.data()?["status"],
        dateTime = doc.data()?["dateTime"],
        seconds = doc.data()?["seconds"],
        month = doc.data()?["month"],
        allSeconds = doc.data()?["allSeconds"],
        todayWorkingHours = doc.data()?["todayWorkingHours"],
        isCheckedIn = doc.data()?["isCheckedIn"],
        salary = doc.data()?["salary"];

  Map toMap() {
    return {
      "checkInTime": checkInTime,
      "checkOutTime": checkOutTime,
      "todayWorkingHours": todayWorkingHours,
      "isCheckedIn": isCheckedIn,
      "allSeconds" : allSeconds,
      "userId": userId,
      "status": status,
      "seconds": seconds,
      "month":month,
      "dateTime" : dateTime,
      "salary": salary
    };
  }

  WorkingModel copyWith(
      {String? uid,
      List<dynamic>? checkInTime,
      List<dynamic>? checkOutTime,
      Duration? todayWorkingHours,
      bool? isCheckedIn,
      String? userId,
      int? month,
      String? status,
      Timestamp? dateTime,
      int? allSeconds,
      int? seconds,
      double? salary}) {
    return WorkingModel(
        uid: uid ?? this.uid,
        checkInTime: checkInTime ?? this.checkInTime,
        checkOutTime: checkOutTime ?? this.checkOutTime,
        userId: userId ?? this.userId,
        status: status ?? this.status,
        month: month ?? this.month,
        dateTime: dateTime ?? this.dateTime,
        seconds: seconds ?? this.seconds,
        allSeconds: allSeconds ?? this.allSeconds,
        todayWorkingHours: todayWorkingHours ?? this.todayWorkingHours,
        isCheckedIn: isCheckedIn ?? this.isCheckedIn,
        salary: salary ?? this.salary);
  }
}
