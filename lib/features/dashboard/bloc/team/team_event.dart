part of 'team_bloc.dart';

sealed class TeamEvent extends Equatable {
  const TeamEvent();

  @override
  List<Object?> get props => [];
}

class FetchTeamsEvent extends TeamEvent {
  final String? teamName;

  final String? location;
  final String userType;
  final bool forceRefresh;

  const FetchTeamsEvent({
    this.teamName,

    this.location,
    required this.userType,
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [teamName, location, userType];
}

class FetchTeamCount extends TeamEvent {
  final bool forceRefresh;
  const FetchTeamCount({required this.forceRefresh});
  @override
  List<Object?> get props => [forceRefresh];
}
