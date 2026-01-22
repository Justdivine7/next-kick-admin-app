import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextkick_admin/data/api_services/friendly_error.dart';
import 'package:nextkick_admin/data/models/fixture_model.dart';
import 'package:nextkick_admin/data/repositories/fixtures_repository.dart';

part 'fixtures_event.dart';
part 'fixtures_state.dart';

class FixturesBloc extends Bloc<FixturesEvent, FixturesState> {
  final FixturesRepository fixtureRepository;

  FixturesBloc({required this.fixtureRepository}) : super(FixturesInitial()) {
    on<CreateFixture>(_onCreateFixture);
    on<FetchFixtures>(_onFetchFixtures);
    on<FetchSelectedFixture>(_onFetchSelectedfixture);
    on<UpdateSelectedFixture>(_onUpdateSelectedFixture);
    on<DeleteSelectedFixture>(_onDeleteSelectedFixture);
  }

  Future<void> _onCreateFixture(
    CreateFixture event,
    Emitter<FixturesState> emit,
  ) async {
    emit(CreateFixturesLoading());
    try {
      final fixture = await fixtureRepository.createFixture(
        firstTeam: event.firstTeam,
        secondTeam: event.secondTeam,
        date: event.date,
        time: event.time,
        venue: event.venue,
        status: event.status,
      );
      emit(CreateFixturesSuccessful(fixture));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(CreateFixturesError(errorMessage));
    }
  }

  Future<void> _onFetchFixtures(
    FetchFixtures event,
    Emitter<FixturesState> emit,
  ) async {
    emit(FetchFixturesLoading());

    try {
      final fixtures = await fixtureRepository.fetchAllFixtures();

      emit(FetchFixturesSuccessful(fixtures));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(FetchFixturesError(errorMessage));
    }
  }

  Future<void> _onFetchSelectedfixture(
    FetchSelectedFixture event,
    Emitter<FixturesState> emit,
  ) async {
    emit(FetchSelectedFixtureLoading());
    try {
      final fixture = await fixtureRepository.fetchSelectedFixture(
        event.fixtureId,
      );
      emit(FetchSelectedFixtureSuccessful(fixture));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(FetchSelectedFixtureError(errorMessage));
    }
  }

  Future<void> _onUpdateSelectedFixture(
    UpdateSelectedFixture event,
    Emitter<FixturesState> emit,
  ) async {
    emit(UpdateSelectedFixtureLoading());
    try {
      final updatedFixture = await fixtureRepository.updateSelectedFixture(
        fixtureId: event.fixtureId,
        matchDate: event.matchDate,
        matchTime: event.matchTime,
        venue: event.venue,
        status: event.status,
        teamOneScore: event.teamOneScore,
        teamTwoScore: event.teamTwoScore,
      );
      emit(UpdateSelectedFixtureSuccesful(updatedFixture));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(UpdateSelectedFixtureError(errorMessage));
    }
  }

  Future<void> _onDeleteSelectedFixture(
    DeleteSelectedFixture event,
    Emitter<FixturesState> emit,
  ) async {
    emit(DeleteSelectedFixtureLoading());
    try {
      await fixtureRepository.deleteSelectedFixture(event.fixtureId);

      emit(DeleteSelectedFixtureSuccesful('Deleted successfully'));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(DeleteSelectedFixtureError(errorMessage));
    }
  }
}
