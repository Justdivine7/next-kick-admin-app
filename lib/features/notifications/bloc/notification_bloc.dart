import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextkick_admin/data/api_services/app_api_services.dart';
import 'package:nextkick_admin/data/api_services/friendly_error.dart';
import 'package:nextkick_admin/data/repositories/notification_repository.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository notificationRepository;
  final AppApiClient apiClient;

  NotificationBloc({
    required this.notificationRepository,
    required this.apiClient,
  }) : super(NotificationInitial()) {
    on<CreateNotificationEvent>(_onCreateNotification);
  }

  Future<void> _onCreateNotification(
    CreateNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(CreateNotificationLoading());
    try {
      final success = await notificationRepository.createNotification(
        userType: event.userType,
        title: event.title,
        message: event.message,
      );
      if (success) {
        emit(CreateNotificationSuccessful());
      } else {
        emit(const CreateNotificationFailure('Failed to send notification'));
      }
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(CreateNotificationFailure(errorMessage));
    }
  }
}
