import 'package:flutter/material.dart';

class AppText {
  static const title = 'Media Studio';
  static const playlistTitle = 'Playlist';
  static const loadingTitle = 'Loading media';
  static const errorTitle = 'This media could not be loaded';
  static const errorMessage =
      'Pick another item or check your internet connection.';
}

class AppBreakpoints {
  static const wide = 720.0;
}

class AppSpacing {
  static const tiny = 2.0;
  static const small = 6.0;
  static const compact = 8.0;
  static const screen = 18.0;
  static const panelGap = 18.0;
  static const sectionGap = 16.0;
  static const controlGap = 14.0;
  static const tileGap = 10.0;
  static const tilePadding = 14.0;
}

class AppSizes {
  static const playlistWidth = 360.0;
  static const radius = 8.0;
  static const sliderTrackHeight = 3.0;
  static const sliderThumbRadius = 6.0;
  static const tileIconBox = 54.0;
  static const tileIcon = 30.0;
  static const playIcon = 76.0;
  static const loadingIndicator = 34.0;
  static const placeholderIcon = 42.0;
  static const videoAspectRatio = 16 / 9;
}

class AppDurations {
  static const playOverlayFade = Duration(milliseconds: 180);
}

class AppColors {
  static const seed = Color(0xFF2EC4B6);
  static const background = Color(0xFF0B0F17);
  static const surface = Color(0xFF101621);
  static const selectedSurface = Color(0xFF172033);
  static const playerBackground = Color(0xFF080A0F);
  static const border = Color(0xFF1E293B);
  static const mutedText = Color(0xFF9AA8B9);
  static const softText = Color(0xFF94A3B8);
  static const iconMuted = Color(0xFF8EA0B8);
  static const overlay = Colors.pink;
}
