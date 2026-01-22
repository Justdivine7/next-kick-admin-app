import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextkick_admin/data/api_services/friendly_error.dart';
import 'package:nextkick_admin/data/models/standing_model.dart';
import 'package:nextkick_admin/data/repositories/standings_repository.dart';

part 'standings_event.dart';
part 'standings_state.dart';

class StandingsBloc extends Bloc<StandingsEvent, StandingsState> {
  final StandingsRepository _standingsRepository;

  StandingsBloc(this._standingsRepository) : super(StandingsInitial()) {
    on<CreateStanding>(_onCreateStanding);
    on<UpdateStanding>(_onUpdateStanding);
    on<FetchStandings>(_onFetchStandings);
    on<FetchStandingDetails>(_onFetchStandingDetails);
  }

  Future<void> _onCreateStanding(
    CreateStanding event,
    Emitter<StandingsState> emit,
  ) async {
    emit(CreateStandingsLoading());
    try {
      await _standingsRepository.createStanding(
        teamName: event.teamName,
        teamPoint: event.point,
      );
      emit(CreateStandingsSuccessful());
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(CreateStandingsError(errorMessage));
    }
  }

  Future<void> _onUpdateStanding(
    UpdateStanding event,
    Emitter<StandingsState> emit,
  ) async {
    emit(UpdateStandingsLoading());
    try {
      final standing = await _standingsRepository.updateStanding(
        teamPoint: event.point,
        teamId: event.teamId,
      );
      emit(UpdateStandingsSuccessful(standing));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(UpdateStandingsError(errorMessage));
    }
  }

  Future<void> _onFetchStandings(
    FetchStandings event,
    Emitter<StandingsState> emit,
  ) async {
    emit(FetchStandingsLoading());
    try {
      final standings = await _standingsRepository.fetchStandings();
      emit(FetchStandingsSuccessful(standings));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(FetchStandingsError(errorMessage));
    }
  }

  Future<void> _onFetchStandingDetails(
    FetchStandingDetails event,
    Emitter<StandingsState> emit,
  ) async {
    emit(FetchStandingDetailsLoading());
    try {
      final details = await _standingsRepository.fetchStandingDetails(
        standingId: event.standingId,
      );
      emit(FetchStandingDetailsSuccessful(details));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(FetchStandingDetailsError(errorMessage));
    }
  }
}
