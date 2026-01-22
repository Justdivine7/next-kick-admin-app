 import 'package:nextkick_admin/data/api_services/app_api_services.dart';
import 'package:nextkick_admin/data/local_storage/app_local_storage_service.dart';
import 'package:nextkick_admin/data/models/login_response.dart';

class AuthRepository {
  final AppApiClient _apiClient;
  final AppLocalStorageService _localStorage;

  AuthRepository({
    required AppApiClient apiClient,
    required AppLocalStorageService localStorage,
  }) : _apiClient = apiClient,
       _localStorage = localStorage;

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.post,
        path: '/api/login/',
        data: {'email': email, 'password': password},
        requiresAuth: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final loginResponse = LoginResponse.fromJson(data);

        await _localStorage.saveTokens(
          accessToken: data['tokens']['access'],
          refreshToken: data['tokens']['refresh'],
        );

        if (loginResponse.user != null) {
          await _localStorage.saveUserType(loginResponse.user!.userType ?? '');
          await _localStorage.saveAdminDetails(loginResponse.user!);
        }

        return loginResponse;
      } else {
        throw Exception('Unexpected response: ${response.statusCode}');
      }
    } catch (error) {
      rethrow;
    }
  }
}
