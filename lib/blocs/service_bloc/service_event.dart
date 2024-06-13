part of 'service_bloc.dart';

sealed class ServiceEvent extends Equatable {
  const ServiceEvent();

  @override
  List<Object?> get props => [];
}

class AddLeave extends ServiceEvent {
  final String description;
  final String startDate;
  final String endDate;
  final DateTime? requestAt;
  final bool? isApprove;
  const AddLeave(
      {required this.description,
      required this.startDate,
      this.requestAt,
      this.isApprove,
      required this.endDate});

  @override
  List<Object?> get props =>
      [description, startDate, endDate, requestAt, isApprove];
}

class GetLeavesData extends ServiceEvent {
  @override
  List<Object> get props => [];
}

class DeleteData extends ServiceEvent {
  final String uid;
  final BuildContext context;
  final int index;
  final ServiceModel serviceModel;
  const DeleteData(
      {required this.uid,
      required this.context,
      required this.index,
      required this.serviceModel});
  @override
  List<Object> get props => [uid, context, index, serviceModel];
}

class GetAllSalary extends ServiceEvent {
  @override
  List<Object> get props => [];
}
