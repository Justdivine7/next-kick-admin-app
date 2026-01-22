part of 'team_bloc.dart';

sealed class TeamState extends Equatable {
  const TeamState();

  @override
  List<Object?> get props => [];
}

final class TeamInitial extends TeamState {}

final class TeamLoading extends TeamState {}

final class TeamLoaded extends TeamState {
  final List<TeamModel> teams;
  const TeamLoaded({required this.teams});

  @override
  List<Object?> get props => [teams];
}

final class TeamError extends TeamState {
  final String error;
  const TeamError({required this.error});

  @override
  List<Object?> get props => [error];
}

class FetchTeamsCountLoading extends TeamState {}

class FetchTeamsCountLoaded extends TeamState {
  final int count;
  const FetchTeamsCountLoaded({required this.count});

  @override
  List<Object?> get props => [count];
}

class FetchTeamsCountError extends TeamState {
  final String error;
  const FetchTeamsCountError({required this.error});

  @override
  List<Object?> get props => [error];
}
