part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}
// LOGIN

class LoginDetailsSubmitted extends AuthEvent {
  final String email;
  final String password;
  const LoginDetailsSubmitted({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}
