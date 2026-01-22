part of 'standings_bloc.dart';

sealed class StandingsState extends Equatable {
  const StandingsState();

  @override
  List<Object?> get props => [];
}

final class StandingsInitial extends StandingsState {}

final class CreateStandingsLoading extends StandingsState {}

final class CreateStandingsSuccessful extends StandingsState {}

final class CreateStandingsError extends StandingsState {
  final String error;
  const CreateStandingsError(this.error);
  @override
  List<Object?> get props => [error];
}

final class UpdateStandingsLoading extends StandingsState {}

final class UpdateStandingsSuccessful extends StandingsState {
  final StandingModel standing;
  const UpdateStandingsSuccessful(this.standing);
  @override
  List<Object?> get props => [standing];
}

final class UpdateStandingsError extends StandingsState {
  final String error;
  const UpdateStandingsError(this.error);
  @override
  List<Object?> get props => [error];
}

final class FetchStandingsLoading extends StandingsState {}

final class FetchStandingsSuccessful extends StandingsState {
  final List<StandingModel> standings;
  const FetchStandingsSuccessful(this.standings);
  @override
  List<Object?> get props => [standings];
}

final class FetchStandingsError extends StandingsState {
  final String error;
  const FetchStandingsError(this.error);
  @override
  List<Object?> get props => [error];
}

final class FetchStandingDetailsLoading extends StandingsState {}

final class FetchStandingDetailsSuccessful extends StandingsState {
  final StandingModel standings;
  const FetchStandingDetailsSuccessful(this.standings);
  @override
  List<Object?> get props => [standings];
}

final class FetchStandingDetailsError extends StandingsState {
  final String error;
  const FetchStandingDetailsError(this.error);
  @override
  List<Object?> get props => [error];
}
