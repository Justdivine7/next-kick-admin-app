import 'package:nextkick_admin/data/api_services/app_api_services.dart';
import 'package:nextkick_admin/data/models/player_model.dart';
import 'package:nextkick_admin/data/models/team_model.dart';

class UserManagementRepository {
  final AppApiClient _apiClient;
  const UserManagementRepository(this._apiClient);

  Future<List<dynamic>> fetchAllUsers({
    String? fullName,
    String? location,
    String? level,
    String? playerPosition,
    String? teamName,
    required String userType, // "player" or "team"
  }) async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.get,
        path: '/admin_app/admin/users/',
        query: {
          if (fullName?.isNotEmpty ?? false) 'full_name': fullName,
          if (location?.isNotEmpty ?? false) 'location': location,
          if (level?.isNotEmpty ?? false) 'level': level,
          if (teamName?.isNotEmpty ?? false) 'team_name': teamName,
          if (playerPosition?.isNotEmpty ?? false)
            'player_position': playerPosition,
          'user_type': userType,
        },
      );

      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        if (userType == 'player') {
          return results.map((e) => PlayerModel.fromJson(e)).toList();
        } else {
          return results.map((e) => TeamModel.fromJson(e)).toList();
        }
      } else {
        throw Exception("Couldn't fetch $userType list");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<int> fetchPlayersCount() async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.get,
        path: '/admin_app/admin/users/',
      );

      if (response.statusCode == 200) {
        final results = response.data['summary']['players_count'] as int;
        return results;
      } else {
        throw Exception("Couldn't fetch players count");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<int> fetchTeamsCount() async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.get,
        path: '/admin_app/admin/users/',
      );

      if (response.statusCode == 200) {
        final results = response.data['summary']['teams_count'] as int;
        return results;
      } else {
        throw Exception("Couldn't fetch teams count");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<int> fetchTotalUsersCount() async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.get,
        path: '/admin_app/admin/users/',
      );

      if (response.statusCode == 200) {
        final results = response.data['summary']['total_count'] as int;
        return results;
      } else {
        throw Exception("Couldn't fetch total count");
      }
    } catch (error) {
      rethrow;
    }
  }
}
