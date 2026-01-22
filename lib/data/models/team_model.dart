import 'package:equatable/equatable.dart';

class TeamModel extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String fullName;
  final String userType;
  final bool isActive;
  final bool isStaff;
  final bool isSuperuser;
  final String dateJoined;
  final TeamProfile profile;

  const TeamModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.userType,
    required this.isActive,
    required this.isStaff,
    required this.isSuperuser,
    required this.dateJoined,
    required this.profile,
  });

  TeamModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? fullName,
    String? userType,
    bool? isActive,
    bool? isStaff,
    bool? isSuperuser,
    String? dateJoined,
    TeamProfile? profile,
  }) {
    return TeamModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullName: fullName ?? this.fullName,
      userType: userType ?? this.userType,
      isActive: isActive ?? this.isActive,
      isStaff: isStaff ?? this.isStaff,
      isSuperuser: isSuperuser ?? this.isSuperuser,
      dateJoined: dateJoined ?? this.dateJoined,
      profile: profile ?? this.profile,
    );
  }

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      fullName: json['full_name'] ?? '',
      userType: json['user_type'],
      isActive: json['is_active'] ?? false,
      isStaff: json['is_staff'] ?? false,
      isSuperuser: json['is_superuser'] ?? false,
      dateJoined: json['date_joined'],
      profile: TeamProfile.fromJson(json['profile'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'full_name': fullName,
        'user_type': userType,
        'is_active': isActive,
        'is_staff': isStaff,
        'is_superuser': isSuperuser,
        'date_joined': dateJoined,
        'profile': profile.toJson(),
      };

  @override
  List<Object?> get props => [id, email, fullName, userType, profile];
}

class TeamProfile extends Equatable {
  final String teamName;
  final String ageGroup;
  final String location;

  const TeamProfile({
    required this.teamName,
    required this.ageGroup,
    required this.location,
  });

  factory TeamProfile.fromJson(Map<String, dynamic> json) {
    return TeamProfile(
      teamName: json['team_name'] ?? '',
      ageGroup: json['age_group'] ?? '',
      location: json['location'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'team_name': teamName,
        'age_group': ageGroup,
        'location': location,
      };

  @override
  List<Object?> get props => [teamName, ageGroup, location];
}
