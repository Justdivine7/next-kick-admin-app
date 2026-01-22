import 'package:nextkick_admin/data/api_services/app_api_services.dart';
import 'package:nextkick_admin/data/models/fixture_model.dart';

class FixturesRepository {
  final AppApiClient _apiClient;

  const FixturesRepository(this._apiClient);

  Future<String> createFixture({
    required String firstTeam,
    required String secondTeam,
    required String date,
    required String time,
    required String venue,
    required String status,
  }) async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.post,
        path: '/admin_app/fixtures/create/',
        data: {
          'team_one': firstTeam,
          'team_two': secondTeam,
          'match_date': date,
          'match_time': time,
          'venue': venue,
          'status': status,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final message = response.data['message'];
        return message;
      } else {
        throw Exception("Couldn't create fixture");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<FixtureModel>> fetchAllFixtures() async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.get,
        path: '/admin_app/fixtures/',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final fixturesList = response.data['fixtures'] as List;
        return fixturesList
            .map((fixture) => FixtureModel.fromJson(fixture))
            .toList();
      } else {
        throw Exception("Couldn't fetch fixtures");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<FixtureModel> fetchSelectedFixture(String fixtureId) async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.get,
        path: '/admin_app/fixtures/$fixtureId/',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;

        final fixture = FixtureModel.fromJson(responseData);
        return fixture;
      } else {
        throw Exception("Couldn't fetch fixture");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<FixtureModel> updateSelectedFixture({
    required String fixtureId,
    required String matchDate,
    required String matchTime,
    required String venue,
    required String status,
    required int teamOneScore,
    required int teamTwoScore,
  }) async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.put,
        path: '/admin_app/fixtures/$fixtureId/',
        data: {
          'match_date': matchDate,
          'match_time': matchTime,
          'venue': venue,
          'status': status,
          'team_one_score': teamOneScore,
          'team_two_score': teamTwoScore,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;

        final fixture = FixtureModel.fromJson(responseData);
        return fixture;
      } else {
        throw Exception("Couldn't update fixture");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteSelectedFixture(String fixtureId) async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.delete,
        path: '/admin_app/fixtures/$fixtureId/',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // final message = response.data['message'];

        return;
      } else {
        throw Exception("Couldn't delete fixture");
      }
    } catch (error) {
      rethrow;
    }
  }
}
