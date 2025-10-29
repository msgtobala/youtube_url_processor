import 'api/yt_data_api.dart';
import 'models/entities.dart';

class EnrichedVideoInfo {
  final VideoRef reference;
  final bool isLive;
  final bool isUpcoming;
  final Duration? duration;

  const EnrichedVideoInfo({
    required this.reference,
    this.isLive = false,
    this.isUpcoming = false,
    this.duration,
  });
}

class YouTubeInspector {
  final YouTubeDataApi api;

  const YouTubeInspector({required this.api});

  Future<EnrichedVideoInfo> inspectVideo(VideoRef ref) async {
    final v = await api.getVideo(ref.videoId);
    return EnrichedVideoInfo(
      reference: ref,
      isLive: v.isLive,
      isUpcoming: v.isUpcoming,
      duration: v.duration,
    );
  }
}


