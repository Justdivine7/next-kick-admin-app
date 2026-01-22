import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import 'package:nextkick_admin/data/api_services/app_api_services.dart';
import 'package:nextkick_admin/data/models/player_drill_submission.dart';

class DrillRepository {
  final AppApiClient _apiClient;
  DrillRepository(this._apiClient);

  Future<List<PlayerDrillSubmission>> getPlayerDrills() async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.get,
        path: '/admin_app/submitted-drills/',
        requiresAuth: true,
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as List;
        return data
            .map((drill) => PlayerDrillSubmission.fromJson(drill))
            .toList();
      } else {
        throw Exception('Failed to load drills');
      }
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  Future<String> approveOrRejectDrill({
    required String id,
    required String status,
  }) async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.post,
        path: '/admin_app/drills/approve/$id/',
        requiresAuth: true,
        data: {'action': status},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final message = response.data['message'];
        return message;
      } else {
        throw Exception('Failed to approve or reject drills');
      }
    } catch (error) {
      rethrow;
    }
  }
}
