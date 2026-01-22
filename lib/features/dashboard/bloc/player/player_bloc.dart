import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextkick_admin/data/api_services/friendly_error.dart';
import 'package:nextkick_admin/data/models/player_model.dart';
import 'package:nextkick_admin/data/repositories/user_management_repository.dart';

part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final UserManagementRepository _userRepo;

  PlayerBloc(this._userRepo) : super(PlayerInitial()) {
    on<FetchPlayersEvent>(_onFetchPlayers);
    on<FetchPlayersCount>(_onFetchPlayersCount);
  }

  Future<void> _onFetchPlayers(
    FetchPlayersEvent event,
    Emitter<PlayerState> emit,
  ) async {
    emit(PlayerLoading());
    try {
      final players = await _userRepo.fetchAllUsers(
        userType: event.userType,
        fullName: event.fullName,
        location: event.location,
        level: event.level,
        playerPosition: event.playerPosition,
      );

      emit(PlayerLoaded(players: players.cast<PlayerModel>()));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(PlayerError(error: errorMessage));
    }
  }

  Future<void> _onFetchPlayersCount(
    FetchPlayersCount event,
    Emitter<PlayerState> emit,
  ) async {
    emit(FetchPlayersCountLoading());
    try {
      final playerCount = await _userRepo.fetchPlayersCount();
      emit(FetchPlayersCountLoaded(playerCount));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);

      emit(FetchPlayersCountError(error: errorMessage));
    }
  }
}
