import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Player extends StatefulWidget {
  final mediaData;

  Player(this.mediaData);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    final uri = widget.mediaData['uri'];
    final format = videoFormatFromString(widget.mediaData['format']);
    DrmContext drmContext;

    if (widget.mediaData.containsKey('drm_scheme')) {
      Map<String, String> customProps;
      if (widget.mediaData.containsKey('drm_custom')) {
        customProps = Map<String, String>.from(widget.mediaData['drm_custom']);
      }
      drmContext = DrmContext(
          drmSchemeFromString(widget.mediaData['drm_scheme']),
          widget.mediaData['drm_license_url'],
          licenseType:
              drmLicenseTypeFromString(widget.mediaData['drm_license_type']),
          custom: customProps);
    }
    loadData(uri, format, drmContext);
  }

  DrmLicenseType drmLicenseTypeFromString(String drmLicenseType) {
    switch (drmLicenseType) {
      case 'titanium':
        return DrmLicenseType.titanium;
      default:
        return DrmLicenseType.unspecified;
    }
  }

  DrmScheme drmSchemeFromString(String drmScheme) {
    switch (drmScheme) {
      case 'widevine':
        return DrmScheme.widevine;
      case 'playready':
        return DrmScheme.playready;
      case 'fairplay':
        return DrmScheme.fairplay;
      default:
        return null;
    }
  }

  VideoFormat videoFormatFromString(String format) {
    switch (format) {
      case 'dash':
        return VideoFormat.dash;
      case 'hls':
        return VideoFormat.hls;
      case 'ss':
        return VideoFormat.ss;
      case 'other':
        return VideoFormat.other;
      default:
        return null;
    }
  }

  loadData(String uri, VideoFormat formatHint, DrmContext drmContext) async {
    _controller = VideoPlayerController.network(uri,
        formatHint: formatHint, drmContext: drmContext);
    try {
      await _controller.initialize();
    } catch (error) {
      debugPrint('Error initializing player: $error');
    }
    _controller.play();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return Container(color: Colors.black);
    }

    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: _controller.value.initialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
