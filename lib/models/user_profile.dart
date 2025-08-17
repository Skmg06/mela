class UserProfile {
  final String id;
  final String email;
  final String fullName;
  final String? username;
  final String role;
  final String? avatarUrl;
  final String? bio;
  final String? phone;
  final bool isActive;
  final String verificationStatus;
  final String? businessName;
  final String? businessAddress;
  final int followerCount;
  final int followingCount;
  final Map<String, dynamic> settings;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.email,
    required this.fullName,
    this.username,
    required this.role,
    this.avatarUrl,
    this.bio,
    this.phone,
    required this.isActive,
    required this.verificationStatus,
    this.businessName,
    this.businessAddress,
    required this.followerCount,
    required this.followingCount,
    required this.settings,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      username: json['username'] as String?,
      role: json['role'] as String,
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,
      phone: json['phone'] as String?,
      isActive: json['is_active'] as bool,
      verificationStatus: json['verification_status'] as String,
      businessName: json['business_name'] as String?,
      businessAddress: json['business_address'] as String?,
      followerCount: json['follower_count'] as int,
      followingCount: json['following_count'] as int,
      settings: json['settings'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'username': username,
      'role': role,
      'avatar_url': avatarUrl,
      'bio': bio,
      'phone': phone,
      'is_active': isActive,
      'verification_status': verificationStatus,
      'business_name': businessName,
      'business_address': businessAddress,
      'follower_count': followerCount,
      'following_count': followingCount,
      'settings': settings,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? id,
    String? email,
    String? fullName,
    String? username,
    String? role,
    String? avatarUrl,
    String? bio,
    String? phone,
    bool? isActive,
    String? verificationStatus,
    String? businessName,
    String? businessAddress,
    int? followerCount,
    int? followingCount,
    Map<String, dynamic>? settings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      phone: phone ?? this.phone,
      isActive: isActive ?? this.isActive,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      businessName: businessName ?? this.businessName,
      businessAddress: businessAddress ?? this.businessAddress,
      followerCount: followerCount ?? this.followerCount,
      followingCount: followingCount ?? this.followingCount,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
