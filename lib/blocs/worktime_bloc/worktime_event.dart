part of 'worktime_bloc.dart';

sealed class WorktimeEvent extends Equatable {
  const WorktimeEvent();

  @override
  List<Object?> get props => [];
}

class CurrentWorkingHours extends WorktimeEvent {}

class ChangeTime extends WorktimeEvent {
  final Duration? time;
  final Duration? allTime;
  final DateTime timeOfDay;
  const ChangeTime({this.time, required this.timeOfDay, this.allTime});

  @override
  List<Object?> get props => [time, timeOfDay, allTime];
}

class CountSalary extends WorktimeEvent {
  final double salary;
  final double allSalary;
  const CountSalary({required this.salary,required this.allSalary});

  @override
  List<Object> get props => [salary, allSalary];
}

class CheckIn extends WorktimeEvent {
  final DateTime checkInTime;

  const CheckIn({required this.checkInTime});

  @override
  List<Object> get props => [checkInTime];
}

class CheckOut extends WorktimeEvent {
  final DateTime checkOutTime;

  const CheckOut({required this.checkOutTime});

  @override
  List<Object> get props => [checkOutTime];
}

class CheckInOutData extends WorktimeEvent {}

class GetCheckInOutData extends WorktimeEvent {
  @override
  List<Object> get props => [];
}

class GetLocation extends WorktimeEvent {
  @override
  List<Object?> get props => [];
}

class GetAllDurations extends WorktimeEvent {
  final int? month;

  const GetAllDurations({this.month});
  @override
  List<Object?> get props => [month];
}

class TimerCancel extends WorktimeEvent{
  @override
  List<Object?> get props => [];
}
