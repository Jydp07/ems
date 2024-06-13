part of 'visiblity_cubit.dart';

class VisiblityState extends Equatable {
  const VisiblityState({required this.isVisible});
  final bool isVisible;

  VisiblityState copyWith({
    bool? isVisible,
  }) {
    return VisiblityState(isVisible: isVisible ?? this.isVisible);
  }

  @override
  List<Object> get props => [isVisible];
}
