import 'dart:convert';

class AdminModel {
  final User? user;
  final NotificationResult? notificationResult;

  AdminModel({this.user, this.notificationResult});

  AdminModel copyWith({User? user, NotificationResult? notificationResult}) {
    return AdminModel(
      user: user ?? this.user,
      notificationResult: notificationResult ?? this.notificationResult,
    );
  }

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      notificationResult: json['notification_result'] != null
          ? NotificationResult.fromJson(json['notification_result'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'notification_result': notificationResult?.toJson(),
    };
  }

  static AdminModel fromJsonString(String str) =>
      AdminModel.fromJson(json.decode(str));

  String toJsonString() => json.encode(toJson());
}

class User {
  final String? id;
  final String? email;
  final String? userType;
  final bool? isActive;
  final DateTime? dateJoined;

  User({this.id, this.email, this.userType, this.isActive, this.dateJoined});

  User copyWith({
    String? id,
    String? email,
    String? userType,
    bool? isActive,
    DateTime? dateJoined,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      isActive: isActive ?? this.isActive,
      dateJoined: dateJoined ?? this.dateJoined,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      userType: json['user_type'],
      isActive: json['is_active'],
      dateJoined: json['date_joined'] != null
          ? DateTime.parse(json['date_joined'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'user_type': userType,
      'is_active': isActive,
      'date_joined': dateJoined?.toIso8601String(),
    };
  }
}

class NotificationResult {
  final bool? success;
  final bool? notificationCreated;
  final bool? websocketSent;
  final bool? pushSent;
  final List<dynamic>? errors;

  NotificationResult({
    this.success,
    this.notificationCreated,
    this.websocketSent,
    this.pushSent,
    this.errors,
  });

  NotificationResult copyWith({
    bool? success,
    bool? notificationCreated,
    bool? websocketSent,
    bool? pushSent,
    List<dynamic>? errors,
  }) {
    return NotificationResult(
      success: success ?? this.success,
      notificationCreated: notificationCreated ?? this.notificationCreated,
      websocketSent: websocketSent ?? this.websocketSent,
      pushSent: pushSent ?? this.pushSent,
      errors: errors ?? this.errors,
    );
  }

  factory NotificationResult.fromJson(Map<String, dynamic> json) {
    return NotificationResult(
      success: json['success'],
      notificationCreated: json['notification_created'],
      websocketSent: json['websocket_sent'],
      pushSent: json['push_sent'],
      errors: json['errors'] != null
          ? List<dynamic>.from(json['errors'])
          : <dynamic>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'notification_created': notificationCreated,
      'websocket_sent': websocketSent,
      'push_sent': pushSent,
      'errors': errors ?? [],
    };
  }
}
