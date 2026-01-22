import 'dart:convert';
import 'package:equatable/equatable.dart';

class LoginResponse extends Equatable {
  final bool? success;
  final String? message;
  final Tokens? tokens;
  final User? user;
  final NotificationResult? notificationResult;

  const LoginResponse({
    this.success,
    this.message,
    this.tokens,
    this.user,
    this.notificationResult,
  });

  LoginResponse copyWith({
    bool? success,
    String? message,
    Tokens? tokens,
    User? user,
    NotificationResult? notificationResult,
  }) {
    return LoginResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      tokens: tokens ?? this.tokens,
      user: user ?? this.user,
      notificationResult: notificationResult ?? this.notificationResult,
    );
  }

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'],
      message: json['message'],
      tokens: json['tokens'] != null ? Tokens.fromJson(json['tokens']) : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      notificationResult: json['notification_result'] != null
          ? NotificationResult.fromJson(json['notification_result'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'tokens': tokens?.toJson(),
      'user': user?.toJson(),
      'notification_result': notificationResult?.toJson(),
    };
  }

  static LoginResponse fromJsonString(String str) =>
      LoginResponse.fromJson(json.decode(str));

  String toJsonString() => json.encode(toJson());

  @override
  List<Object?> get props => [success, message, tokens, user, notificationResult];
}

class Tokens extends Equatable {
  final String? refresh;
  final String? access;

  const Tokens({this.refresh, this.access});

  Tokens copyWith({String? refresh, String? access}) {
    return Tokens(
      refresh: refresh ?? this.refresh,
      access: access ?? this.access,
    );
  }

  factory Tokens.fromJson(Map<String, dynamic> json) {
    return Tokens(
      refresh: json['refresh'],
      access: json['access'],
    );
  }

  Map<String, dynamic> toJson() => {
        'refresh': refresh,
        'access': access,
      };

  @override
  List<Object?> get props => [refresh, access];
}

class User extends Equatable {
  final String? id;
  final String? email;
  final String? userType;
  final bool? isActive;
  final DateTime? dateJoined;

  const User({
    this.id,
    this.email,
    this.userType,
    this.isActive,
    this.dateJoined,
  });

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

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'user_type': userType,
        'is_active': isActive,
        'date_joined': dateJoined?.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, email, userType, isActive, dateJoined];
}

class NotificationResult extends Equatable {
  final bool? success;
  final bool? notificationCreated;
  final bool? websocketSent;
  final bool? pushSent;
  final List<dynamic>? errors;

  const NotificationResult({
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

  @override
  List<Object?> get props =>
      [success, notificationCreated, websocketSent, pushSent, errors];
}
