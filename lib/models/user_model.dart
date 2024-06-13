import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? uid;
  final String? username;
  final String? email;
  final String? password;
  final String? phone;
  final Timestamp? dob;
  final String? image;
  final dynamic salary;
  final String? gender;
  final String? position;
  final Timestamp? doj;

  UserModel(
      {this.uid,
      this.username,
      this.email,
      this.password,
      this.phone,
      this.dob,
      this.position,
      this.image,
      this.salary,
      this.gender,
      this.doj});

  UserModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : uid = doc.id,
        username = doc.data()?["username"],
        email = doc.data()?["email"],
        password = doc.data()?["password"],
        phone = doc.data()?["phone"],
        dob = doc.data()?["dob"],
        image = doc.data()?["image"],
        position = doc.data()?["position"],
        salary = doc.data()?["salary"],
        gender = doc.data()?["gender"],
        doj = doc.data()?["doj"];

  Map<String, dynamic> toMap() {
    return {
      "username": username,
      "email": email,
      "password": password,
      "phone": phone,
      "dob": dob,
      "gender": gender,
      "image": image,
      "salary": salary,
      "position": position,
      "doj": doj
    };
  }

  UserModel copyWith(
      {String? uid,
      String? username,
      String? email,
      String? password,
      String? phone,
      Timestamp? dob,
      String? gender,
      String? image,
      String? position,
      dynamic salary,
      Timestamp? doj}) {
    return UserModel(
        uid: uid ?? this.uid,
        username: username ?? this.username,
        email: email ?? this.email,
        password: password ?? this.password,
        phone: phone ?? this.phone,
        dob: dob ?? this.dob,
        position: position ?? this.position,
        image: image ?? this.image,
        salary: salary ?? this.salary,
        gender: gender ?? this.gender,
        doj: doj ?? this.doj);
  }
}
