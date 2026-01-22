import 'dart:convert';
import 'package:equatable/equatable.dart';

class PlayerDrillSubmission extends Equatable {
  final int? id;
  final String? playerId;
  final String? playerName;
  final String? playerEmail;
  final String? playerPosition;
  final int? drillId;
  final String? drillTitle;
  final String? drillLevel;
  final String? drillPosition;
  final String? submissionLink;
  final bool? isCompleted;
  final bool? isApproved;
  final bool? isRejected;
  final DateTime? submittedAt;

  const PlayerDrillSubmission({
    this.id,
    this.playerId,
    this.playerName,
    this.playerEmail,
    this.playerPosition,
    this.drillId,
    this.drillTitle,
    this.drillLevel,
    this.drillPosition,
    this.submissionLink,
    this.isCompleted,
    this.isApproved,
    this.isRejected,
    this.submittedAt,
  });

  /// Computed property for easy pending check
  bool get isPending => (isApproved == false && isRejected == false);

  PlayerDrillSubmission copyWith({
    int? id,
    String? playerId,
    String? playerName,
    String? playerEmail,
    String? playerPosition,
    int? drillId,
    String? drillTitle,
    String? drillLevel,
    String? drillPosition,
    String? submissionLink,
    bool? isCompleted,
    bool? isApproved,
    bool? isRejected,
    DateTime? submittedAt,
  }) {
    return PlayerDrillSubmission(
      id: id ?? this.id,
      playerId: playerId ?? this.playerId,
      playerName: playerName ?? this.playerName,
      playerEmail: playerEmail ?? this.playerEmail,
      playerPosition: playerPosition ?? this.playerPosition,
      drillId: drillId ?? this.drillId,
      drillTitle: drillTitle ?? this.drillTitle,
      drillLevel: drillLevel ?? this.drillLevel,
      drillPosition: drillPosition ?? this.drillPosition,
      submissionLink: submissionLink ?? this.submissionLink,
      isCompleted: isCompleted ?? this.isCompleted,
      isApproved: isApproved ?? this.isApproved,
      isRejected: isRejected ?? this.isRejected,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }

  factory PlayerDrillSubmission.fromJson(Map<String, dynamic> json) {
    return PlayerDrillSubmission(
      id: json['id'],
      playerId: json['player_id'],
      playerName: json['player_name'],
      playerEmail: json['player_email'],
      playerPosition: json['player_position'],
      drillId: json['drill_id'],
      drillTitle: json['drill_title'],
      drillLevel: json['drill_level'],
      drillPosition: json['drill_position'],
      submissionLink: json['submission_link'],
      isCompleted: json['is_completed'],
      isApproved: json['is_approved'],
      isRejected: json['is_rejected'],
      submittedAt: json['submitted_at'] != null
          ? DateTime.parse(json['submitted_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'player_id': playerId,
      'player_name': playerName,
      'player_email': playerEmail,
      'player_position': playerPosition,
      'drill_id': drillId,
      'drill_title': drillTitle,
      'drill_level': drillLevel,
      'drill_position': drillPosition,
      'submission_link': submissionLink,
      'is_completed': isCompleted,
      'is_approved': isApproved,
      'is_rejected': isRejected,
      'submitted_at': submittedAt?.toIso8601String(),
    };
  }

  static PlayerDrillSubmission fromJsonString(String str) =>
      PlayerDrillSubmission.fromJson(json.decode(str));

  String toJsonString() => json.encode(toJson());

  @override
  List<Object?> get props => [
        id,
        playerId,
        playerName,
        playerEmail,
        playerPosition,
        drillId,
        drillTitle,
        drillLevel,
        drillPosition,
        submissionLink,
        isCompleted,
        isApproved,
        isRejected,
        submittedAt,
      ];
}
