part of 'player_bloc.dart';

sealed class PlayerState extends Equatable {
  const PlayerState();

  @override
  List<Object?> get props => [];
}

final class PlayerInitial extends PlayerState {}

final class PlayerLoading extends PlayerState {}

final class PlayerLoaded extends PlayerState {
  final List<PlayerModel> players;
  const PlayerLoaded({required this.players});

  @override
  List<Object?> get props => [players];
}

final class PlayerError extends PlayerState {
  final String error;
  const PlayerError({required this.error});

  @override
  List<Object?> get props => [error];
}

class FetchPlayersCountLoading extends PlayerState {}

class FetchPlayersCountLoaded extends PlayerState {
  final int count;
  const FetchPlayersCountLoaded(this.count);
  @override
  List<Object?> get props => [count];
}

class FetchPlayersCountError extends PlayerState {
  final String error;
  const FetchPlayersCountError({required this.error});

  @override
  List<Object?> get props => [error];
}
