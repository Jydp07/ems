import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/models/working_model.dart';
import 'package:ems/repository/database_repository.dart';
import 'package:ems/views/common/my_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ems/models/service_model.dart';
import 'package:equatable/equatable.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  ServiceBloc()
      : super(const ServiceState(
            leaveData: [],
            isLoading: false,
            error: "",
            isRequestAdd: false,
            salaryData: [],
            isRequestDeleted: false)) {
    on<AddLeave>(_addLeaveRequest);
    on<GetLeavesData>(_getLeaveData);
    on<DeleteData>(_deleteData);
    on<GetAllSalary>(_getSalaryData);
  }

  final _dbRepo = DatabaseRepository();

  _addLeaveRequest(AddLeave event, Emitter<ServiceState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final serviceModel = ServiceModel();
      await _dbRepo
          .addLeaveRequest(
            serviceModel.copyWith(
              userId: uid,
              description: event.description,
              startDate: event.startDate,
              endDate: event.endDate,
              isApprove: event.isApprove,
              requestAt: Timestamp.fromDate(
                event.requestAt ?? DateTime.now(),
              ),
            ),
          )
          .whenComplete(
            () => emit(
              state.copyWith(isRequestAdd: true),
            ),
          );
      add(GetLeavesData());
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    } finally {
      emit(state.copyWith(isRequestAdd: false, isLoading: false));
    }
  }

  _getLeaveData(GetLeavesData event, Emitter<ServiceState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final leaveData = await _dbRepo.getLeavesData();
      final List<ServiceModel> leaveList = [];
      final uid = FirebaseAuth.instance.currentUser?.uid;
      for (var leave in leaveData) {
        if (leave.userId == uid) {
          leaveList.add(leave);
        }
      }
      emit(
        state.copyWith(leaveData: leaveList),
      );
    } catch (ex) {
      emit(
        state.copyWith(
          error: ex.toString(),
        ),
      );
    } finally {
      emit(
        state.copyWith(isRequestAdd: false, isLoading: false, error: ""),
      );
    }
  }

  _deleteData(DeleteData event, Emitter<ServiceState> emit) async {
    try {
      final serviceModel = ServiceModel();
      await _dbRepo.deleteLeaveData(
        serviceModel.copyWith(uid: event.uid),
      );
      // final uid = FirebaseAuth.instance.currentUser?.uid;
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(event.context).showSnackBar(
        SnackBar(
          content: const MyText("Request Deleted"),
          action: SnackBarAction(
              label: "UNDO",
              onPressed: () async {
                add(
                  AddLeave(
                    description: event.serviceModel.description!,
                    startDate: event.serviceModel.startDate!,
                    endDate: event.serviceModel.endDate!,
                    isApprove: event.serviceModel.isApprove,
                    requestAt: event.serviceModel.requestAt!.toDate(),
                  ),
                );
              }),
        ),
      );
      emit(state.copyWith(isRequestDeleted: true));
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    } finally {
      emit(
          state.copyWith(isRequestDeleted: false, isLoading: false, error: ""));
    }
  }

  _getSalaryData(GetAllSalary event, Emitter<ServiceState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final workingModel = WorkingModel();
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final salarydata =
          await _dbRepo.getAllSalaryData(workingModel.copyWith(userId: uid));
      emit(state.copyWith(salaryData: salarydata));
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    } finally {
      emit(state.copyWith(isRequestAdd: false, isLoading: false, error: ""));
    }
  }
}
