 import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 import 'package:nextkick_admin/data/api_services/friendly_error.dart';
import 'package:nextkick_admin/data/models/login_response.dart';
import 'package:nextkick_admin/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;
 
  AuthBloc(  this._repository) : super(AuthInitial()) {
    on<LoginDetailsSubmitted>(_onLoginDetailsSubmitted);
  }

  Future<void> _onLoginDetailsSubmitted(
    LoginDetailsSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final result = await _repository.login(
        email: event.email,
        password: event.password,
      );
      emit(LoginSuccessful(user: result));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(LoginFailure(error: errorMessage));
    }
  }
}
