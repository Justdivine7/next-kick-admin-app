part of 'drill_bloc.dart';

sealed class DrillState extends Equatable {
  const DrillState();

  @override
  List<Object?> get props => [];
}

final class DrillInitial extends DrillState {}

final class DrillLoading extends DrillState {}

final class DrillLoaded extends DrillState {
  final List<PlayerDrillSubmission> drills;
  const DrillLoaded(this.drills);

  @override
  List<Object?> get props => [drills];
}

final class DrillError extends DrillState {
  final String error;
  const DrillError({required this.error});
  @override
  List<Object?> get props => [error];
}

class UpdateDrillStatusLoading extends DrillState {
  final List<PlayerDrillSubmission> drills;

  const UpdateDrillStatusLoading({required this.drills});
  @override
  List<Object?> get props => [drills];
}

class UpdateDrillStatusSuccessful extends DrillState {
  final String message;
  const UpdateDrillStatusSuccessful({required this.message});
  @override
  List<Object?> get props => [message];
}

class UpdateDrillStatusError extends DrillState {
  final String error;
  final List<PlayerDrillSubmission> drills;

  const UpdateDrillStatusError({required this.error, required this.drills});
  @override
  List<Object?> get props => [error];
}
