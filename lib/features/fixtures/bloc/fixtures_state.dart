part of 'fixtures_bloc.dart';

sealed class FixturesState extends Equatable {
  const FixturesState();

  @override
  List<Object?> get props => [];
}

final class FixturesInitial extends FixturesState {}

final class CreateFixturesLoading extends FixturesState {}

final class CreateFixturesSuccessful extends FixturesState {
  final String message;
  const CreateFixturesSuccessful(this.message);
  @override
  List<Object?> get props => [message];
}

final class CreateFixturesError extends FixturesState {
  final String error;
  const CreateFixturesError(this.error);
  @override
  List<Object?> get props => [error];
}

final class FetchFixturesLoading extends FixturesState {}

final class FetchFixturesSuccessful extends FixturesState {
  final List<FixtureModel> fixture;
  const FetchFixturesSuccessful(this.fixture);
  @override
  List<Object?> get props => [fixture];
}

final class FetchFixturesError extends FixturesState {
  final String error;
  const FetchFixturesError(this.error);
  @override
  List<Object?> get props => [error];
}

final class FetchSelectedFixtureLoading extends FixturesState {}

final class FetchSelectedFixtureSuccessful extends FixturesState {
  final FixtureModel fixture;
  const FetchSelectedFixtureSuccessful(this.fixture);
  @override
  List<Object?> get props => [fixture];
}

final class FetchSelectedFixtureError extends FixturesState {
  final String error;
  const FetchSelectedFixtureError(this.error);
  @override
  List<Object?> get props => [error];
}

final class UpdateSelectedFixtureLoading extends FixturesState {}

final class UpdateSelectedFixtureSuccesful extends FixturesState {
  final FixtureModel fixture;
  const UpdateSelectedFixtureSuccesful(this.fixture);
  @override
  List<Object?> get props => [fixture];
}

final class UpdateSelectedFixtureError extends FixturesState {
  final String error;
  const UpdateSelectedFixtureError(this.error);
  @override
  List<Object?> get props => [error];
}

final class DeleteSelectedFixtureLoading extends FixturesState {}

final class DeleteSelectedFixtureSuccesful extends FixturesState {
  final String message;
  const DeleteSelectedFixtureSuccesful(this.message);
  @override
  List<Object?> get props => [message];
}

final class DeleteSelectedFixtureError extends FixturesState {
  final String error;
  const DeleteSelectedFixtureError(this.error);
  @override
  List<Object?> get props => [error];
}
