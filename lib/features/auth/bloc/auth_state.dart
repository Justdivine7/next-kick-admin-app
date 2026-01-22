part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {}

class LoginLoading extends AuthState {}

class LoginSuccessful extends AuthState {
  final LoginResponse user;
  const LoginSuccessful({required this.user});

  @override
  List<Object?> get props => [user];
}

class LoginFailure extends AuthState {
  final String error;
  const LoginFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
