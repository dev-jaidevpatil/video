import 'package:flutter/material.dart';
import 'package:video/functions.dart';
import 'package:video/globals.dart';
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
      title: 'Video Studio',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2EC4B6),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0B0F17),
        sliderTheme: const SliderThemeData(
          trackHeight: 3,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
        ),
      ),
      home: const MyHomePage(title: 'Video Studio'),
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

  VideoItem get _selectedVideo => videos[_selectedIndex];

  @override
  void initState() {
    super.initState();
    _loadVideo(0);
  }

  @override
  void dispose() {
    _controller?.removeListener(_onVideoChanged);
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _loadVideo(int index) async {
    setState(() {
      _selectedIndex = index;
      _isLoading = true;
      _hasError = false;
    });

    final oldController = _controller;
    oldController?.removeListener(_onVideoChanged);
    _controller = null;
    await oldController?.dispose();

    final nextController = VideoPlayerController.networkUrl(
      Uri.parse(videos[index].url),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    try {
      await nextController.initialize();
      await nextController.setLooping(false);
      await nextController.setVolume(_isMuted ? 0 : 1);
      nextController.addListener(_onVideoChanged);

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

  void _onVideoChanged() {
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
    final isWide = size.width >= 840;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 7, child: _buildPlayerArea()),
                    const SizedBox(width: 18),
                    SizedBox(width: 360, child: _buildPlaylist()),
                  ],
                )
              : Column(
                  children: [
                    _buildPlayerArea(),
                    const SizedBox(height: 18),
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
        const SizedBox(height: 6),
        Text(
          _selectedVideo.title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF9AA8B9),
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: _buildVideoSurface(),
          ),
        ),
        const SizedBox(height: 14),
        _buildControls(),
      ],
    );
  }

  Widget _buildVideoSurface() {
    final controller = _controller;

    if (_isLoading) {
      return PlayerPlaceholder(
        icon: Icons.hourglass_empty_rounded,
        title: 'Loading video',
        message: _selectedVideo.url,
        showLoader: true,
      );
    }

    if (_hasError || controller == null || !controller.value.isInitialized) {
      return const PlayerPlaceholder(
        icon: Icons.error_outline_rounded,
        title: 'This video could not be loaded',
        message: 'Pick another item or check your internet connection.',
      );
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
                duration: const Duration(milliseconds: 180),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.28),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.play_circle_fill_rounded,
                    size: 76,
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
    final max = duration.inMilliseconds
        .toDouble()
        .clamp(1, double.infinity)
        .toDouble();
    final progress = position.inMilliseconds.toDouble().clamp(0, max).toDouble();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF101621),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
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
                const SizedBox(width: 10),
                IconButton(
                  tooltip: _isMuted ? 'Unmute' : 'Mute',
                  onPressed: isReady ? _toggleSound : null,
                  icon: Icon(
                    _isMuted
                        ? Icons.volume_off_rounded
                        : Icons.volume_up_rounded,
                  ),
                ),
                const SizedBox(width: 8),
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
            const SizedBox(height: 2),
            Row(
              children: [
                Text(
                  formatDuration(position),
                  style: _timeStyle(context),
                ),
                const Spacer(),
                Text(
                  formatDuration(duration),
                  style: _timeStyle(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextStyle? _timeStyle(BuildContext context) {
    return Theme.of(context).textTheme.labelMedium?.copyWith(
          color: const Color(0xFF9AA8B9),
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
              'Playlist',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const Spacer(),
            Text(
              '${videos.length} videos',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF9AA8B9),
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              return VideoListTile(
                video: videos[index],
                index: index,
                isSelected: index == _selectedIndex,
                onTap: () => _loadVideo(index),
              );
            },
          ),
        ),
      ],
    );
  }
}
