part of 'tournament_bloc.dart';

sealed class TournamentState extends Equatable {
  const TournamentState();

  @override
  List<Object?> get props => [];
}

final class TournamentInitial extends TournamentState {}

final class CreateTournamentLoading extends TournamentState {}

final class CreateTournamentSuccessful extends TournamentState {
  final String message;

  const CreateTournamentSuccessful({required this.message});
  @override
  List<Object?> get props => [];
}

final class CreateTournamentFailure extends TournamentState {
  final String error;

  const CreateTournamentFailure({required this.error});
  @override
  List<Object?> get props => [error];
}

final class FetchTournamentsLoading extends TournamentState {}

final class FetchTournamentsSuccessful extends TournamentState {
  final List<TournamentModel> tournaments;

  const FetchTournamentsSuccessful({required this.tournaments});
  @override
  List<Object?> get props => [tournaments];
}

final class FetchTournamentsFailure extends TournamentState {
  final String error;

  const FetchTournamentsFailure({required this.error});
  @override
  List<Object?> get props => [error];
}

final class FetchRegisteredTeamsLoading extends TournamentState {}

final class FetchRegisteredTeamsSuccessful extends TournamentState {
  final List<RegisteredTeamModel> teams;

  const FetchRegisteredTeamsSuccessful({required this.teams});
  @override
  List<Object?> get props => [teams];
}

final class FetchRegisteredTeamsFailure extends TournamentState {
  final String error;

  const FetchRegisteredTeamsFailure({required this.error});
  @override
  List<Object?> get props => [error];
}

final class UpdateRegisteredTeamsLoading extends TournamentState {}

final class UpdateRegisteredTeamsSuccessful extends TournamentState {
  const UpdateRegisteredTeamsSuccessful();
  @override
  List<Object?> get props => [];
}

final class UpdateRegisteredTeamsFailure extends TournamentState {
  final String error;

  const UpdateRegisteredTeamsFailure({required this.error});
  @override
  List<Object?> get props => [error];
}

final class RegisteredTeamProfileLoading extends TournamentState {}

final class RegisteredTeamProfileSuccessful extends TournamentState {
  final RegisteredTeamModel team;
  const RegisteredTeamProfileSuccessful(this.team);
  @override
  List<Object?> get props => [team];
}

final class RegisteredTeamProfileFailure extends TournamentState {
  final String error;

  const RegisteredTeamProfileFailure({required this.error});
  @override
  List<Object?> get props => [error];
}
