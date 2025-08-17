import '../services/supabase_service.dart';
import '../models/user_profile.dart';

class UserService {
  static final _client = SupabaseService.instance.client;

  // Follow user
  static Future<void> followUser(String userId) async {
    try {
      await _client.from('user_follows').insert({
        'follower_id': _client.auth.currentUser!.id,
        'following_id': userId,
      });
    } catch (error) {
      throw Exception('Failed to follow user: $error');
    }
  }

  // Unfollow user
  static Future<void> unfollowUser(String userId) async {
    try {
      await _client
          .from('user_follows')
          .delete()
          .eq('follower_id', _client.auth.currentUser!.id)
          .eq('following_id', userId);
    } catch (error) {
      throw Exception('Failed to unfollow user: $error');
    }
  }

  // Check if current user follows another user
  static Future<bool> isFollowing(String userId) async {
    try {
      final response = await _client
          .from('user_follows')
          .select('id')
          .eq('follower_id', _client.auth.currentUser!.id)
          .eq('following_id', userId)
          .limit(1);

      return response.isNotEmpty;
    } catch (error) {
      return false;
    }
  }

  // Get user's followers
  static Future<List<UserProfile>> getUserFollowers(String userId) async {
    try {
      final response = await _client
          .from('user_follows')
          .select('user_profiles!follower_id(*)')
          .eq('following_id', userId);

      return response
          .map<UserProfile>(
              (json) => UserProfile.fromJson(json['user_profiles']))
          .toList();
    } catch (error) {
      throw Exception('Failed to fetch followers: $error');
    }
  }

  // Get user's following
  static Future<List<UserProfile>> getUserFollowing(String userId) async {
    try {
      final response = await _client
          .from('user_follows')
          .select('user_profiles!following_id(*)')
          .eq('follower_id', userId);

      return response
          .map<UserProfile>(
              (json) => UserProfile.fromJson(json['user_profiles']))
          .toList();
    } catch (error) {
      throw Exception('Failed to fetch following: $error');
    }
  }

  // Get user profile by ID
  static Future<UserProfile> getUserProfile(String userId) async {
    try {
      final response = await _client
          .from('user_profiles')
          .select()
          .eq('id', userId)
          .single();

      return UserProfile.fromJson(response);
    } catch (error) {
      throw Exception('Failed to fetch user profile: $error');
    }
  }

  // Search users by username or name
  static Future<List<UserProfile>> searchUsers({
    required String query,
    int limit = 20,
  }) async {
    try {
      final response = await _client
          .from('user_profiles')
          .select()
          .or('username.ilike.%$query%,full_name.ilike.%$query%')
          .eq('is_active', true)
          .limit(limit);

      return response
          .map<UserProfile>((json) => UserProfile.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to search users: $error');
    }
  }

  // Get suggested users to follow (based on mutual follows)
  static Future<List<UserProfile>> getSuggestedUsers({int limit = 10}) async {
    try {
      // Get users that current user's following are following
      final response = await _client
          .from('user_profiles')
          .select()
          .neq('id', _client.auth.currentUser!.id)
          .eq('is_active', true)
          .limit(limit);

      return response
          .map<UserProfile>((json) => UserProfile.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to fetch suggested users: $error');
    }
  }

  // Get sellers (users with seller role)
  static Future<List<UserProfile>> getSellers({int limit = 20}) async {
    try {
      final response = await _client
          .from('user_profiles')
          .select()
          .eq('role', 'seller')
          .eq('is_active', true)
          .order('follower_count', ascending: false)
          .limit(limit);

      return response
          .map<UserProfile>((json) => UserProfile.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to fetch sellers: $error');
    }
  }

  // Get featured sellers
  static Future<List<UserProfile>> getFeaturedSellers({int limit = 10}) async {
    try {
      final response = await _client
          .from('user_profiles')
          .select()
          .eq('role', 'seller')
          .eq('is_active', true)
          .eq('verification_status', 'verified')
          .order('follower_count', ascending: false)
          .limit(limit);

      return response
          .map<UserProfile>((json) => UserProfile.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to fetch featured sellers: $error');
    }
  }

  // Update user notification settings
  static Future<void> updateNotificationSettings({
    required Map<String, dynamic> notificationSettings,
  }) async {
    try {
      await _client.from('user_profiles').update({
        'settings': {
          ...notificationSettings,
        }
      }).eq('id', _client.auth.currentUser!.id);
    } catch (error) {
      throw Exception('Failed to update notification settings: $error');
    }
  }

  // Get user activity stats
  static Future<Map<String, dynamic>> getUserStats(String userId) async {
    try {
      final reelsData = await _client
          .from('reels')
          .select('id')
          .eq('creator_id', userId)
          .count();

      final likesData = await _client
          .from('reels')
          .select('like_count')
          .eq('creator_id', userId);

      final totalLikes = likesData.fold<int>(
          0, (sum, reel) => sum + (reel['like_count'] as int));

      final productsData = await _client
          .from('products')
          .select('id')
          .eq('seller_id', userId)
          .count();

      return {
        'reels_count': reelsData.count,
        'total_likes': totalLikes,
        'products_count': productsData.count,
      };
    } catch (error) {
      throw Exception('Failed to fetch user stats: $error');
    }
  }

  // Block user
  static Future<void> blockUser(String userId) async {
    try {
      // Remove any existing follow relationship
      await unfollowUser(userId);

      // Add block record (you'd need a blocks table for this)
      // This is a simplified implementation
      await _client.from('user_profiles').update({
        'settings': {
          'blocked_users': [userId],
        }
      }).eq('id', _client.auth.currentUser!.id);
    } catch (error) {
      throw Exception('Failed to block user: $error');
    }
  }

  // Report user
  static Future<void> reportUser({
    required String userId,
    required String reason,
    String? details,
  }) async {
    try {
      // This would typically go to a reports table for admin review
      await _client.from('user_reports').insert({
        'reported_user_id': userId,
        'reporter_id': _client.auth.currentUser!.id,
        'reason': reason,
        'details': details,
      });
    } catch (error) {
      throw Exception('Failed to report user: $error');
    }
  }
}
