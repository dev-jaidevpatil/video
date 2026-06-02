import 'package:flutter/material.dart';
import 'package:video/app_config.dart';
import 'package:video/functions.dart';
import 'package:video/media_library.dart';
import 'package:video/widgets.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppText.title,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.seed,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: AppColors.background,
        sliderTheme: const SliderThemeData(
          trackHeight: AppSizes.sliderTrackHeight,
          thumbShape: RoundSliderThumbShape(
            enabledThumbRadius: AppSizes.sliderThumbRadius,
          ),
        ),
      ),
      home: const MyHomePage(title: AppText.title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  VideoPlayerController? _controller;
  int _selectedIndex = 0;
  bool _isLoading = true;
  bool _hasError = false;
  bool _isMuted = false;

  MediaItem get _selectedMedia => mediaLibrary[_selectedIndex];

  @override
  void initState() {
    super.initState();
    _loadMedia(0);
  }

  @override
  void dispose() {
    _controller?.removeListener(_onMediaChanged);
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _loadMedia(int index) async {
    setState(() {
      _selectedIndex = index;
      _isLoading = true;
      _hasError = false;
    });

    final oldController = _controller;
    oldController?.removeListener(_onMediaChanged);
    _controller = null;
    await oldController?.dispose();

    final media = mediaLibrary[index];
    final nextController = _createController(media);

    try {
      await nextController.initialize();
      await nextController.setLooping(false);
      await nextController.setVolume(_isMuted ? 0 : 1);
      nextController.addListener(_onMediaChanged);

      if (!mounted) {
        await nextController.dispose();
        return;
      }

      setState(() {
        _controller = nextController;
        _isLoading = false;
      });
      await nextController.play();
    } catch (_) {
      await nextController.dispose();
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  VideoPlayerController _createController(MediaItem media) {
    final options = VideoPlayerOptions(mixWithOthers: true);

    return switch (media.sourceType) {
      MediaSource.network => VideoPlayerController.networkUrl(
        Uri.parse(media.source),
        videoPlayerOptions: options,
      ),
      MediaSource.asset => VideoPlayerController.asset(
        media.source,
        videoPlayerOptions: options,
      ),
    };
  }

  void _onMediaChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _togglePlay() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (controller.value.isPlaying) {
      await controller.pause();
    } else {
      await controller.play();
    }
  }

  Future<void> _toggleSound() async {
    final controller = _controller;
    final muted = !_isMuted;

    setState(() {
      _isMuted = muted;
    });

    if (controller != null && controller.value.isInitialized) {
      await controller.setVolume(muted ? 0 : 1);
    }
  }

  Future<void> _seekTo(double value) async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    await controller.seekTo(Duration(milliseconds: value.round()));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width >= AppBreakpoints.wide;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screen),
          child:
              isWide
                  ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 7, child: _buildPlayerArea()),
                      const SizedBox(width: AppSpacing.panelGap),
                      SizedBox(
                        width: AppSizes.playlistWidth,
                        child: _buildPlaylist(),
                      ),
                    ],
                  )
                  : Column(
                    children: [
                      _buildPlayerArea(),
                      const SizedBox(height: AppSpacing.panelGap),
                      Expanded(child: _buildPlaylist()),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget _buildPlayerArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.small),
        Text(
          _selectedMedia.title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.mutedText,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radius),
          child: AspectRatio(
            aspectRatio: AppSizes.videoAspectRatio,
            child: _buildMediaSurface(),
          ),
        ),
        const SizedBox(height: AppSpacing.controlGap),
        _buildControls(),
      ],
    );
  }

  Widget _buildMediaSurface() {
    final controller = _controller;

    if (_isLoading) {
      return PlayerPlaceholder(
        icon: Icons.hourglass_empty_rounded,
        title: AppText.loadingTitle,
        message: _selectedMedia.source,
        showLoader: true,
      );
    }

    if (_hasError || controller == null || !controller.value.isInitialized) {
      return const PlayerPlaceholder(
        icon: Icons.error_outline_rounded,
        title: AppText.errorTitle,
        message: AppText.errorMessage,
      );
    }

    if (_selectedMedia.isMusic) {
      return MusicSurface(media: _selectedMedia);
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(
          color: Colors.black,
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: controller.value.size.width,
              height: controller.value.size.height,
              child: VideoPlayer(controller),
            ),
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _togglePlay,
              child: AnimatedOpacity(
                opacity: controller.value.isPlaying ? 0 : 1,
                duration: AppDurations.playOverlayFade,
                child: Container(
                  color: AppColors.overlay,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.play_circle_fill_rounded,
                    size: AppSizes.playIcon,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControls() {
    final controller = _controller;
    final value = controller?.value;
    final isReady = value?.isInitialized ?? false;
    final position = isReady ? value!.position : Duration.zero;
    final duration = isReady ? value!.duration : Duration.zero;
    final max =
        duration.inMilliseconds.toDouble().clamp(1, double.infinity).toDouble();
    final progress =
        position.inMilliseconds.toDouble().clamp(0, max).toDouble();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.controlGap,
          AppSpacing.tileGap,
          AppSpacing.controlGap,
          AppSpacing.controlGap,
        ),
        child: Column(
          children: [
            Row(
              children: [
                IconButton.filledTonal(
                  tooltip: isReady && value!.isPlaying ? 'Pause' : 'Play',
                  onPressed: isReady ? _togglePlay : null,
                  icon: Icon(
                    isReady && value!.isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                  ),
                ),
                const SizedBox(width: AppSpacing.tileGap),
                IconButton(
                  tooltip: _isMuted ? 'Unmute' : 'Mute',
                  onPressed: isReady ? _toggleSound : null,
                  icon: Icon(
                    _isMuted
                        ? Icons.volume_off_rounded
                        : Icons.volume_up_rounded,
                  ),
                ),
                const SizedBox(width: AppSizes.radius),
                Expanded(
                  child: Slider(
                    min: 0,
                    max: max,
                    value: progress,
                    onChanged: isReady ? _seekTo : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.tiny),
            Row(
              children: [
                Text(formatDuration(position), style: _timeStyle(context)),
                const Spacer(),
                Text(formatDuration(duration), style: _timeStyle(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextStyle? _timeStyle(BuildContext context) {
    return Theme.of(context).textTheme.labelMedium?.copyWith(
      color: AppColors.mutedText,
      fontWeight: FontWeight.w700,
    );
  }

  Widget _buildPlaylist() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              AppText.playlistTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Spacer(),
            Text(
              '${mediaLibrary.length} items',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.mutedText,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.controlGap),
        Expanded(
          child: ListView.builder(
            itemCount: mediaLibrary.length,
            itemBuilder: (context, index) {
              return MediaListTile(
                media: mediaLibrary[index],
                isSelected: index == _selectedIndex,
                onTap: () => _loadMedia(index),
              );
            },
          ),
        ),
      ],
    );
  }
}
