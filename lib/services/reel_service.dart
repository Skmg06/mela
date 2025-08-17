import '../services/supabase_service.dart';
import '../models/reel.dart';

class ReelService {
  static final _client = SupabaseService.instance.client;

  // Get published reels with pagination (infinite scroll)
  static Future<List<Reel>> getReels({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await _client
          .from('reels')
          .select('*, user_profiles!creator_id(username, avatar_url)')
          .eq('status', 'published')
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return response.map<Reel>((json) => Reel.fromJson(json)).toList();
    } catch (error) {
      throw Exception('Failed to fetch reels: $error');
    }
  }

  // Get reels by creator
  static Future<List<Reel>> getReelsByCreator(String creatorId) async {
    try {
      final response = await _client
          .from('reels')
          .select()
          .eq('creator_id', creatorId)
          .order('created_at', ascending: false);

      return response.map<Reel>((json) => Reel.fromJson(json)).toList();
    } catch (error) {
      throw Exception('Failed to fetch creator reels: $error');
    }
  }

  // Get single reel by ID
  static Future<Reel> getReel(String reelId) async {
    try {
      final response = await _client
          .from('reels')
          .select(
              '*, user_profiles!creator_id(username, avatar_url, full_name)')
          .eq('id', reelId)
          .single();

      return Reel.fromJson(response);
    } catch (error) {
      throw Exception('Failed to fetch reel: $error');
    }
  }

  // Create new reel
  static Future<Reel> createReel({
    required String title,
    required String description,
    required String videoUrl,
    String? thumbnailUrl,
    int? duration,
    List<String>? tags,
  }) async {
    try {
      final response = await _client
          .from('reels')
          .insert({
            'title': title,
            'description': description,
            'video_url': videoUrl,
            'thumbnail_url': thumbnailUrl,
            'duration': duration,
            'tags': tags ?? [],
            'status': 'draft',
          })
          .select()
          .single();

      return Reel.fromJson(response);
    } catch (error) {
      throw Exception('Failed to create reel: $error');
    }
  }

  // Update reel
  static Future<Reel> updateReel({
    required String reelId,
    String? title,
    String? description,
    String? status,
    List<String>? tags,
  }) async {
    try {
      final updateData = <String, dynamic>{};

      if (title != null) updateData['title'] = title;
      if (description != null) updateData['description'] = description;
      if (status != null) updateData['status'] = status;
      if (tags != null) updateData['tags'] = tags;

      final response = await _client
          .from('reels')
          .update(updateData)
          .eq('id', reelId)
          .select()
          .single();

      return Reel.fromJson(response);
    } catch (error) {
      throw Exception('Failed to update reel: $error');
    }
  }

  // Delete reel
  static Future<void> deleteReel(String reelId) async {
    try {
      await _client.from('reels').delete().eq('id', reelId);
    } catch (error) {
      throw Exception('Failed to delete reel: $error');
    }
  }

  // Like a reel
  static Future<void> likeReel(String reelId) async {
    try {
      await _client.from('reel_likes').insert({
        'reel_id': reelId,
        'user_id': _client.auth.currentUser!.id,
      });
    } catch (error) {
      throw Exception('Failed to like reel: $error');
    }
  }

  // Unlike a reel
  static Future<void> unlikeReel(String reelId) async {
    try {
      await _client
          .from('reel_likes')
          .delete()
          .eq('reel_id', reelId)
          .eq('user_id', _client.auth.currentUser!.id);
    } catch (error) {
      throw Exception('Failed to unlike reel: $error');
    }
  }

  // Check if reel is liked by current user
  static Future<bool> isReelLiked(String reelId) async {
    try {
      final response = await _client
          .from('reel_likes')
          .select('id')
          .eq('reel_id', reelId)
          .eq('user_id', _client.auth.currentUser!.id)
          .limit(1);

      return response.isNotEmpty;
    } catch (error) {
      return false;
    }
  }

  // Add comment to reel
  static Future<void> addComment(String reelId, String content) async {
    try {
      await _client.from('reel_comments').insert({
        'reel_id': reelId,
        'content': content,
        'user_id': _client.auth.currentUser!.id,
      });
    } catch (error) {
      throw Exception('Failed to add comment: $error');
    }
  }

  // Get reel comments
  static Future<List<dynamic>> getReelComments(String reelId) async {
    try {
      final response = await _client
          .from('reel_comments')
          .select('*, user_profiles!user_id(username, avatar_url, full_name)')
          .eq('reel_id', reelId)
          .isFilter('parent_id', null) // Top-level comments only
          .order('created_at', ascending: false);

      return response;
    } catch (error) {
      throw Exception('Failed to fetch comments: $error');
    }
  }

  // Increment view count
  static Future<void> incrementViewCount(String reelId) async {
    try {
      await _client
          .from('reels')
          .update({'view_count': 'view_count + 1'}).eq('id', reelId);
    } catch (error) {
      // Ignore view count errors as they're not critical
    }
  }

  // Get trending reels (based on engagement)
  static Future<List<Reel>> getTrendingReels({int limit = 20}) async {
    try {
      final response = await _client
          .from('reels')
          .select('*, user_profiles!creator_id(username, avatar_url)')
          .eq('status', 'published')
          .order('like_count', ascending: false)
          .order('view_count', ascending: false)
          .limit(limit);

      return response.map<Reel>((json) => Reel.fromJson(json)).toList();
    } catch (error) {
      throw Exception('Failed to fetch trending reels: $error');
    }
  }

  // Tag products in reel
  static Future<void> tagProductsInReel({
    required String reelId,
    required List<Map<String, dynamic>> productTags,
  }) async {
    try {
      // First remove existing product tags
      await _client.from('reel_products').delete().eq('reel_id', reelId);

      // Add new product tags
      if (productTags.isNotEmpty) {
        await _client.from('reel_products').insert(productTags);
      }
    } catch (error) {
      throw Exception('Failed to tag products: $error');
    }
  }

  // Get products tagged in reel
  static Future<List<dynamic>> getReelProducts(String reelId) async {
    try {
      final response = await _client
          .from('reel_products')
          .select('*, products(*)')
          .eq('reel_id', reelId);

      return response;
    } catch (error) {
      throw Exception('Failed to fetch reel products: $error');
    }
  }
}
