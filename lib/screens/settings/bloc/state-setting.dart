import 'package:equatable/equatable.dart';

class CounterState extends Equatable {
  final int counterValue;

  const CounterState(this.counterValue);

  @override
  List<Object?> get props => [counterValue];
}
