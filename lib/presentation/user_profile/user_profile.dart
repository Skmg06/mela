import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/followed_sellers_widget.dart';
import './widgets/order_history_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/wishlist_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final ScrollController _scrollController = ScrollController();
  bool _isRefreshing = false;

  // Mock user profile data
  final Map<String, dynamic> _userProfile = {
    "id": 1,
    "name": "Sarah Johnson",
    "email": "sarah.johnson@email.com",
    "avatar":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop&crop=face",
    "joinDate": "March 2023",
    "totalOrders": 24,
    "followingCount": 18,
    "isGuest": false,
  };

  // Mock order history data
  final List<Map<String, dynamic>> _orderHistory = [
    {
      "orderId": "ORD-2024-001",
      "status": "Delivered",
      "itemCount": 3,
      "orderDate": "Aug 15, 2024",
      "totalAmount": "\$89.99",
      "items": ["Wireless Headphones", "Phone Case", "Screen Protector"],
    },
    {
      "orderId": "ORD-2024-002",
      "status": "Shipped",
      "itemCount": 1,
      "orderDate": "Aug 12, 2024",
      "totalAmount": "\$45.50",
      "items": ["Bluetooth Speaker"],
    },
    {
      "orderId": "ORD-2024-003",
      "status": "Processing",
      "itemCount": 2,
      "orderDate": "Aug 10, 2024",
      "totalAmount": "\$125.00",
      "items": ["Smart Watch", "Charging Cable"],
    },
  ];

  // Mock wishlist data
  final List<Map<String, dynamic>> _wishlistItems = [
    {
      "id": 1,
      "name": "Premium Wireless Earbuds",
      "price": "\$199.99",
      "image":
          "https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400&h=400&fit=crop",
      "inStock": true,
      "seller": "TechGear Pro",
    },
    {
      "id": 2,
      "name": "Smart Fitness Tracker",
      "price": "\$149.99",
      "image":
          "https://images.unsplash.com/photo-1575311373937-040b8e1fd5b6?w=400&h=400&fit=crop",
      "inStock": false,
      "seller": "FitLife Store",
    },
    {
      "id": 3,
      "name": "Portable Phone Charger",
      "price": "\$29.99",
      "image":
          "https://images.unsplash.com/photo-1609592806596-b43bada2f4b5?w=400&h=400&fit=crop",
      "inStock": true,
      "seller": "PowerUp Electronics",
    },
    {
      "id": 4,
      "name": "Bluetooth Gaming Controller",
      "price": "\$79.99",
      "image":
          "https://images.unsplash.com/photo-1606144042614-b2417e99c4e3?w=400&h=400&fit=crop",
      "inStock": true,
      "seller": "GameZone",
    },
  ];

  // Mock followed sellers data
  final List<Map<String, dynamic>> _followedSellers = [
    {
      "id": 1,
      "name": "TechGear Pro",
      "avatar":
          "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400&h=400&fit=crop",
      "followersCount": "12.5K",
      "productsCount": 156,
      "verified": true,
    },
    {
      "id": 2,
      "name": "FitLife Store",
      "avatar":
          "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=400&fit=crop",
      "followersCount": "8.2K",
      "productsCount": 89,
      "verified": true,
    },
    {
      "id": 3,
      "name": "PowerUp Electronics",
      "avatar":
          "https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=400&h=400&fit=crop",
      "followersCount": "15.7K",
      "productsCount": 234,
      "verified": false,
    },
    {
      "id": 4,
      "name": "GameZone",
      "avatar":
          "https://images.unsplash.com/photo-1493711662062-fa541adb3fc8?w=400&h=400&fit=crop",
      "followersCount": "6.9K",
      "productsCount": 67,
      "verified": true,
    },
    {
      "id": 5,
      "name": "StyleHub Fashion",
      "avatar":
          "https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400&h=400&fit=crop",
      "followersCount": "22.1K",
      "productsCount": 445,
      "verified": true,
    },
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isRefreshing = false;
    });

    // Show refresh feedback
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _handleEditProfile() {
    // Navigate to edit profile screen
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildEditProfileSheet(),
    );
  }

  void _handleTrackOrder(Map<String, dynamic> order) {
    // Show order tracking details
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildOrderTrackingSheet(order),
    );
  }

  void _handleReorder(Map<String, dynamic> order) {
    // Add items to cart and navigate to checkout
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${order["itemCount"]} items added to cart'),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () {
            // Navigate to cart
          },
        ),
      ),
    );
  }

  void _handleMoveToCart(Map<String, dynamic> item) {
    // Add item to cart
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item["name"]} added to cart'),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () {
            // Navigate to cart
          },
        ),
      ),
    );
  }

  void _handleRemoveFromWishlist(Map<String, dynamic> item) {
    setState(() {
      _wishlistItems.removeWhere((wishItem) => wishItem["id"] == item["id"]);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item["name"]} removed from wishlist'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _wishlistItems.add(item);
            });
          },
        ),
      ),
    );
  }

  void _handleViewShop(Map<String, dynamic> seller) {
    // Navigate to seller profile
    Navigator.pushNamed(context, '/seller-profile');
  }

  void _handleUnfollow(Map<String, dynamic> seller) {
    setState(() {
      _followedSellers.removeWhere(
          (followedSeller) => followedSeller["id"] == seller["id"]);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Unfollowed ${seller["name"]}'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _followedSellers.add(seller);
            });
          },
        ),
      ),
    );
  }

  void _handleSettingTap(String setting) {
    switch (setting) {
      case 'payment':
        _showComingSoonDialog('Payment Methods');
        break;
      case 'addresses':
        _showComingSoonDialog('Shipping Addresses');
        break;
      case 'language':
        _showComingSoonDialog('Language Settings');
        break;
      case 'privacy':
        _showComingSoonDialog('Privacy Settings');
        break;
      case 'help':
        _showComingSoonDialog('Help & Support');
        break;
      case 'about':
        _showAboutDialog();
        break;
      case 'share':
        _handleShareApp();
        break;
      case 'export':
        _handleExportData();
        break;
      case 'delete':
        _showDeleteAccountDialog();
        break;
    }
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/authentication-screen',
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(feature),
        content: const Text('This feature is coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Mela'),
        content: const Text(
          'Mela v1.0.0\n\nA social-commerce platform combining short-form video content with integrated shopping functionality.\n\n© 2024 Mela. All rights reserved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleShareApp() {
    // Share app functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share link copied to clipboard'),
      ),
    );
  }

  void _handleExportData() {
    // Export user data functionality
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text(
            'Your data will be exported and sent to your email address within 24 hours.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data export request submitted'),
                ),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This action cannot be undone. All your data, orders, and account information will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showFinalDeleteConfirmation();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showFinalDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Final Confirmation'),
        content: const Text('Type "DELETE" to confirm account deletion:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deletion request submitted'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Widget _buildEditProfileSheet() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Edit Profile',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'Enter your full name',
                    ),
                    controller:
                        TextEditingController(text: _userProfile["name"]),
                  ),
                  SizedBox(height: 2.h),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                    ),
                    controller:
                        TextEditingController(text: _userProfile["email"]),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profile updated successfully'),
                              ),
                            );
                          },
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTrackingSheet(Map<String, dynamic> order) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Order Tracking',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order #${order["orderId"]}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Status: ${order["status"]}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Estimated Delivery: Aug 20, 2024',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'Items:',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  ...(order["items"] as List<String>).map((item) => Padding(
                        padding: EdgeInsets.only(bottom: 0.5.h),
                        child: Text(
                          '• $item',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.8),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface.withValues(alpha: 0.95),
      appBar: AppBar(
        title: Text(
          'Profile',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: theme.brightness == Brightness.light
              ? Brightness.dark
              : Brightness.light,
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to settings or show menu
            },
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              ProfileHeaderWidget(
                userProfile: _userProfile,
                onEditProfile: _handleEditProfile,
              ),

              SizedBox(height: 3.h),

              // Order History
              OrderHistoryWidget(
                orders: _orderHistory,
                onTrackOrder: _handleTrackOrder,
                onReorder: _handleReorder,
              ),

              SizedBox(height: 3.h),

              // Wishlist
              WishlistWidget(
                wishlistItems: _wishlistItems,
                onMoveToCart: _handleMoveToCart,
                onRemoveFromWishlist: _handleRemoveFromWishlist,
              ),

              SizedBox(height: 3.h),

              // Followed Sellers
              FollowedSellersWidget(
                followedSellers: _followedSellers,
                onViewShop: _handleViewShop,
                onUnfollow: _handleUnfollow,
              ),

              SizedBox(height: 3.h),

              // Settings Section
              SettingsSectionWidget(
                onSettingTap: _handleSettingTap,
                onLogout: _handleLogout,
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
