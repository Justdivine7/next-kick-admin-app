part of 'fixtures_bloc.dart';

sealed class FixturesEvent extends Equatable {
  const FixturesEvent();

  @override
  List<Object?> get props => [];
}

class CreateFixture extends FixturesEvent {
  final String firstTeam;
  final String secondTeam;
  final String date;
  final String time;
  final String venue;
  final String status;

  const CreateFixture({
    required this.firstTeam,
    required this.secondTeam,
    required this.date,
    required this.time,
    required this.venue,
    required this.status,
  });

  @override
  List<Object?> get props => [firstTeam, secondTeam, date, time, venue, status];
}

class FetchFixtures extends FixturesEvent {
  final bool forceRefresh;

  const FetchFixtures({required this.forceRefresh});

  @override
  List<Object> get props => [forceRefresh];
}

class FetchSelectedFixture extends FixturesEvent {
  final String fixtureId;

  const FetchSelectedFixture({required this.fixtureId});
  @override
  List<Object?> get props => [fixtureId];
}

class UpdateSelectedFixture extends FixturesEvent {
  final String fixtureId;
  final String matchDate;
  final String matchTime;
  final String venue;
  final String status;
  final int teamOneScore;
  final int teamTwoScore;

  const UpdateSelectedFixture({
    required this.fixtureId,
    required this.matchDate,
    required this.matchTime,
    required this.venue,
    required this.status,
    required this.teamOneScore,
    required this.teamTwoScore,
  });

  @override
  List<Object?> get props => [
    fixtureId,
    matchDate,
    matchTime,
    teamOneScore,
    teamTwoScore,
    venue,
    status,
  ];
}

class DeleteSelectedFixture extends FixturesEvent {
  final String fixtureId;

  const DeleteSelectedFixture({required this.fixtureId});
  @override
  List<Object?> get props => [fixtureId];
}
