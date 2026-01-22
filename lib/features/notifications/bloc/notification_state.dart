part of 'notification_bloc.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

final class NotificationInitial extends NotificationState {}

final class CreateNotificationLoading extends NotificationState {}

final class CreateNotificationSuccessful extends NotificationState {
  final String message;

  const CreateNotificationSuccessful({
    this.message = 'Notification sent successfully!',
  });

  @override
  List<Object?> get props => [message];
}

final class CreateNotificationFailure extends NotificationState {
  final String error;

  const CreateNotificationFailure(this.error);

  @override
  List<Object?> get props => [error];
}
