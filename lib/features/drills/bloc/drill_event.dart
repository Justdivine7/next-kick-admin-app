part of 'drill_bloc.dart';

sealed class DrillEvent extends Equatable {
  const DrillEvent();

  @override
  List<Object?> get props => [];
}

class FetchSubmittedDrills extends DrillEvent {}

class UpdateDrillStatus extends DrillEvent {
  final String id;
  final String status;

  const UpdateDrillStatus({required this.id, required this.status});

  @override
  List<Object?> get props => [id, status];
}
