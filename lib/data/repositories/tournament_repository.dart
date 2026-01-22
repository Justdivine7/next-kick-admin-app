import 'package:nextkick_admin/data/api_services/app_api_services.dart';
import 'package:nextkick_admin/data/models/registered_team_model.dart';
import 'package:nextkick_admin/data/models/tournament_model.dart';

class TournamentRepository {
  final AppApiClient _apiClient;
  const TournamentRepository(this._apiClient);

  Future<String> createTournament({
    required String title,
    required String description,
    required String location,
  }) async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.post,
        path: '/admin_app/tournaments/upload/',
        data: {
          'title': title,
          'description': description,
          'location': location,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final message = response.data['message'];
        return message;
      } else {
        throw Exception('Failed to create tournament');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<TournamentModel>> fetchAllTournaments() async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.get,
        path: '/admin_app/tournaments/',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final tournaments = response.data['results'] as List;

        return tournaments.map((t) => TournamentModel.fromJson(t)).toList();
      } else {
        throw Exception('Failed to fetch tournaments');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<RegisteredTeamModel>> getRegisteredTeams() async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.get,
        path: '/admin_app/admin/registrations/',
        requiresAuth: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data as List;
        final registeredTeams = responseData
            .map((teams) => RegisteredTeamModel.fromJson(teams))
            .toList();
        return registeredTeams;
      } else {
        throw Exception('Failed to fetch registered teams');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateRegisteredTeam({
    required String id,
    required String teamName,
    required String teamLocation,
    required String noOfPlayers,
    required String amount,
  }) async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.patch,
        path: "/admin_app/admin/registrations/$id/",
        requiresAuth: true,
        data: {
          'team_name': teamName,
          'team_location': teamLocation,
          'number_of_players': noOfPlayers,
          'amount': amount,
          'is_paid': true,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw Exception('Failed to fetch registered teams');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<RegisteredTeamModel> getRegisteredTeamDetails(String teamId) async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.get,
        path: '/admin_app/admin/registrations/$teamId',
        requiresAuth: true,
        // data: {'id': teamId},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        final registeredTeams = RegisteredTeamModel.fromJson(responseData);

        return registeredTeams;
      } else {
        throw Exception('Failed to fetch registered teams');
      }
    } catch (error) {
      rethrow;
    }
  }
}
