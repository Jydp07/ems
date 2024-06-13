import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/models/user_model.dart';
import 'package:ems/models/working_model.dart';
import 'package:ems/repository/database_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

part 'worktime_event.dart';
part 'worktime_state.dart';

class WorktimeBloc extends Bloc<WorktimeEvent, WorktimeState> {
  WorktimeBloc()
      : super(
          WorktimeState(
            workingHours: const Duration(),
            salary: 0,
            timeOfDay: DateTime.now(),
            isLoading: false,
            error: "",
            workingModel: WorkingModel(),
            checkOutModel: WorkingModel(),
            allCheckInData: const [],
            isWithinAllowedLocation: false,
            allSeconds: const Duration(),
            allCheckOutData: const [],
            allDurationsData: const [],
            userModel: UserModel(),
            allDates: const [],
            allSalary: 0,
          ),
        ) {
    on<CurrentWorkingHours>(_currentWorkingHours);
    on<ChangeTime>(_changeTime);
    on(_countSalary);
    on<CheckIn>(_checkIn);
    on<CheckInOutData>(_checkInOutData);
    on<CheckOut>(_checkOut);
    on<GetCheckInOutData>(_getCheckInOutData);
    on<GetLocation>(_allowCheckInOut);
    on<GetAllDurations>(_getAllDuration);
    on<TimerCancel>(_cancelTimer);
  }
  final _dbRepo = DatabaseRepository();

  Timer? _timer;

  _currentWorkingHours(
      CurrentWorkingHours event, Emitter<WorktimeState> emit) async {
    try {
      final workingModel = WorkingModel();
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final checkInData = await _dbRepo.getCheckInData(workingModel.copyWith(
        userId: uid,
      ));

      final userModel = UserModel();
      final userSalary =
          await _dbRepo.getUserData(userModel.copyWith(uid: uid));

      final workingHours =
          await _dbRepo.getDuration(workingModel.copyWith(userId: uid));

      final salaryData =
          await _dbRepo.getSalary(workingModel.copyWith(userId: uid));

      final allSeconds =
          await _dbRepo.getAllDuration(workingModel.copyWith(userId: uid));
      int secondData = 0;

      for (var element in allSeconds) {
        secondData += element.seconds ?? 0;
      }

      //emit(state.copyWith(allSeconds: Duration(seconds: secondData)));
      emit(state.copyWith(workingModel: checkInData));
      if (checkInData.isCheckedIn != null) {
        _timer = Timer.periodic(
          const Duration(seconds: 1),
          (timer) {
            if (checkInData.isCheckedIn == null) {
              timer.cancel();
            }
            add(
              ChangeTime(
                time: checkInData.checkInTime != null
                    ? Duration(seconds: workingHours.seconds ?? 0) +
                        DateTime.now().difference(
                          checkInData.checkInTime?.first.toDate(),
                        )
                    : Duration(seconds: workingHours.seconds ?? 0),
                timeOfDay: DateTime.now(),
                allTime: checkInData.checkInTime != null
                    ? Duration(seconds: secondData) +
                        DateTime.now().difference(
                          checkInData.checkInTime?.first.toDate(),
                        )
                    : Duration(seconds: secondData),
              ),
            );
            final hours = state.allSeconds.inHours;
            final minutes = state.allSeconds.inMinutes.remainder(60);
            final seconds = state.allSeconds.inSeconds.remainder(60);
            const totalWorkingTime = 234;
            final totalSalary = userSalary.salary ?? 0;
            final hourlyRate = (totalSalary / totalWorkingTime);
            final totalHours = hours + minutes / 60 + seconds / 3600;
            final salary = totalHours * hourlyRate;

            final dayDuration = Duration(seconds: workingHours.seconds ?? 0) +
                DateTime.now().difference(
                  checkInData.checkInTime?.first.toDate(),
                );

            final dayHours = dayDuration.inHours;
            final dayMinutes = dayDuration.inMinutes.remainder(60);
            final daySeconds = dayDuration.inSeconds.remainder(60);
            final dayTotalHours =
                dayHours + dayMinutes / 60 + daySeconds / 3600;
            final daySalary = dayTotalHours * hourlyRate;
            add(
              CountSalary(
                salary: salary,
                allSalary: daySalary,
              ),
            );
          },
        );
      } else {
        if (checkInData.isCheckedIn == null) {
          _timer?.cancel();
        }
        _timer = Timer.periodic(
          const Duration(seconds: 1),
          (timer) {
            add(
              ChangeTime(
                timeOfDay: DateTime.now(),
              ),
            );
          },
        );
        add(
          ChangeTime(
            timeOfDay: DateTime.now(),
            time: Duration(seconds: workingHours.seconds ?? 0),
            allTime: Duration(seconds: secondData),
          ),
        );
        
        final dayDuration = Duration(seconds: workingHours.seconds ?? 0);
        final dayHours = dayDuration.inHours;
        final dayMinutes = dayDuration.inMinutes.remainder(60);
        final daySeconds = dayDuration.inSeconds.remainder(60);
        const totalWorkingTime = 234;
        final totalSalary = userSalary.salary ?? 0;
        final hourlyRate = (totalSalary / totalWorkingTime);
        final dayTotalHours = dayHours + dayMinutes / 60 + daySeconds / 3600;
        final daySalary = dayTotalHours * hourlyRate;
        add(
          CountSalary(
            salary: salaryData.salary ?? 0,
            allSalary: daySalary,
          ),
        );
      }
    } catch (ex) {
      emit(
        state.copyWith(
          error: ex.toString(),
        ),
      );
    } finally {
      emit(state.copyWith(error: ""));
    }
  }

