import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';
import 'package:nextkick_admin/utilities/constants/enums/shimmer_enum.dart';
import 'package:nextkick_admin/utilities/helpers/ui_helpers.dart';

class ShimmerLoadingOverlay extends StatefulWidget {
  final ShimmerEnum pageType;
  final bool isDarkMode;
  final int itemCount;
  const ShimmerLoadingOverlay({
    super.key,
    required this.pageType,
    this.isDarkMode = false,
    this.itemCount = 12,
  });

  @override
  State<ShimmerLoadingOverlay> createState() => _ShimmerLoadingOverlayState();
}

class _ShimmerLoadingOverlayState extends State<ShimmerLoadingOverlay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      color: widget.isDarkMode ? Color(0xff181818) : AppColors.blackColor,
      child: _buildShimmerLayout(),
    );
  }

  Widget _buildShimmerLayout() {
    switch (widget.pageType) {
      case ShimmerEnum.submittedDrills:
        return _buildSubmittedDrills();
      case ShimmerEnum.tournaments:
        return _buildTournamentsShimmer();
      case ShimmerEnum.fixtures:
        return _buildFixturesShimmer();
      case ShimmerEnum.registeredTeams:
        return _buildRegisteredTeamsShimmer();
    }
  }

  Widget _buildSubmittedDrills() {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final delay = index * 300;
        return Column(
          children: [
            _buildShimmerBox(100, 30, delay),
            SizedBox(height: 6),
            _buildShimmerBox(double.infinity, 60, delay),
            SizedBox(
              width: getScreenWidth(context, 0.55),
              child: Row(
                children: [
                  Expanded(child: _buildShimmerBox(double.infinity, 50, delay)),
                  SizedBox(width: 10),
                  Expanded(child: _buildShimmerBox(double.infinity, 50, delay)),
                ],
              ),
            ),
          ],
        );
      },
      separatorBuilder: (_, _) => SizedBox(height: 16),
      itemCount: 6,
    );
  }

  Widget _buildTournamentsShimmer() {
    return ListView.separated(
      itemCount: 10,
      separatorBuilder: (_, _) => SizedBox(height: 12),
      itemBuilder: (context, index) {
        final delay = index * 300;

        return _buildShimmerBox(double.infinity, 40, delay);
      },
    );
  }

  Widget _buildFixturesShimmer() {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),

      itemCount: 8,
      separatorBuilder: (_, _) => SizedBox(height: 16),
      itemBuilder: (context, index) {
        final delay = index * 300;
        return Row(
          children: [
            Expanded(child: _buildShimmerBox(double.infinity, 70, delay)),
            SizedBox(width: 10),
            _buildShimmerCircle(30, delay),
            SizedBox(width: 10),
            Expanded(child: _buildShimmerBox(double.infinity, 70, delay)),
          ],
        );
      },
    );
  }

  Widget _buildRegisteredTeamsShimmer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.separated(
          separatorBuilder: (_, _) => SizedBox(height: 20),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 8,
          itemBuilder: (context, index) {
            return _buildShimmerBox(double.infinity, 70, index * 300);
          },
        ),
      ],
    );
  }

  Widget _buildShimmerBox(
    double width,
    double height,
    int delay, {
    double radius = 4,
  }) {
    return FadeShimmer(
      width: width,
      height: height,
      radius: radius,
      millisecondsDelay: delay,
      fadeTheme: widget.isDarkMode ? FadeTheme.dark : FadeTheme.light,
    );
  }

  Widget _buildShimmerCircle(double size, int delay) {
    return FadeShimmer.round(
      size: size,
      fadeTheme: widget.isDarkMode ? FadeTheme.dark : FadeTheme.light,
      millisecondsDelay: delay,
    );
  }
}
