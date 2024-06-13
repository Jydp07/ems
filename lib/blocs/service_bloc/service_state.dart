part of 'service_bloc.dart';

class ServiceState extends Equatable {
  const ServiceState(
      {required this.isRequestAdd,
      required this.isRequestDeleted,
      required this.leaveData,
      required this.isLoading,
      required this.salaryData,
      required this.error});
  final List<ServiceModel> leaveData;
  final List<WorkingModel> salaryData;
  final bool isLoading;
  final String error;
  final bool isRequestAdd;
  final bool isRequestDeleted;

  ServiceState copyWith(
      {List<ServiceModel>? leaveData,
      List<WorkingModel>? salaryData,
      bool? isLoading,
      String? error,
      bool? isRequestDeleted,
      bool? isRequestAdd}) {
    return ServiceState(
        leaveData: leaveData ?? this.leaveData,
        isLoading: isLoading ?? this.isLoading,
        salaryData: salaryData ?? this.salaryData,
        isRequestAdd: isRequestAdd ?? this.isRequestAdd,
        isRequestDeleted: isRequestDeleted ?? this.isRequestDeleted,
        error: error ?? this.error);
  }

  @override
  List<Object> get props =>
      [leaveData, isLoading, error, isRequestAdd, salaryData, isRequestDeleted];
}
