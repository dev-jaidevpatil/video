import 'package:flutter/material.dart';
import 'package:video/app_config.dart';
import 'package:video/media_library.dart';

class PlayerPlaceholder extends StatelessWidget {
  const PlayerPlaceholder({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.showLoader = false,
  });

  final IconData icon;
  final String title;
  final String message;
  final bool showLoader;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: AppColors.playerBackground),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screen),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showLoader)
                const SizedBox.square(
                  dimension: AppSizes.loadingIndicator,
                  child: CircularProgressIndicator(
                    strokeWidth: AppSizes.sliderTrackHeight,
                  ),
                )
              else
                Icon(
                  icon,
                  color: AppColors.iconMuted,
                  size: AppSizes.placeholderIcon,
                ),
              const SizedBox(height: AppSpacing.sectionGap),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: AppSpacing.compact),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.softText,
                      height: 1.35,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MusicSurface extends StatelessWidget {
  const MusicSurface({
    super.key,
    required this.media,
  });

  final MediaItem media;

  @override
  Widget build(BuildContext context) {
    final accent = Color(media.accentColor);

    return DecoratedBox(
      decoration: const BoxDecoration(color: AppColors.playerBackground),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screen),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppSizes.tileIconBox * 2,
                height: AppSizes.tileIconBox * 2,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(AppSizes.radius),
                  border: Border.all(color: accent.withValues(alpha: 0.5)),
                ),
                child: Icon(
                  Icons.music_note_rounded,
                  size: AppSizes.playIcon,
                  color: accent,
                ),
              ),
              const SizedBox(height: AppSpacing.sectionGap),
              Text(
                media.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: AppSpacing.compact),
              Text(
                media.description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.softText,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MediaListTile extends StatelessWidget {
  const MediaListTile({
    super.key,
    required this.media,
    required this.isSelected,
    required this.onTap,
  });

  final MediaItem media;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = Color(media.accentColor);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.tileGap),
      child: Material(
        color: isSelected ? AppColors.selectedSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radius),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.tilePadding),
            child: Row(
              children: [
                Container(
                  width: AppSizes.tileIconBox,
                  height: AppSizes.tileIconBox,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(AppSizes.radius),
                    border: Border.all(
                      color: accent.withValues(alpha: isSelected ? 0.9 : 0.35),
                    ),
                  ),
                  child: Icon(
                    isSelected
                        ? Icons.play_arrow_rounded
                        : media.isMusic
                            ? Icons.music_note_rounded
                            : Icons.movie_rounded,
                    color: accent,
                    size: AppSizes.tileIcon,
                  ),
                ),
                const SizedBox(width: AppSpacing.tilePadding),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              media.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.tileGap),
                          Text(
                            media.durationLabel,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.mutedText,
                                      fontWeight: FontWeight.w700,
                                    ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.small),
                      Text(
                        media.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.mutedText,
                              height: 1.3,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
