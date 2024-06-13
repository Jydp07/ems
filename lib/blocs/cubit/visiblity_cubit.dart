import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'visiblity_state.dart';

class VisiblityCubit extends Cubit<VisiblityState> {
  VisiblityCubit() : super(const VisiblityState(isVisible: true));

  onChangeVisiblity(bool isVisible) {
    emit(state.copyWith(isVisible: isVisible));
  }
}
