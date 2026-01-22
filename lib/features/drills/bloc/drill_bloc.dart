import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextkick_admin/data/api_services/app_api_services.dart';
import 'package:nextkick_admin/data/api_services/friendly_error.dart';
import 'package:nextkick_admin/data/models/player_drill_submission.dart';
import 'package:nextkick_admin/data/repositories/drill_repository.dart';

part 'drill_event.dart';
part 'drill_state.dart';

class DrillBloc extends Bloc<DrillEvent, DrillState> {
  static final List<PlayerDrillSubmission> cachedDrills = [];
  final DrillRepository drillRepo;
  final AppApiClient apiClient;

  DrillBloc({required this.drillRepo, required this.apiClient})
    : super(DrillInitial()) {
    on<FetchSubmittedDrills>(_onFetchSubmittedDrills);
    on<UpdateDrillStatus>(_onUpdateDrillStatus);
  }

  Future<void> _onFetchSubmittedDrills(
    FetchSubmittedDrills event,
    Emitter<DrillState> emit,
  ) async {
    emit(DrillLoading());

    try {
      final drills = await drillRepo.getPlayerDrills();
      cachedDrills
        ..clear()
        ..addAll(List.from(drills));
      emit(DrillLoaded(drills));
      debugPrint('cached drils: ${drills.length}');
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(DrillError(error: errorMessage));
    }
  }

  Future<void> _onUpdateDrillStatus(
    UpdateDrillStatus event,
    Emitter<DrillState> emit,
  ) async {
    emit(UpdateDrillStatusLoading(drills: cachedDrills));
    try {
      final message = await drillRepo.approveOrRejectDrill(
        id: event.id,
        status: event.status,
      );
      emit(UpdateDrillStatusSuccessful(message: message));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(UpdateDrillStatusError(error: errorMessage, drills: cachedDrills));
    }
  }
}
