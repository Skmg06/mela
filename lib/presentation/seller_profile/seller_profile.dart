import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/bio_section_widget.dart';
import './widgets/content_tabs_widget.dart';
import './widgets/profile_header_widget.dart';

class SellerProfile extends StatefulWidget {
  const SellerProfile({super.key});

  @override
  State<SellerProfile> createState() => _SellerProfileState();
}

class _SellerProfileState extends State<SellerProfile> {
  bool _isFollowing = false;
  bool _isLoading = false;

  // Mock seller data
  final Map<String, dynamic> _sellerData = {
    "id": 1,
    "businessName": "Artisan Crafts Co.",
    "logo":
        "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    "coverImage":
        "https://images.unsplash.com/photo-1441986300917-64674bd600d8?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    "category": "Handmade & Crafts",
    "bio":
        "Welcome to Artisan Crafts Co.! We specialize in creating beautiful, handmade items that bring joy and uniqueness to your everyday life. Our passion for craftsmanship drives us to deliver exceptional quality products that tell a story. From home decor to personal accessories, each piece is carefully crafted with attention to detail and love. We believe in sustainable practices and supporting local artisans. Join our community of craft lovers and discover the beauty of handmade excellence.",
    "location": "Portland, Oregon, USA",
    "website": "www.artisancrafts.com",
    "phone": "+1 (555) 123-4567",
    "email": "hello@artisancrafts.com",
    "videoCount": 47,
    "followerCount": 12500,
    "followingCount": 89,
    "isVerified": true,
    "hasSecurePayment": true,
    "fastShipping": true,
  };

  // Mock videos data
  final List<Map<String, dynamic>> _videos = [
    {
      "id": 1,
      "thumbnail":
          "https://images.unsplash.com/photo-1452860606245-08befc0ff44b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "title": "Handmade Ceramic Bowls Process",
      "viewCount": 15600,
      "likeCount": 1200,
      "duration": "2:45",
    },
    {
      "id": 2,
      "thumbnail":
          "https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "title": "Macrame Wall Hanging Tutorial",
      "viewCount": 8900,
      "likeCount": 750,
      "duration": "4:12",
    },
    {
      "id": 3,
      "thumbnail":
          "https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "title": "Wood Carving Techniques",
      "viewCount": 22100,
      "likeCount": 1800,
      "duration": "3:28",
    },
    {
      "id": 4,
      "thumbnail":
          "https://images.unsplash.com/photo-1578662996442-48f60103fc96?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "title": "Pottery Glazing Tips",
      "viewCount": 11400,
      "likeCount": 920,
      "duration": "5:15",
    },
    {
      "id": 5,
      "thumbnail":
          "https://images.unsplash.com/photo-1594736797933-d0401ba2fe65?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "title": "Leather Crafting Basics",
      "viewCount": 18700,
      "likeCount": 1450,
      "duration": "6:32",
    },
    {
      "id": 6,
      "thumbnail":
          "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "title": "Candle Making Workshop",
      "viewCount": 9800,
      "likeCount": 680,
      "duration": "4:45",
    },
  ];

