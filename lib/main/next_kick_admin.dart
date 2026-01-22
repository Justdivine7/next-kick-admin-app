import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextkick_admin/data/dependencies/dependencies_injector.dart';
import 'package:nextkick_admin/data/routes/app_route.dart';
import 'package:nextkick_admin/features/auth/bloc/auth_bloc.dart';
import 'package:nextkick_admin/features/dashboard/bloc/player/player_bloc.dart';
import 'package:nextkick_admin/features/dashboard/bloc/team/team_bloc.dart';
import 'package:nextkick_admin/features/drills/bloc/drill_bloc.dart';
import 'package:nextkick_admin/features/fixtures/bloc/fixtures_bloc.dart';
import 'package:nextkick_admin/features/notifications/bloc/notification_bloc.dart';
import 'package:nextkick_admin/features/standings/bloc/standings_bloc.dart';
import 'package:nextkick_admin/features/tournaments/bloc/tournament_bloc.dart';
import 'package:nextkick_admin/main/app_splash_screen.dart';
import 'package:nextkick_admin/utilities/theme/app_theme_service.dart';

class NextKickAdmin extends StatelessWidget {
  const NextKickAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthBloc>()),
        BlocProvider(create: (context) => getIt<DrillBloc>()),
        BlocProvider(create: (context) => getIt<TournamentBloc>()),
        BlocProvider(create: (context) => getIt<NotificationBloc>()),
        BlocProvider(create: (context) => getIt<FixturesBloc>()),
        BlocProvider(
          create: (context) =>
              getIt<PlayerBloc>()..add(FetchPlayersCount(forceRefresh: true)),
        ),
        BlocProvider(
          create: (context) =>
              getIt<TeamBloc>()..add(FetchTeamCount(forceRefresh: true)),
        ),
        BlocProvider(create: (context) => getIt<StandingsBloc>()),
      ],
      child: AppWithProviders(),
    );
  }
}

class AppWithProviders extends StatelessWidget {
  const AppWithProviders({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nextkick Admin',
      theme: AppThemeService().lighttheme,
      darkTheme: AppThemeService().darkTheme,
      initialRoute: AppSplashScreen.routeName,
      onGenerateRoute: (settings) => generateRoute(settings),
    );
  }
}
