part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class CreateNotificationEvent extends NotificationEvent {
  final String userType;
  final String title;
  final String message;

  const CreateNotificationEvent({
    required this.userType,
    required this.title,
    required this.message,
  });

  @override
  List<Object?> get props => [userType, title, message];
}
