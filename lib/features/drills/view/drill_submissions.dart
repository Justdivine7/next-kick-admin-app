import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';
import 'package:nextkick_admin/common/widgets/animated_pulsing_image.dart';
import 'package:nextkick_admin/common/widgets/app_back_button.dart';
import 'package:nextkick_admin/common/widgets/app_button.dart';
import 'package:nextkick_admin/common/widgets/app_loading_overlay.dart';
import 'package:nextkick_admin/common/widgets/app_toast/app_toast.dart';
import 'package:nextkick_admin/common/widgets/dark_background.dart';
import 'package:nextkick_admin/common/widgets/error_and_reload_widget.dart';
import 'package:nextkick_admin/common/widgets/pull_to_refresh.dart';
import 'package:nextkick_admin/data/models/player_drill_submission.dart';
import 'package:nextkick_admin/features/drills/bloc/drill_bloc.dart';
import 'package:nextkick_admin/features/drills/view/video_webview_page.dart';
import 'package:nextkick_admin/utilities/constants/app_image_strings.dart';
import 'package:nextkick_admin/utilities/constants/app_text_strings.dart';
import 'package:nextkick_admin/utilities/constants/enums/toast_enum.dart';
import 'package:nextkick_admin/utilities/extensions/app_extensions.dart';
import 'package:nextkick_admin/utilities/helpers/ui_helpers.dart';

class DrillSubmissions extends StatefulWidget {
  static const routeName = '/drill-submissions';

  const DrillSubmissions({super.key});

  @override
  State<DrillSubmissions> createState() => _DrillSubmissionsState();
}

class _DrillSubmissionsState extends State<DrillSubmissions> {
  final TextEditingController _submissionController = TextEditingController();

  void _approveDrill(PlayerDrillSubmission drill) {
    context.read<DrillBloc>().add(
      UpdateDrillStatus(id: drill.id.toString(), status: 'approve'),
    );
  }

  void _rejectDrill(PlayerDrillSubmission drill) {
    context.read<DrillBloc>().add(
      UpdateDrillStatus(id: drill.id.toString(), status: 'reject'),
    );
  }

  Future<void> _refreshData() async {
    context.read<DrillBloc>().add(FetchSubmittedDrills());
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DrillBloc, DrillState>(
      listener: (context, drillState) {
        if (drillState is UpdateDrillStatusError) {
          AppToast.show(
            context,
            message: drillState.error,
            style: ToastStyle.error,
          );
        }
        if (drillState is UpdateDrillStatusSuccessful) {
          AppToast.show(
            context,
            message: drillState.message,
            style: ToastStyle.success,
          );
          context.read<DrillBloc>().add(FetchSubmittedDrills());
        }
      },
      builder: (context, drillState) {
        if (drillState is DrillLoading) {
          return Scaffold(
            backgroundColor: AppColors.blackColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leadingWidth: 80,
              toolbarHeight: 40,
              leading: AppBackButton(),
            ),
            body: Center(
              child: AnimatedPulsingImage(imagePath: AppImageStrings.manLogo),
            ),
          );
        }
        if (drillState is DrillError) {
          return Scaffold(
            backgroundColor: AppColors.blackColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leadingWidth: 80,
              toolbarHeight: 40,
              leading: const AppBackButton(),
            ),
            body: ErrorAndReloadWidget(
              errorTitle: 'Drills not found',
              errorDetails: 'Refresh the page to try again.',
              labelText: 'Retry',
              buttonPressed: () =>
                  context.read<DrillBloc>().add(FetchSubmittedDrills()),
            ),
          );
        }

        List<PlayerDrillSubmission> drills = [];
        if (drillState is DrillLoaded) {
          drills = drillState.drills;
        } else if (drillState is UpdateDrillStatusLoading) {
          drills = drillState.drills;
        } else if (drillState is UpdateDrillStatusError) {
          drills = drillState.drills;
        }

        if (drills.isEmpty) {
          return Scaffold(
            backgroundColor: AppColors.blackColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leadingWidth: 80,
              toolbarHeight: 40,
              leading: const AppBackButton(),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sports_soccer_rounded,
                    size: 45,
                    color: AppColors.whiteColor,
                  ),
                  SizedBox(height: 10),

                  Text(
                    'No drill submissions available',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: getScreenWidth(context, 0.3),
                    child: AppButton(
                      label: 'Retry',
                      backgroundColor: AppColors.whiteColor,
                      textColor: AppColors.blackColor,
                      onButtonPressed: () => _refreshData(),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // normal drill list handling continues below

        final scaffoldContent = Scaffold(
          backgroundColor: AppColors.blackColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: 80,
            toolbarHeight: 40,
            leading: AppBackButton(),
          ),
          body: DarkBackground(
            child: SafeArea(
              child: PullToRefresh(
                onRefresh: _refreshData,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        SizedBox(height: 16),

                        Text(
                          AppTextStrings.drillSubmissions,
                          style: context.textTheme.displayMedium?.copyWith(
                            color: AppColors.whiteColor,
                          ),
                        ),
                        SizedBox(height: 24),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: drills.length,
                          separatorBuilder: (_, _) => SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final player = drills[index];
                            return buildSubmissions(
                              context: context,
                              player: player,
                              textController: _submissionController,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        if (drillState is UpdateDrillStatusLoading) {
          return Stack(children: [scaffoldContent, AppLoadingOverlay()]);
        }
        return scaffoldContent;
      },
    );
  }

  Widget buildSubmissions({
    required BuildContext context,
    required PlayerDrillSubmission player,
    required TextEditingController textController,
  }) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            player.playerName?.capitalizeFirstLetter() ?? '',
            style: context.textTheme.bodyLarge?.copyWith(
              color: AppColors.whiteColor,
            ),
          ),
        ),
        SizedBox(height: 6),
        if (player.submissionLink != null && player.submissionLink!.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            VideoWebViewPage(url: player.submissionLink!),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.appBGColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      player.submissionLink!,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 6),
              InkWell(
                onTap: () async {
                  await Clipboard.setData(
                    ClipboardData(text: player.submissionLink!),
                  );

                  AppToast.show(
                    context,
                    message: 'link copied',
                    style: ToastStyle.success,
                  );
                },
                child: Icon(Icons.copy, size: 24, color: AppColors.appBGColor),
              ),
            ],
          ),
        SizedBox(height: 6),
        SizedBox(
          width: getScreenWidth(context, 0.55),
          child: Row(
            children: [
              Expanded(
                child: AppButton(
                  label: AppTextStrings.reject,
                  backgroundColor: AppColors.whiteColor,
                  textColor: AppColors.blackColor,
                  onButtonPressed: () => _rejectDrill(player),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: AppButton(
                  label: AppTextStrings.approve,
                  backgroundColor: AppColors.whiteColor,
                  textColor: AppColors.blackColor,
                  onButtonPressed: () => _approveDrill(player),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
