import 'dart:io';
import 'dart:typed_data';
import '../services/supabase_service.dart';

class StorageService {
  static final _client = SupabaseService.instance.client;

  // Upload reel video
  static Future<String> uploadReelVideo({
    required File videoFile,
    required String fileName,
  }) async {
    try {
      final userId = _client.auth.currentUser!.id;
      final filePath = '$userId/$fileName';

      await _client.storage.from('reel-videos').upload(filePath, videoFile);

      return _client.storage.from('reel-videos').getPublicUrl(filePath);
    } catch (error) {
      throw Exception('Failed to upload video: $error');
    }
  }

  // Upload product image
  static Future<String> uploadProductImage({
    required File imageFile,
    required String fileName,
  }) async {
    try {
      final userId = _client.auth.currentUser!.id;
      final filePath = '$userId/$fileName';

      await _client.storage.from('product-images').upload(filePath, imageFile);

      return _client.storage.from('product-images').getPublicUrl(filePath);
    } catch (error) {
      throw Exception('Failed to upload image: $error');
    }
  }

  // Upload multiple product images
  static Future<List<String>> uploadProductImages({
    required List<File> imageFiles,
  }) async {
    try {
      final List<String> imageUrls = [];
      final userId = _client.auth.currentUser!.id;

      for (int i = 0; i < imageFiles.length; i++) {
        final fileName =
            'product_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
        final filePath = '$userId/$fileName';

        await _client.storage
            .from('product-images')
            .upload(filePath, imageFiles[i]);

        final url =
            _client.storage.from('product-images').getPublicUrl(filePath);

        imageUrls.add(url);
      }

      return imageUrls;
    } catch (error) {
      throw Exception('Failed to upload images: $error');
    }
  }

  // Upload user avatar
  static Future<String> uploadUserAvatar({
    required File imageFile,
    required String fileName,
  }) async {
    try {
      final userId = _client.auth.currentUser!.id;
      final filePath = '$userId/$fileName';

      await _client.storage.from('user-avatars').upload(filePath, imageFile);

      return _client.storage.from('user-avatars').getPublicUrl(filePath);
    } catch (error) {
      throw Exception('Failed to upload avatar: $error');
    }
  }

  // Upload from bytes (for web compatibility)
  static Future<String> uploadFromBytes({
    required Uint8List bytes,
    required String bucket,
    required String fileName,
    String? contentType,
  }) async {
    try {
      final userId = _client.auth.currentUser!.id;
      final filePath = '$userId/$fileName';

      await _client.storage.from(bucket).uploadBinary(
            filePath,
            bytes,
          );

      return _client.storage.from(bucket).getPublicUrl(filePath);
    } catch (error) {
      throw Exception('Failed to upload file: $error');
    }
  }

  // Delete file
  static Future<void> deleteFile({
    required String bucket,
    required String filePath,
  }) async {
    try {
      await _client.storage.from(bucket).remove([filePath]);
    } catch (error) {
      throw Exception('Failed to delete file: $error');
    }
  }

  // Get file download URL
  static Future<Uint8List> downloadFile({
    required String bucket,
    required String filePath,
  }) async {
    try {
      final response = await _client.storage.from(bucket).download(filePath);

      return response;
    } catch (error) {
      throw Exception('Failed to download file: $error');
    }
  }

  // Get signed URL (for temporary access to private files)
  static Future<String> getSignedUrl({
    required String bucket,
    required String filePath,
    int expiresIn = 3600, // 1 hour default
  }) async {
    try {
      final response = await _client.storage
          .from(bucket)
          .createSignedUrl(filePath, expiresIn);

      return response;
    } catch (error) {
      throw Exception('Failed to get signed URL: $error');
    }
  }

  // List files in user's folder
  static Future<List<dynamic>> listUserFiles(String bucket) async {
    try {
      final userId = _client.auth.currentUser!.id;

      final response = await _client.storage.from(bucket).list(path: userId);

      return response;
    } catch (error) {
      throw Exception('Failed to list files: $error');
    }
  }

  // Generate thumbnail for video (placeholder function)
  static Future<String> generateVideoThumbnail(String videoUrl) async {
    // This would typically use a video processing service
    // For now, return a placeholder thumbnail
    return 'https://images.unsplash.com/photo-1611162617474-5b21e879e113?w=300';
  }
}