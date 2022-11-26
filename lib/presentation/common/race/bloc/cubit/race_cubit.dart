import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'race_state.dart';

class RaceCubit extends Cubit<RaceState> {
  RaceCubit() : super(RaceInitial());
}
