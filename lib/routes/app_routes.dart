import 'package:flutter/material.dart';
import '../presentation/seller_dashboard/seller_dashboard.dart';
import '../presentation/video_feed_home/video_feed_home.dart';
import '../presentation/user_profile/user_profile.dart';
import '../presentation/authentication_screen/authentication_screen.dart';
import '../presentation/camera_recording/camera_recording.dart';
import '../presentation/seller_profile/seller_profile.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String sellerDashboard = '/seller-dashboard';
  static const String videoFeedHome = '/video-feed-home';
  static const String userProfile = '/user-profile';
  static const String authentication = '/authentication-screen';
  static const String cameraRecording = '/camera-recording';
  static const String sellerProfile = '/seller-profile';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SellerDashboard(),
    sellerDashboard: (context) => const SellerDashboard(),
    videoFeedHome: (context) => const VideoFeedHome(),
    userProfile: (context) => const UserProfile(),
    authentication: (context) => const AuthenticationScreen(),
    cameraRecording: (context) => const CameraRecording(),
    sellerProfile: (context) => const SellerProfile(),
    // TODO: Add your other routes here
  };
}
