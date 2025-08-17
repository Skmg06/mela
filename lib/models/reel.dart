class Reel {
  final String id;
  final String creatorId;
  final String title;
  final String? description;
  final String videoUrl;
  final String? thumbnailUrl;
  final int? duration;
  final String status;
  final int viewCount;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final List<String> tags;
  final bool isPromoted;
  final double promotionBudget;
  final DateTime createdAt;
  final DateTime updatedAt;

  Reel({
    required this.id,
    required this.creatorId,
    required this.title,
    this.description,
    required this.videoUrl,
    this.thumbnailUrl,
    this.duration,
    required this.status,
    required this.viewCount,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.tags,
    required this.isPromoted,
    required this.promotionBudget,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Reel.fromJson(Map<String, dynamic> json) {
    return Reel(
      id: json['id'] as String,
      creatorId: json['creator_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      videoUrl: json['video_url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String?,
      duration: json['duration'] as int?,
      status: json['status'] as String,
      viewCount: json['view_count'] as int,
      likeCount: json['like_count'] as int,
      commentCount: json['comment_count'] as int,
      shareCount: json['share_count'] as int,
      tags: json['tags'] != null ? List<String>.from(json['tags'] as List) : [],
      isPromoted: json['is_promoted'] as bool,
      promotionBudget: (json['promotion_budget'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creator_id': creatorId,
      'title': title,
      'description': description,
      'video_url': videoUrl,
      'thumbnail_url': thumbnailUrl,
      'duration': duration,
      'status': status,
      'view_count': viewCount,
      'like_count': likeCount,
      'comment_count': commentCount,
      'share_count': shareCount,
      'tags': tags,
      'is_promoted': isPromoted,
      'promotion_budget': promotionBudget,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get formattedDuration {
    if (duration == null) return '';
    int minutes = duration! ~/ 60;
    int seconds = duration! % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get formattedViewCount {
    if (viewCount < 1000) return viewCount.toString();
    if (viewCount < 1000000) return '${(viewCount / 1000).toStringAsFixed(1)}K';
    return '${(viewCount / 1000000).toStringAsFixed(1)}M';
  }
}
