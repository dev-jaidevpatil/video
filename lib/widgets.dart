import 'package:flutter/material.dart';
import 'package:video/globals.dart';

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
      decoration: const BoxDecoration(
        color: Color(0xFF080A0F),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showLoader)
                const SizedBox.square(
                  dimension: 34,
                  child: CircularProgressIndicator(strokeWidth: 3),
                )
              else
                Icon(icon, color: const Color(0xFF8EA0B8), size: 42),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF94A3B8),
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

class VideoListTile extends StatelessWidget {
  const VideoListTile({
    super.key,
    required this.video,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  final VideoItem video;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = Color(video.accentColor);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: isSelected ? const Color(0xFF172033) : const Color(0xFF101621),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: accent.withValues(alpha: isSelected ? 0.9 : 0.35),
                    ),
                  ),
                  child: Icon(
                    isSelected ? Icons.play_arrow_rounded : Icons.movie_rounded,
                    color: accent,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              video.title,
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
                          const SizedBox(width: 10),
                          Text(
                            video.duration,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: const Color(0xFF9AA8B9),
                                      fontWeight: FontWeight.w700,
                                    ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        video.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF9AA8B9),
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
