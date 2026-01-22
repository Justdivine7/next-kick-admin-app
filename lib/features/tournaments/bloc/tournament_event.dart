part of 'tournament_bloc.dart';

sealed class TournamentEvent extends Equatable {
  const TournamentEvent();

  @override
  List<Object?> get props => [];
}

class CreateTournament extends TournamentEvent {
  final String title;
  final String description;
  final String location;

  const CreateTournament({
    required this.title,
    required this.description,
    required this.location,
  });

  @override
  List<Object?> get props => [title, description, location];
}

class FetchTournament extends TournamentEvent {}

class FetchRegisteredTeams extends TournamentEvent {
  final bool forceRefresh;
  const FetchRegisteredTeams({required this.forceRefresh});

  @override
  List<Object> get props => [forceRefresh];
}

class UpdateRegisteredTeam extends TournamentEvent {
  final String id;
  final String teamName;
  final String teamLocation;
  final String noOfPlayers;
  final String amount;

  const UpdateRegisteredTeam({
    required this.id,
    required this.teamName,
    required this.teamLocation,
    required this.noOfPlayers,
    required this.amount,
  });
  @override
  List<Object?> get props => [
    id,
    teamLocation,
    teamLocation,
    noOfPlayers,
    amount,
  ];
}

class FetchRegisteredTeamDetails extends TournamentEvent {
  final String teamId;
  const FetchRegisteredTeamDetails(this.teamId);

  @override
  List<Object?> get props => [teamId];
}