  _cancelTimer(TimerCancel event, Emitter<WorktimeState> emit) {
    _timer?.cancel();
  }

  _getCheckInOutData(
      GetCheckInOutData event, Emitter<WorktimeState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final workingmodel = WorkingModel();
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final allCheckInData =
          await _dbRepo.getUserAllCheckInData(workingmodel.copyWith(
        userId: uid,
      ));

      final allCheckOutData =
          await _dbRepo.getUserAllCheckOutData(workingmodel.copyWith(
        userId: uid,
      ));
      emit(state.copyWith(
          allCheckInData: allCheckInData, allCheckOutData: allCheckOutData));
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    } finally {
      emit(state.copyWith(isLoading: false, error: ""));
    }
  }

  _checkIn(CheckIn event, Emitter<WorktimeState> emit) async {
    add(GetLocation());
    if (state.isWithinAllowedLocation) {
      emit(state.copyWith(isLoading: true));
      try {
        final workingModel = WorkingModel();
        final uid = FirebaseAuth.instance.currentUser?.uid;
        final checkInTimeList =
            await _dbRepo.getCheckInData(workingModel.copyWith(userId: uid));
        await _dbRepo.checkIn(
          workingModel.copyWith(
            userId: uid,
            isCheckedIn: true,
            checkInTime: [
              Timestamp.fromDate(event.checkInTime),
              ...checkInTimeList.checkInTime ?? [],
            ],
          ),
        );
        add(CurrentWorkingHours());
        add(GetCheckInOutData());
      } catch (ex) {
        emit(state.copyWith());
      } finally {
        emit(state.copyWith(isLoading: false, error: ""));
      }
    } else {
      emit(state.copyWith(error: "You are not at Office."));
    }
    emit(state.copyWith(error: ""));
  }

  _checkOut(CheckOut event, Emitter<WorktimeState> emit) async {
    add(GetLocation());
    if (state.isWithinAllowedLocation) {
      emit(state.copyWith(isLoading: true));
      try {
        final workingModel = WorkingModel();

        final uid = FirebaseAuth.instance.currentUser?.uid;
        final checkOutTimeList =
            await _dbRepo.getCheckOutData(workingModel.copyWith(userId: uid));
        await _dbRepo.checkOut(
          workingModel.copyWith(
            userId: uid,
            checkOutTime: [
              Timestamp.fromDate(event.checkOutTime),
              ...checkOutTimeList.checkOutTime ?? [],
            ],
          ),
        );
        await _dbRepo.checkInUpdate(
          workingModel.copyWith(
            userId: uid,
            isCheckedIn: null,
          ),
        );

        await _dbRepo.addDuration(workingModel.copyWith(
            userId: uid, seconds: state.workingHours.inSeconds));

        final checkInData = await _dbRepo.getCheckInData(workingModel.copyWith(
          userId: uid,
        ));

        await _dbRepo.addSalary(
            workingModel.copyWith(salary: state.salary, userId: uid));

        emit(state.copyWith(workingModel: checkInData));
        final checkOutData =
            await _dbRepo.getCheckOutData(workingModel.copyWith(userId: uid));
        emit(state.copyWith(checkOutModel: checkOutData));
        add(CurrentWorkingHours());
        add(GetCheckInOutData());
      } catch (ex) {
        emit(state.copyWith(error: ex.toString()));
      } finally {
        emit(state.copyWith(isLoading: false, error: ""));
      }
    } else {
      emit(state.copyWith(error: "You are not at Office."));
    }
    emit(state.copyWith(error: ""));
  }

  _changeTime(ChangeTime event, Emitter<WorktimeState> emit) async {
    emit(
      state.copyWith(
          workingHours: event.time,
          timeOfDay: event.timeOfDay,
          allSeconds: event.allTime),
    );
  }

  _countSalary(CountSalary event, Emitter<WorktimeState> emit) {
    emit(state.copyWith(salary: event.salary, allSalary: event.allSalary));
  }

  _checkInOutData(CheckInOutData event, Emitter<WorktimeState> emit) async {
    try {
      final workingModel = WorkingModel();
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final checkInData = await _dbRepo.getCheckInData(
          workingModel.copyWith(userId: uid, uid: workingModel.uid));
      emit(state.copyWith(workingModel: checkInData));
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    } finally {
      emit(state.copyWith(error: ""));
    }
  }

  _allowCheckInOut(GetLocation event, Emitter<WorktimeState> emit) async {
    try {
      await Permission.location.request();
      var locationStatus = await Permission.location.status;
      if (locationStatus.isDenied) {
        await Permission.locationWhenInUse.request();
      }
      if (await Permission.location.isRestricted) {
        openAppSettings();
      }
      if (await Permission.location.isGranted) {
        Position position = await Geolocator.getCurrentPosition();

        final distance = Geolocator.distanceBetween(
            position.latitude, position.longitude, 21.2354, 72.8729);
        emit(state.copyWith(isWithinAllowedLocation: distance <= 100));
      }
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    } finally {
      emit(state.copyWith(error: ""));
    }
  }

  _getAllDuration(GetAllDurations event, Emitter<WorktimeState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final workingModel = WorkingModel();
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final allDurations = await _dbRepo.getAllDuration(
        workingModel.copyWith(userId: uid, month: event.month),
      );
      final List<String> data = [];
      for (var dates in allDurations) {
        log(dates.uid.toString());
        data.add(dates.uid!.substring(0, 2));
      }
      final userModel = UserModel();
      final allSalary = await _dbRepo.getUserData(userModel.copyWith(uid: uid));
      emit(state.copyWith(
          allDurationsData: allDurations,
          userModel: allSalary,
          allDates: data));
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    } finally {
      emit(state.copyWith(error: "", isLoading: false));
    }
  }
}
