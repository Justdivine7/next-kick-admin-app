import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextkick_admin/data/api_services/friendly_error.dart';
import 'package:nextkick_admin/data/models/team_model.dart';
import 'package:nextkick_admin/data/repositories/user_management_repository.dart';

part 'team_event.dart';
part 'team_state.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  final UserManagementRepository _userRepo;
  TeamBloc(this._userRepo) : super(TeamInitial()) {
    on<FetchTeamsEvent>(_onFetchPlayers);
    on<FetchTeamCount>(_onFetchTeamsCount);
  }

  Future<void> _onFetchPlayers(
    FetchTeamsEvent event,
    Emitter<TeamState> emit,
  ) async {
    emit(TeamLoading());

    try {
      final teams = await _userRepo.fetchAllUsers(
        userType: event.userType,
        teamName: event.teamName,
        location: event.location,
      );

      emit(TeamLoaded(teams: teams.cast<TeamModel>()));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(TeamError(error: errorMessage));
    }
  }

  Future<void> _onFetchTeamsCount(
    FetchTeamCount event,
    Emitter<TeamState> emit,
  ) async {
    emit(FetchTeamsCountLoading());
    try {
      final teamCount = await _userRepo.fetchTeamsCount();
      emit(FetchTeamsCountLoaded(count: teamCount));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(FetchTeamsCountError(error: errorMessage));
    }
  }
}
