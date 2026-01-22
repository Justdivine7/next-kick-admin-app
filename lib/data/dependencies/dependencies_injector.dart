import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nextkick_admin/data/api_services/app_api_services.dart';
import 'package:nextkick_admin/data/local_storage/app_local_storage_service.dart';
import 'package:nextkick_admin/data/repositories/auth_repository.dart';
import 'package:nextkick_admin/data/repositories/drill_repository.dart';
import 'package:nextkick_admin/data/repositories/fixtures_repository.dart';
import 'package:nextkick_admin/data/repositories/notification_repository.dart';
import 'package:nextkick_admin/data/repositories/standings_repository.dart';
import 'package:nextkick_admin/data/repositories/tournament_repository.dart';
import 'package:nextkick_admin/data/repositories/user_management_repository.dart';
import 'package:nextkick_admin/features/auth/bloc/auth_bloc.dart';
import 'package:nextkick_admin/features/dashboard/bloc/player/player_bloc.dart';
import 'package:nextkick_admin/features/dashboard/bloc/team/team_bloc.dart';
import 'package:nextkick_admin/features/drills/bloc/drill_bloc.dart';
import 'package:nextkick_admin/features/fixtures/bloc/fixtures_bloc.dart';
import 'package:nextkick_admin/features/notifications/bloc/notification_bloc.dart';
import 'package:nextkick_admin/features/standings/bloc/standings_bloc.dart';
import 'package:nextkick_admin/features/tournaments/bloc/tournament_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerLazySingleton<Dio>(() => Dio());

  // API CLIENTS
  getIt.registerLazySingleton<AppApiClient>(
    () => AppApiClient(getIt<Dio>(), getIt<AppLocalStorageService>()),
  );

  // LOCAL STORAGE
  await GetStorage.init();
  getIt.registerLazySingleton<GetStorage>(() => GetStorage());
  getIt.registerLazySingleton<AppLocalStorageService>(
    () => AppLocalStorageService(getIt<GetStorage>()),
  );

  // REPOSITORIES

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      apiClient: getIt<AppApiClient>(),
      localStorage: getIt<AppLocalStorageService>(),
    ),
  );
  getIt.registerLazySingleton<DrillRepository>(
    () => DrillRepository(getIt<AppApiClient>()),
  );
  getIt.registerLazySingleton<TournamentRepository>(
    () => TournamentRepository(getIt<AppApiClient>()),
  );
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepository(getIt<AppApiClient>()),
  );
  getIt.registerLazySingleton<FixturesRepository>(
    () => FixturesRepository(getIt<AppApiClient>()),
  );
  getIt.registerLazySingleton<UserManagementRepository>(
    () => UserManagementRepository(getIt<AppApiClient>()),
  );
  getIt.registerLazySingleton<StandingsRepository>(
    () => StandingsRepository(getIt<AppApiClient>()),
  );

  // BLOCS

  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<AuthRepository>()));
  getIt.registerFactory<DrillBloc>(
    () => DrillBloc(
      apiClient: getIt<AppApiClient>(),
      drillRepo: getIt<DrillRepository>(),
    ),
  );
  getIt.registerFactory<TournamentBloc>(
    () => TournamentBloc(getIt<TournamentRepository>(), getIt<AppApiClient>()),
  );
  getIt.registerFactory<NotificationBloc>(
    () => NotificationBloc(
      notificationRepository: getIt<NotificationRepository>(),
      apiClient: getIt<AppApiClient>(),
    ),
  );
  getIt.registerFactory<FixturesBloc>(
    () => FixturesBloc(fixtureRepository: getIt<FixturesRepository>()),
  );
  getIt.registerFactory<PlayerBloc>(
    () => PlayerBloc(getIt<UserManagementRepository>()),
  );
  getIt.registerFactory<TeamBloc>(
    () => TeamBloc(getIt<UserManagementRepository>()),
  );
  getIt.registerFactory<StandingsBloc>(
    () => StandingsBloc(getIt<StandingsRepository>()),
  );
}
