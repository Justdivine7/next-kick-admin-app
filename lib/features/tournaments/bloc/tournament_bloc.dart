import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextkick_admin/data/api_services/app_api_services.dart';
import 'package:nextkick_admin/data/api_services/friendly_error.dart';
import 'package:nextkick_admin/data/models/registered_team_model.dart';
import 'package:nextkick_admin/data/models/tournament_model.dart';
import 'package:nextkick_admin/data/repositories/tournament_repository.dart';

part 'tournament_event.dart';
part 'tournament_state.dart';

class TournamentBloc extends Bloc<TournamentEvent, TournamentState> {
  final TournamentRepository _tournamentRepository;
  final AppApiClient apiClient;

  TournamentBloc(this._tournamentRepository, this.apiClient)
    : super(TournamentInitial()) {
    on<CreateTournament>(_onCreateTournament);
    on<FetchTournament>(_onFetchTournaments);
    on<FetchRegisteredTeams>(_onFetchRegisteredTeams);
    on<UpdateRegisteredTeam>(_onUpdateRegisteredTeam);
    on<FetchRegisteredTeamDetails>(_onFetchRegisteredTeamDetails);
  }

  Future<void> _onCreateTournament(
    CreateTournament event,
    Emitter<TournamentState> emit,
  ) async {
    emit(CreateTournamentLoading());
    try {
      final tournament = await _tournamentRepository.createTournament(
        title: event.title,
        description: event.description,
        location: event.location,
      );
      emit(CreateTournamentSuccessful(message: tournament));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(CreateTournamentFailure(error: errorMessage));
    }
  }

  Future<void> _onFetchTournaments(
    FetchTournament event,
    Emitter<TournamentState> emit,
  ) async {
    emit(FetchTournamentsLoading());
    try {
      final tournaments = await _tournamentRepository.fetchAllTournaments();

      emit(FetchTournamentsSuccessful(tournaments: tournaments));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(FetchTournamentsFailure(error: errorMessage));
    }
  }

  Future<void> _onFetchRegisteredTeams(
    FetchRegisteredTeams event,
    Emitter<TournamentState> emit,
  ) async {
    emit(FetchRegisteredTeamsLoading());
    try {
      final teams = await _tournamentRepository.getRegisteredTeams();

      emit(FetchRegisteredTeamsSuccessful(teams: teams));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(FetchRegisteredTeamsFailure(error: errorMessage));
    }
  }

  Future<void> _onUpdateRegisteredTeam(
    UpdateRegisteredTeam event,
    Emitter<TournamentState> emit,
  ) async {
    emit(UpdateRegisteredTeamsLoading());
    try {
      await _tournamentRepository.updateRegisteredTeam(
        id: event.id,
        teamName: event.amount,
        teamLocation: event.teamLocation,
        noOfPlayers: event.noOfPlayers,
        amount: event.amount,
      );
      emit(UpdateRegisteredTeamsSuccessful());
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(UpdateRegisteredTeamsFailure(error: errorMessage));
    }
  }

  Future<void> _onFetchRegisteredTeamDetails(
    FetchRegisteredTeamDetails event,
    Emitter<TournamentState> emit,
  ) async {
    emit(RegisteredTeamProfileLoading());

    try {
      final team = await _tournamentRepository.getRegisteredTeamDetails(
        event.teamId,
      );
      emit(RegisteredTeamProfileSuccessful(team));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(RegisteredTeamProfileFailure(error: errorMessage));
    }
  }
}
