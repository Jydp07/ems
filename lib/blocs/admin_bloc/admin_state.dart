part of 'admin_bloc.dart';

class AdminState extends Equatable {
  const AdminState(
      {required this.leaveData,
      required this.salaryData,
      required this.allCheckInData,
      required this.allCheckOutData,
      required this.allDurationsData,
      required this.error,
      required this.allDates,
      required this.isLoading,
      required this.userModel});
  final UserModel userModel;
  final String error;
  final bool isLoading;
  final List<WorkingModel> allCheckInData;
  final List<WorkingModel> allCheckOutData;
  final List<WorkingModel> allDurationsData;
  final List<ServiceModel> leaveData;
  final List<WorkingModel> salaryData;
  final List<String> allDates;

  AdminState copyWith({
    bool? isLoading,
    UserModel? userModel,
    String? error,
    List<String>? allDates,
    List<WorkingModel>? allCheckInData,
    List<WorkingModel>? allCheckOutData,
    List<WorkingModel>? allDurationsData,
    List<ServiceModel>? leaveData,
    List<WorkingModel>? salaryData,
  }) {
    return AdminState(
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
        userModel: userModel ?? this.userModel,
        allDates: allDates ?? this.allDates,
        allCheckInData: allCheckInData ?? this.allCheckInData,
        allCheckOutData: allCheckOutData ?? this.allCheckOutData,
        allDurationsData: allDurationsData ?? this.allDurationsData,
        leaveData: leaveData ?? this.leaveData,
        salaryData: salaryData ?? this.salaryData);
  }

  @override
  List<Object> get props => [
        userModel,
        error,
        isLoading,
        allCheckInData,
        allCheckOutData,
        allDurationsData,
        allDates,
        leaveData,
        salaryData
      ];
}
