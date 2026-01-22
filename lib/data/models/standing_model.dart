import 'package:equatable/equatable.dart';

class StandingModel extends Equatable {
  final String id;
  final String team;
  final int points;

  const StandingModel({
    required this.id,
    required this.team,
    required this.points,
  });

  factory StandingModel.fromJson(Map<String, dynamic> json) {
    return StandingModel(
      id: json['id'] as String,
      team: json['team'] as String,
      points: json['points'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'team': team,
      'points': points,
    };
  }

  StandingModel copyWith({
    String? id,
    String? team,
    int? points,
  }) {
    return StandingModel(
      id: id ?? this.id,
      team: team ?? this.team,
      points: points ?? this.points,
    );
  }

  @override
  List<Object?> get props => [id, team, points];
}