  // Mock products data
  final List<Map<String, dynamic>> _products = [
    {
      "id": 1,
      "name": "Handcrafted Ceramic Bowl Set",
      "image":
          "https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "price": "\$89.99",
      "rating": 4.8,
      "reviewCount": 124,
      "inStock": true,
    },
    {
      "id": 2,
      "name": "Macrame Wall Hanging - Large",
      "image":
          "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "price": "\$65.00",
      "rating": 4.9,
      "reviewCount": 89,
      "inStock": true,
    },
    {
      "id": 3,
      "name": "Carved Wooden Serving Tray",
      "image":
          "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "price": "\$45.50",
      "rating": 4.7,
      "reviewCount": 67,
      "inStock": false,
    },
    {
      "id": 4,
      "name": "Artisan Scented Candles (Set of 3)",
      "image":
          "https://images.unsplash.com/photo-1602874801006-e26c884e5a1b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "price": "\$32.99",
      "rating": 4.6,
      "reviewCount": 156,
      "inStock": true,
    },
    {
      "id": 5,
      "name": "Leather Journal with Embossing",
      "image":
          "https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "price": "\$78.00",
      "rating": 4.9,
      "reviewCount": 203,
      "inStock": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primaryContainer,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: colorScheme.onSurface,
        child: CustomScrollView(
          slivers: [
            // Custom App Bar
            SliverAppBar(
              expandedHeight: 0,
              floating: true,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CustomIconWidget(
                    iconName: 'arrow_back_ios',
                    color: colorScheme.onSurface,
                    size: 18,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CustomIconWidget(
                      iconName: 'more_vert',
                      color: colorScheme.onSurface,
                      size: 18,
                    ),
                  ),
                  onPressed: _showMoreOptions,
                ),
                SizedBox(width: 2.w),
              ],
            ),

            // Profile Header
            SliverToBoxAdapter(
              child: ProfileHeaderWidget(
                sellerData: _sellerData,
                isFollowing: _isFollowing,
                onFollowTap: _handleFollowTap,
                onMessageTap: _handleMessageTap,
                onShareTap: _handleShareTap,
              ),
            ),

            SizedBox(height: 2.h).toSliver(),

            // Bio Section
            SliverToBoxAdapter(
              child: BioSectionWidget(
                sellerData: _sellerData,
              ),
            ),

            SizedBox(height: 2.h).toSliver(),

            // Content Tabs
            SliverFillRemaining(
              child: ContentTabsWidget(
                sellerData: _sellerData,
                videos: _videos,
                products: _products,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Refresh data
    });
  }

  void _handleFollowTap() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Provide haptic feedback
    HapticFeedback.lightImpact();

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _isFollowing = !_isFollowing;
      if (_isFollowing) {
        _sellerData["followerCount"] =
            (_sellerData["followerCount"] as int) + 1;
      } else {
        _sellerData["followerCount"] =
            (_sellerData["followerCount"] as int) - 1;
      }
      _isLoading = false;
    });

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFollowing
              ? "You are now following ${_sellerData["businessName"]}"
              : "You unfollowed ${_sellerData["businessName"]}",
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleMessageTap() {
    HapticFeedback.selectionClick();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildMessageBottomSheet(context),
    );
  }

  void _handleShareTap() {
    HapticFeedback.selectionClick();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildShareBottomSheet(context),
    );
  }

  void _showMoreOptions() {
    HapticFeedback.selectionClick();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildMoreOptionsBottomSheet(context),
    );
  }

  Widget _buildMessageBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            "Contact ${_sellerData["businessName"]}",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          ListTile(
            leading: CustomIconWidget(
              iconName: 'chat',
              color: colorScheme.onSurface,
              size: 24,
            ),
            title: Text("Send Message"),
            subtitle: Text("Start a conversation"),
            onTap: () {
              Navigator.pop(context);
              // Navigate to chat
            },
          ),
          ListTile(
            leading: CustomIconWidget(
              iconName: 'phone',
              color: colorScheme.onSurface,
              size: 24,
            ),
            title: Text("Call"),
            subtitle: Text(_sellerData["phone"] as String),
            onTap: () {
              Navigator.pop(context);
              // Make phone call
            },
          ),
          ListTile(
            leading: CustomIconWidget(
              iconName: 'email',
              color: colorScheme.onSurface,
              size: 24,
            ),
            title: Text("Email"),
            subtitle: Text(_sellerData["email"] as String),
            onTap: () {
              Navigator.pop(context);
              // Send email
            },
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildShareBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            "Share Profile",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildShareOption(context, "Copy Link", 'link', () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Link copied to clipboard")),
                );
              }),
              _buildShareOption(context, "Message", 'message', () {
                Navigator.pop(context);
              }),
              _buildShareOption(context, "More", 'more_horiz', () {
                Navigator.pop(context);
              }),
            ],
          ),
          SizedBox(height: 3.h),
        ],
      ),
    );
  }

  Widget _buildMoreOptionsBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 3.h),
          ListTile(
            leading: CustomIconWidget(
              iconName: 'bookmark_border',
              color: colorScheme.onSurface,
              size: 24,
            ),
            title: Text("Save Profile"),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Profile saved")),
              );
            },
          ),
          ListTile(
            leading: CustomIconWidget(
              iconName: 'report',
              color: colorScheme.error,
              size: 24,
            ),
            title: Text(
              "Report",
              style: TextStyle(color: colorScheme.error),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildShareOption(
    BuildContext context,
    String label,
    String iconName,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: colorScheme.onPrimaryContainer,
              size: 24,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

extension SizedBoxSliver on SizedBox {
  Widget toSliver() {
    return SliverToBoxAdapter(child: this);
  }
}
