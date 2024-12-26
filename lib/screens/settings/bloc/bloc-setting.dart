import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_fluter/screens/settings/bloc/events-setting.dart';
import 'package:learn_fluter/screens/settings/bloc/state-setting.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState(0)) {
    on<IncrementEvent>((event, emit) {
      emit(CounterState(state.counterValue + 1));
    });
    on<DecrementEvent>((event, emit) {
      emit(CounterState(state.counterValue - 1));
    });
    on<ResetEvent>((event, emit) {
      emit(const CounterState(0));
    });
  }
}
