import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'header_state.dart';

class HeaderCubit extends Cubit<HeaderState> {
  HeaderCubit() : super(HeaderInitial());
}
