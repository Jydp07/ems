import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  final String? uid;
  final String? description;
  final String? startDate;
  final String? endDate;
  final bool? isApprove;
  final Timestamp? requestAt;
  final String? userId;

  ServiceModel(
      {this.uid,
      this.description,
      this.startDate,
      this.endDate,
      this.requestAt,
      this.userId,
      this.isApprove});

  ServiceModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>?> doc)
      : uid = doc.id,
        description = doc.data()?["description"],
        startDate = doc.data()?["startDate"],
        endDate = doc.data()?["endDate"],
        requestAt = doc.data()?["requestAt"],
        userId = doc.data()?["userId"],
        isApprove = doc.data()?["isApprove"];

  Map<String, dynamic> toMap() {
    return {
      "description": description,
      "startDate": startDate,
      "endDate": endDate,
      "isApprove": isApprove,
      "userId" : userId,
      "requestAt" : requestAt
    };
  }

  ServiceModel copyWith(
      {String? description,
      String? startDate,
      String? endDate,
      String? userId,
      String? uid,
      Timestamp? requestAt,
      bool? isApprove}) {
    return ServiceModel(
        description: description ?? this.description,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        uid: uid ?? this.uid,
        requestAt: requestAt ?? this.requestAt,
        userId: userId ?? this.userId,
        isApprove: isApprove ?? this.isApprove);
  }
}
