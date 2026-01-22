import 'package:flutter/material.dart';
import 'package:nextkick_admin/common/utils/app_fade_navigator.dart';
import 'package:nextkick_admin/data/models/standing_model.dart';
import 'package:nextkick_admin/features/auth/view/login_view.dart';
import 'package:nextkick_admin/features/dashboard/view/dashboard_view.dart';
import 'package:nextkick_admin/features/drills/view/drill_submissions.dart';
import 'package:nextkick_admin/features/fixtures/views/update_fixture_view.dart';
import 'package:nextkick_admin/features/notifications/view/create_notifications_view.dart';
import 'package:nextkick_admin/features/player/view/manage_player_view.dart';
import 'package:nextkick_admin/features/player/view/player_profile_view.dart';
import 'package:nextkick_admin/features/registered_teams/view/registered_team_profile_view.dart';
import 'package:nextkick_admin/features/standings/view/create_standings_view.dart';
import 'package:nextkick_admin/features/standings/view/update_team_standing_view.dart';
import 'package:nextkick_admin/features/team/view/manage_team_view.dart';
import 'package:nextkick_admin/features/team/view/team_profile_view.dart';
import 'package:nextkick_admin/features/tournaments/view/create_tournament_view.dart';
import 'package:nextkick_admin/features/fixtures/views/create_fixtures_view.dart';
import 'package:nextkick_admin/features/fixtures/views/fixtures_list_view.dart';
import 'package:nextkick_admin/features/registered_teams/view/registered_teams_view.dart';
import 'package:nextkick_admin/features/standings/view/standings_view.dart';
import 'package:nextkick_admin/features/tournaments/view/tournaments_dashboard.dart';
import 'package:nextkick_admin/features/tournaments/view/tournaments_list_view.dart';
import 'package:nextkick_admin/main/app_splash_screen.dart';
import 'package:nextkick_admin/main/error_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppSplashScreen.routeName:
      return createFadeTransition(AppSplashScreen());

    case LoginView.routeName:
      return createFadeTransition(LoginView());
    case DashboardView.routeName:
      return createFadeTransition(DashboardView());
    case TournamentsDashboard.routeName:
      return createFadeTransition(TournamentsDashboard());
    case ManagePlayerView.routeName:
      return createFadeTransition(ManagePlayerView());
    case ManageTeamView.routeName:
      return createFadeTransition(ManageTeamView());
    case PlayerProfileView.routeName:
      return createFadeTransition(PlayerProfileView());
    case TeamProfileView.routeName:
      return createFadeTransition(TeamProfileView());
    case CreateTournamentView.routeName:
      return createFadeTransition(CreateTournamentView());
    case TournamentsListView.routeName:
      return createFadeTransition(TournamentsListView());
    case CreateFixturesView.routeName:
      return createFadeTransition(CreateFixturesView());
    case UpdateFixtureView.routeName:
      final args = settings.arguments as String;
      return createFadeTransition(UpdateFixtureView(fixtureId: args));
    case FixturesListView.routeName:
      return createFadeTransition(FixturesListView());
    case RegisteredTeamsView.routeName:
      return createFadeTransition(RegisteredTeamsView());
    case RegisteredTeamProfileView.routeName:
      final args = settings.arguments as Map<String, dynamic>;
      final teamId = args['teamId'] as String;

      return createFadeTransition(RegisteredTeamProfileView(teamId: teamId));
    case CreateStandingsView.routeName:
      return createFadeTransition(CreateStandingsView());
    case StandingsView.routeName:
      return createFadeTransition(StandingsView());
    case UpdateTeamStandingView.routeName:
      final standing = settings.arguments as StandingModel;
      return createFadeTransition(UpdateTeamStandingView(standing: standing));
    case CreateNotificationsView.routeName:
      return createFadeTransition(CreateNotificationsView());
    case DrillSubmissions.routeName:
      return createFadeTransition(DrillSubmissions());
    default:
      debugPrint('⚠️ Unknown route: ${settings.name}');
      return createFadeTransition(ErrorView());
  }
}
