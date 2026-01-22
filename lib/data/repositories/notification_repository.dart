import 'package:nextkick_admin/data/api_services/app_api_services.dart';

class NotificationRepository {
  final AppApiClient _apiClient;
  const NotificationRepository(this._apiClient);

  Future<bool> createNotification({
    required String userType,
    required String title,
    required String message,
  }) async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.post,
        path: '/admin_app/send-notification/',
        data: {'user_type': userType, 'title': title, 'message': message},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final notificationStatus = response.data['success'];
        return notificationStatus;
      } else {
        return false;
      }
    } catch (error) {
      rethrow;
    }
  }
}
