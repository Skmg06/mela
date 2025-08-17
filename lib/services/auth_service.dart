import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import '../models/user_profile.dart';

class AuthService {
  static final _client = SupabaseService.instance.client;

  // Sign up with email and password
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    String? username,
    String role = 'buyer',
    String? businessName,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'username': username ?? email.split('@')[0],
          'role': role,
          'business_name': businessName,
        },
      );
      return response;
    } catch (error) {
      throw Exception('Sign-up failed: $error');
    }
  }

  // Sign in with email and password
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (error) {
      throw Exception('Sign-in failed: $error');
    }
  }

  // Sign in with Google OAuth
  static Future<bool> signInWithGoogle() async {
    try {
      return await _client.auth.signInWithOAuth(OAuthProvider.google);
    } catch (error) {
      throw Exception('Google sign-in failed: $error');
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (error) {
      throw Exception('Sign-out failed: $error');
    }
  }

  // Get current user session
  static Session? getCurrentSession() {
    return _client.auth.currentSession;
  }

  // Get current user
  static User? getCurrentUser() {
    return _client.auth.currentUser;
  }

  // Get current user profile
  static Future<UserProfile?> getCurrentUserProfile() async {
    try {
      final user = getCurrentUser();
      if (user == null) return null;

      final response = await _client
          .from('user_profiles')
          .select()
          .eq('id', user.id)
          .single();

      return UserProfile.fromJson(response);
    } catch (error) {
      throw Exception('Failed to get user profile: $error');
    }
  }

  // Update user profile
  static Future<UserProfile> updateUserProfile({
    required String userId,
    String? fullName,
    String? username,
    String? bio,
    String? phone,
    String? businessName,
    String? businessAddress,
    String? avatarUrl,
  }) async {
    try {
      final updateData = <String, dynamic>{};

      if (fullName != null) updateData['full_name'] = fullName;
      if (username != null) updateData['username'] = username;
      if (bio != null) updateData['bio'] = bio;
      if (phone != null) updateData['phone'] = phone;
      if (businessName != null) updateData['business_name'] = businessName;
      if (businessAddress != null)
        updateData['business_address'] = businessAddress;
      if (avatarUrl != null) updateData['avatar_url'] = avatarUrl;

      final response = await _client
          .from('user_profiles')
          .update(updateData)
          .eq('id', userId)
          .select()
          .single();

      return UserProfile.fromJson(response);
    } catch (error) {
      throw Exception('Failed to update profile: $error');
    }
  }

  // Check if username is available
  static Future<bool> isUsernameAvailable(String username) async {
    try {
      final response = await _client
          .from('user_profiles')
          .select('id')
          .eq('username', username)
          .limit(1);

      return response.isEmpty;
    } catch (error) {
      throw Exception('Failed to check username: $error');
    }
  }

  // Reset password
  static Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (error) {
      throw Exception('Password reset failed: $error');
    }
  }

  // Listen to auth state changes
  static Stream<AuthState> get authStateChanges {
    return _client.auth.onAuthStateChange;
  }
}
