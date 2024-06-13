import 'dart:io';

import 'package:ems/models/service_model.dart';
import 'package:ems/models/user_model.dart';
import 'package:ems/models/working_model.dart';
import 'package:ems/utils/services/database_services.dart';

class DatabaseRepository {
  final _databaseServices = DatabaseServices();

  addUserData(UserModel userModel) async {
    await _databaseServices.addUserData(userModel);
  }

  Future<List<UserModel>> getAllUsers() async {
    return await _databaseServices.getAllUsers();
  }

  Future<UserModel> getUserData(UserModel userModel) async {
    return await _databaseServices.getUserData(userModel);
  }

  Future<void> updateUserData(UserModel userModel) async {
    return await _databaseServices.updateUserData(userModel);
  }

  checkIn(WorkingModel workingModel) async {
    await _databaseServices.userCheckIn(workingModel);
  }

  checkInUpdate(WorkingModel workingModel) async {
    await _databaseServices.userCheckInUpdate(workingModel);
  }

  checkOut(WorkingModel workingModel) async {
    await _databaseServices.userCheckOut(workingModel);
  }

  Future<WorkingModel> getCheckInData(WorkingModel workingModel) async {
    return await _databaseServices.getCheckInData(workingModel);
  }

  Future<WorkingModel> getCheckOutData(WorkingModel workingModel) async {
    return await _databaseServices.getCheckOutData(workingModel);
  }

  Future<List<WorkingModel>> getUserAllCheckInData(
      WorkingModel workingModel) async {
    return await _databaseServices.getAllCheckInData(workingModel);
  }

  Future<List<WorkingModel>> getUserAllCheckOutData(
      WorkingModel workingModel) async {
    return await _databaseServices.getAllCheckOutData(workingModel);
  }

  addDuration(WorkingModel workingModel) async {
    await _databaseServices.addDuration(workingModel);
  }

  Future<WorkingModel> getDuration(WorkingModel workingModel) async {
    return await _databaseServices.getDuration(workingModel);
  }

  Future<List<WorkingModel>> getAllDuration(WorkingModel workingModel) async {
    return await _databaseServices.getAllDuration(workingModel);
  }

  addSalary(WorkingModel workingModel) async {
    await _databaseServices.addSalary(workingModel);
  }

  Future<WorkingModel> getSalary(WorkingModel workingModel) async {
    return await _databaseServices.getSalary(workingModel);
  }

  addLeaveRequest(ServiceModel serviceModel) async {
    await _databaseServices.addLeaveRequest(serviceModel);
  }

  Future<List<ServiceModel>> getLeavesData() async {
    return await _databaseServices.getLeavesData();
  }

  Future<void> deleteLeaveData(ServiceModel serviceModel) async {
    await _databaseServices.deleteLeaveData(serviceModel);
  }

  Future<List<WorkingModel>> getAllSalaryData(WorkingModel workingModel) async {
    return await _databaseServices.getAllSalaryData(workingModel);
  }

  uploadImageAndUpdate(File image, UserModel userModel) async {
    return await _databaseServices.uploadImageAndUpdate(image, userModel);
  }

  changeLeaveStatus(ServiceModel serviceModel) async {
    return await _databaseServices.changeLeaveStatus(serviceModel);
  }

  updateSalaryAndPosition(UserModel userModel) async {
    return await _databaseServices.updateSalaryAndPosition(userModel);
  }
}
