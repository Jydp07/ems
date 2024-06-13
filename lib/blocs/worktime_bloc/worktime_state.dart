part of 'worktime_bloc.dart';

class WorktimeState extends Equatable {
  const WorktimeState(
      {required this.salary,
      required this.allCheckOutData,
      required this.workingHours,
      required this.timeOfDay,
      required this.isLoading,
      required this.workingModel,
      required this.checkOutModel,
      required this.allDates,
      required this.allSalary,
      required this.allCheckInData,
      required this.allSeconds,
      required this.allDurationsData,
      required this.isWithinAllowedLocation,
      required this.userModel,
      required this.error});
  final Duration workingHours;
  final double salary;
  final double allSalary;
  final DateTime timeOfDay;
  final bool isLoading;
  final String error;
  final Duration allSeconds;
  final bool isWithinAllowedLocation;
  final WorkingModel workingModel;
  final WorkingModel checkOutModel;
  final UserModel userModel;
  final List<WorkingModel> allCheckInData;
  final List<WorkingModel> allCheckOutData;
  final List<String> allDates;
  final List<WorkingModel> allDurationsData;

  WorktimeState copyWith(
      {Duration? workingHours,
      double? salary,
      DateTime? timeOfDay,
      bool? isLoading,
      double? allSalary,
      bool? isWithinAllowedLocation,
      Duration? allSeconds,
      List<WorkingModel>? allCheckInData,
      List<WorkingModel>? allCheckOutData,
      List<WorkingModel>? allDurationsData,
      List<String>? allDates,
      UserModel? userModel,
      WorkingModel? checkOutModel,
      WorkingModel? workingModel,
      String? error}) {
    return WorktimeState(
        workingHours: workingHours ?? this.workingHours,
        timeOfDay: timeOfDay ?? this.timeOfDay,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        allSalary: allSalary ?? this.allSalary,
        allDates: allDates ?? this.allDates,
        userModel: userModel ?? this.userModel,
        allDurationsData: allDurationsData ?? this.allDurationsData,
        allSeconds: allSeconds ?? this.allSeconds,
        isWithinAllowedLocation:
            isWithinAllowedLocation ?? this.isWithinAllowedLocation,
        allCheckInData: allCheckInData ?? this.allCheckInData,
        allCheckOutData: allCheckOutData ?? this.allCheckOutData,
        checkOutModel: checkOutModel ?? this.checkOutModel,
        workingModel: workingModel ?? this.workingModel,
        salary: salary ?? this.salary);
  }

  @override
  List<Object> get props => [
        workingHours,
        salary,
        timeOfDay,
        error,
        allSeconds,
        isLoading,
        workingModel,
        userModel,
        allSalary,
        checkOutModel,
        allCheckOutData,
        allDurationsData,
        allDates,
        isWithinAllowedLocation,
        allCheckInData
      ];
}
