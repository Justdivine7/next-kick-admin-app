part of 'player_bloc.dart';

sealed class PlayerEvent extends Equatable {
  const PlayerEvent();

  @override
  List<Object?> get props => [];
}

class FetchPlayersEvent extends PlayerEvent {
  final String? fullName;
  final String? location;
  final String? level;
  final String? playerPosition;
  final String userType;
  final bool forceRefresh;

  const FetchPlayersEvent({
    this.fullName,
    this.location,
    this.level,
    this.playerPosition,
    required this.userType,
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [
    fullName,
    location,
    level,
    playerPosition,
    userType,
    forceRefresh,
  ];
}

class FetchPlayersCount extends PlayerEvent {
  final bool forceRefresh;
  const FetchPlayersCount({required this.forceRefresh});
  @override
  List<Object?> get props => [forceRefresh];
}
