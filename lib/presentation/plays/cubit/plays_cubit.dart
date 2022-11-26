import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'plays_state.dart';

class PlaysCubit extends Cubit<PlaysState> {
  PlaysCubit() : super(PlaysInitial());
}
