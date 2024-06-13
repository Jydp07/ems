import 'package:ems/models/service_model.dart';
import 'package:ems/models/working_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ems/models/user_model.dart';
import 'package:ems/repository/database_repository.dart';
import 'package:equatable/equatable.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  AdminBloc()
      : super(AdminState(
            userModel: UserModel(),
            error: '',
            isLoading: false,
            allCheckInData: const [],
            allCheckOutData: const [],
            allDurationsData: const [],
            leaveData: const [],
            salaryData: const [],
            allDates: const [])) {
    on<GetUserByUid>(_getUserByUid);
    on<GetCheckInOutDataAdmin>(_getCheckInOutData);
    on<GetAllSalaryAdmin>(_getSalaryData);
    on<GetAllDurationsAdmin>(_getAllDuration);
    on<GetLeavesDataAdmin>(_getLeaveData);
    on<AcceptDeniedLeaves>(_acceptDeniedLeaves);
    on<UpdateSalaryAndPosition>(_updateSalaryAndposition);
  }
  final _dbRepo = DatabaseRepository();
  _getUserByUid(GetUserByUid event, Emitter<AdminState> emit) async {
    emit(state.copyWith(
      isLoading: true,
    ));
    try {
      final userModel = UserModel();
      final userData =
          await _dbRepo.getUserData(userModel.copyWith(uid: event.uid));
      emit(state.copyWith(userModel: userData));
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    } finally {
      emit(state.copyWith(isLoading: false, error: ""));
    }
  }

  _getCheckInOutData(
      GetCheckInOutDataAdmin event, Emitter<AdminState> emit) async {
    emit(state.copyWith(isLoading: true, error: ""));
    try {
      final workingmodel = WorkingModel();
      final allCheckInData =
          await _dbRepo.getUserAllCheckInData(workingmodel.copyWith(
        userId: event.uid,
      ));

      final allCheckOutData =
          await _dbRepo.getUserAllCheckOutData(workingmodel.copyWith(
        userId: event.uid,
      ));
      emit(state.copyWith(
          allCheckInData: allCheckInData, allCheckOutData: allCheckOutData));
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    } finally {
      emit(state.copyWith(isLoading: false, error: ""));
    }
  }

  _getSalaryData(GetAllSalaryAdmin event, Emitter<AdminState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final workingModel = WorkingModel();
      final salarydata = await _dbRepo
          .getAllSalaryData(workingModel.copyWith(userId: event.uid));
      emit(state.copyWith(salaryData: salarydata));
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    } finally {
      emit(state.copyWith(isLoading: false, error: ""));
    }
  }

  _getAllDuration(GetAllDurationsAdmin event, Emitter<AdminState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final workingModel = WorkingModel();
      final allDurations = await _dbRepo.getAllDuration(
        workingModel.copyWith(userId: event.uid, month: event.month),
      );
      final List<String> data = [];
      for (var dates in allDurations) {
        data.add(dates.uid!.substring(0, 2));
      }
      final userModel = UserModel();
      final allSalary =
          await _dbRepo.getUserData(userModel.copyWith(uid: event.uid));
      emit(
        state.copyWith(
          allDurationsData: allDurations,
          userModel: allSalary,
          allDates: data,
        ),
      );
    } catch (ex) {
      emit(
        state.copyWith(
          error: ex.toString(),
        ),
      );
    } finally {
      emit(
        state.copyWith(
          error: "",
          isLoading: false,
        ),
      );
    }
  }

  _getLeaveData(GetLeavesDataAdmin event, Emitter<AdminState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final leaveData = await _dbRepo.getLeavesData();
      final List<ServiceModel> leaveList = [];
      for (var leave in leaveData) {
        if (leave.userId == event.uid) {
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
        state.copyWith(isLoading: false, error: ""),
      );
    }
  }

  _acceptDeniedLeaves(
      AcceptDeniedLeaves event, Emitter<AdminState> emit) async {
    try {
      final serviceModel = ServiceModel();
      await _dbRepo.changeLeaveStatus(
          serviceModel.copyWith(isApprove: event.isAccept, uid: event.uid));
      add(GetLeavesDataAdmin(uid: event.userId));
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    }
  }

  _updateSalaryAndposition(
      UpdateSalaryAndPosition event, Emitter<AdminState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final userModel = UserModel();
      await _dbRepo.updateSalaryAndPosition(userModel.copyWith(
          uid: event.uid, position: event.position, salary: event.salary));
      add(GetUserByUid(uid: event.uid));
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
