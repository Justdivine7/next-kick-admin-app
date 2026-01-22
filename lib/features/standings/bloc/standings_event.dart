part of 'standings_bloc.dart';

sealed class StandingsEvent extends Equatable {
  const StandingsEvent();

  @override
  List<Object?> get props => [];
}

class CreateStanding extends StandingsEvent {
  final String teamName;
  final int point;
  const CreateStanding({required this.point, required this.teamName});
  @override
  List<Object?> get props => [point, teamName];
}

class UpdateStanding extends StandingsEvent {
  final String teamId;
  final int point;
  const UpdateStanding({required this.point, required this.teamId});
  @override
  List<Object?> get props => [point, teamId];
}

class FetchStandings extends StandingsEvent {
  final bool forceRefresh;
  const FetchStandings({required this.forceRefresh});
  @override
  List<Object?> get props => [forceRefresh];
}

class FetchStandingDetails extends StandingsEvent {
  final String standingId;
  final bool forceRefresh;
  const FetchStandingDetails({
    required this.forceRefresh,
    required this.standingId,
  });
  @override
  List<Object?> get props => [forceRefresh, standingId];
}
