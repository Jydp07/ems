part of 'admin_bloc.dart';

sealed class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object> get props => [];
}

class GetUserByUid extends AdminEvent {
  final String uid;

  const GetUserByUid({required this.uid});
  @override
  List<Object> get props => [uid];
}

class GetCheckInOutDataAdmin extends AdminEvent {
  final String uid;

  const GetCheckInOutDataAdmin({required this.uid});
  @override
  List<Object> get props => [uid];
}

class GetAllSalaryAdmin extends AdminEvent {
  final String uid;

  const GetAllSalaryAdmin({required this.uid});
  @override
  List<Object> get props => [uid];
}

class GetAllDurationsAdmin extends AdminEvent {
  final String uid;
  final int month;
  const GetAllDurationsAdmin({required this.month, required this.uid});
  @override
  List<Object> get props => [uid, month];
}

class GetLeavesDataAdmin extends AdminEvent {
  final String uid;

  const GetLeavesDataAdmin({required this.uid});
  @override
  List<Object> get props => [uid];
}

class AcceptDeniedLeaves extends AdminEvent {
  final bool isAccept;
  final String uid;
  final String userId;
  const AcceptDeniedLeaves(
      {required this.isAccept, required this.uid, required this.userId});
  @override
  List<Object> get props => [isAccept, uid, userId];
}

class UpdateSalaryAndPosition extends AdminEvent {
  final String position;
  final double salary;
  final String uid;
  const UpdateSalaryAndPosition(
      {required this.uid, required this.position, required this.salary});

  @override
  List<Object> get props => [position, salary, uid];
}
