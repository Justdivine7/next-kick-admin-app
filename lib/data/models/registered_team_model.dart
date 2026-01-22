import 'package:equatable/equatable.dart';

class RegisteredTeamModel extends Equatable {
  final String id;
  final String teamId;
  final String teamName;
  final String teamLocation;
  final String numberOfPlayers;
  final String tournamentId;
  final String tournamentTitle;
  final String tournamentLocation;
  final String amount;
  final bool isPaid;

  const RegisteredTeamModel({
    required this.id,
    required this.teamId,
    required this.teamName,
    required this.teamLocation,
    required this.numberOfPlayers,
    required this.tournamentId,
    required this.tournamentTitle,
    required this.tournamentLocation,
    required this.amount,
    required this.isPaid,
  });

  factory RegisteredTeamModel.fromJson(Map<String, dynamic> json) =>
      RegisteredTeamModel(
        id: json['id'] as String,
        teamId: json['team_id'] as String,
        teamName: json['team_name'] as String,
        teamLocation: json['team_location'] as String,
        numberOfPlayers: json['number_of_players'] as String,
        tournamentId: json['tournament_id'] as String,
        tournamentTitle: json['tournament_title'] as String,
        tournamentLocation: json['tournament_location'] as String,
        amount: json['amount'] as String,
        isPaid: json['is_paid'] as bool,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'team_id': teamId,
    'team_name': teamName,
    'team_location': teamLocation,
    'number_of_players': numberOfPlayers,
    'tournament_id': tournamentId,
    'tournament_title': tournamentTitle,
    'tournament_location': tournamentLocation,
    'amount': amount,
    'is_paid': isPaid,
  };

  RegisteredTeamModel copyWith({
    String? id,
    String? teamId,
    String? teamName,
    String? teamLocation,
    String? numberOfPlayers,
    String? tournamentId,
    String? tournamentTitle,
    String? tournamentLocation,
    String? amount,
    bool? isPaid,
  }) {
    return RegisteredTeamModel(
      id: id ?? this.id,
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      teamLocation: teamLocation ?? this.teamLocation,
      numberOfPlayers: numberOfPlayers ?? this.numberOfPlayers,
      tournamentId: tournamentId ?? this.tournamentId,
      tournamentTitle: tournamentTitle ?? this.tournamentTitle,
      tournamentLocation: tournamentLocation ?? this.tournamentLocation,
      amount: amount ?? this.amount,
      isPaid: isPaid ?? this.isPaid,
    );
  }

  @override
  List<Object?> get props => [
    id,
    teamId,
    teamName,
    teamLocation,
    numberOfPlayers,
    tournamentId,
    tournamentTitle,
    // tournamentLocation,
    amount,
    isPaid,
  ];
}
