import 'package:nextkick_admin/data/api_services/app_api_services.dart';
import 'package:nextkick_admin/data/models/standing_model.dart';

class StandingsRepository {
  final AppApiClient _apiClient;
  const StandingsRepository(this._apiClient);

  Future<void> createStanding({
    required String teamName,
    required int teamPoint,
  }) async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.post,
        path: '/admin_app/standings/',
        requiresAuth: true,
        data: {'team': teamName, 'points': teamPoint},
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to create standing');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<StandingModel> updateStanding({
    required int teamPoint,
    required String teamId,
  }) async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.post,
        path: '/admin_app/standings/$teamId/update_points/',
        requiresAuth: true,
        data: {'points': teamPoint},
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final standing = StandingModel.fromJson(response.data);
        return standing;
      } else {
        throw Exception('Failed to update standing');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<StandingModel>> fetchStandings() async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.get,
        path: '/admin_app/standings/',
        requiresAuth: true,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data as List;
        final standing = responseData
            .map((st) => StandingModel.fromJson(st))
            .toList();
        return standing;
      } else {
        throw Exception('Failed to fetch standings');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<StandingModel> fetchStandingDetails({
    required String standingId,
  }) async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.get,
        path: '/admin_app/standings/$standingId/',
        requiresAuth: true,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final standing = StandingModel.fromJson(response.data);
        return standing;
      } else {
        throw Exception('Failed to update standing');
      }
    } catch (e) {
      rethrow;
    }
  }
}
