import 'package:equatable/equatable.dart';

class PlayerModel extends Equatable {
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
  final PlayerProfile profile;

  const PlayerModel({
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

  PlayerModel copyWith({
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
    PlayerProfile? profile,
  }) {
    return PlayerModel(
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

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
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
      profile: PlayerProfile.fromJson(json['profile'] ?? {}),
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

class PlayerProfile extends Equatable {
  final int age;
  final double height;
  final String country;
  final String playerPosition;
  final String activeBundle;
  final String profilePicture;
  final bool hasPerformanceVideo;

  const PlayerProfile({
    required this.age,
    required this.height,
    required this.country,
    required this.playerPosition,
    required this.activeBundle,
    required this.profilePicture,
    required this.hasPerformanceVideo,
  });

  factory PlayerProfile.fromJson(Map<String, dynamic> json) {
    return PlayerProfile(
      age: json['age'] ?? 0,
      height: json['height'] ?? 0,
      country: json['country'] ?? '',
      playerPosition: json['player_position'] ?? '',
      activeBundle: json['active_bundle'] ?? '',
      profilePicture: json['profile_picture'] ?? '',
      hasPerformanceVideo: json['has_performance_video'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'age': age,
    'height': height,
    'country': country,
    'player_position': playerPosition,
    'active_bundle': activeBundle,
    'profile_picture': profilePicture,
    'has_performance_video': hasPerformanceVideo,
  };

  @override
  List<Object?> get props => [
    age,
    height,
    country,
    playerPosition,
    activeBundle,
    profilePicture,
    hasPerformanceVideo,
  ];
}
