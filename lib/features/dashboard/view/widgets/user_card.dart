import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';
import 'package:nextkick_admin/data/models/player_model.dart';
import 'package:nextkick_admin/data/models/team_model.dart';
import 'package:nextkick_admin/utilities/extensions/app_extensions.dart';

class EntityCard<T> extends StatelessWidget {
  final T entity;
  final VoidCallback? onTap;

  const EntityCard({super.key, required this.entity, this.onTap});

  @override
  Widget build(BuildContext context) {
    String name = '';
    String? subtitle;
    String? extraInfo;
    String? imageUrl;

    // Determine fields based on type
    if (entity is PlayerModel) {
      final player = entity as PlayerModel;
      name = player.fullName;
      imageUrl = player.profile.profilePicture;
      subtitle =
          "${player.profile.playerPosition.capitalizeFirstLetter()} • ${player.profile.country}";
      extraInfo = "Level: ${player.profile.activeBundle}";
    } else if (entity is TeamModel) {
      final team = entity as TeamModel;
      name = team.profile.teamName;
      subtitle = team.profile.location;
      //  imageUrl = team.logoUrl;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: AppColors.subTextcolor,
              child: ClipOval(
                child: imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator.adaptive(
                              strokeWidth: 2,
                              backgroundColor: AppColors.appBGColor,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.person,
                          color: AppColors.blackColor.withOpacity(0.7),
                        ),
                      )
                    : Icon(
                        Icons.person,
                        color: AppColors.blackColor.withOpacity(0.7),
                      ),
              ),
            ),

            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.capitalizeFirstLetter(),
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: AppColors.boldTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.boldTextColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                  if (extraInfo != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      extraInfo,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: AppColors.boldTextColor.withOpacity(0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}
