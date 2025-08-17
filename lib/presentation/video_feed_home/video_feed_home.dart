import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/context_menu_widget.dart';
import './widgets/engagement_actions_widget.dart';
import './widgets/product_bottom_sheet_widget.dart';
import './widgets/seller_info_widget.dart';
import './widgets/video_description_widget.dart';
import './widgets/video_player_widget.dart';
import 'widgets/context_menu_widget.dart';
import 'widgets/engagement_actions_widget.dart';
import 'widgets/product_bottom_sheet_widget.dart';
import 'widgets/seller_info_widget.dart';
import 'widgets/video_description_widget.dart';
import 'widgets/video_player_widget.dart';

class VideoFeedHome extends StatefulWidget {
  const VideoFeedHome({super.key});

  @override
  State<VideoFeedHome> createState() => _VideoFeedHomeState();
}

class _VideoFeedHomeState extends State<VideoFeedHome>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _likeAnimationController;
  late Animation<double> _likeAnimation;

  int _currentIndex = 0;
  bool _isPlaying = true;
  bool _showContextMenu = false;
  String _searchQuery = '';
  bool _showSearchBar = false;

  // Mock video data
  final List<Map<String, dynamic>> _videoData = [
    {
      "id": 1,
      "videoUrl":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
      "sellerName": "StyleHub Fashion",
      "sellerAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "followerCount": 125000,
      "isFollowing": false,
      "description":
          "Check out this amazing summer collection! Perfect for beach days and casual outings. Comfortable, stylish, and affordable. #SummerVibes #Fashion #BeachWear",
      "likeCount": 15420,
      "commentCount": 892,
      "shareCount": 234,
      "isLiked": false,
      "taggedProducts": [
        {
          "id": 1,
          "name": "Summer Beach Dress",
          "price": "\$89.99",
          "originalPrice": "\$129.99",
          "image":
              "https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=400&h=400&fit=crop",
          "description":
              "Lightweight and breathable summer dress perfect for beach vacations and casual outings."
        },
        {
          "id": 2,
          "name": "Straw Sun Hat",
          "price": "\$24.99",
          "image":
              "https://images.unsplash.com/photo-1521369909029-2afed882baee?w=400&h=400&fit=crop",
          "description": "Classic straw hat with UV protection for sunny days."
        }
      ]
    },
    {
      "id": 2,
      "videoUrl":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
      "sellerName": "TechGear Pro",
      "sellerAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "followerCount": 89500,
      "isFollowing": true,
      "description":
          "Latest smartphone accessories that will change your life! Wireless charging, premium cases, and more. Don't miss out on these deals! #TechDeals #Smartphone #Accessories",
      "likeCount": 8750,
      "commentCount": 456,
      "shareCount": 123,
      "isLiked": true,
      "taggedProducts": [
        {
          "id": 3,
          "name": "Wireless Charger Pro",
          "price": "\$49.99",
          "originalPrice": "\$79.99",
          "image":
              "https://images.unsplash.com/photo-1586953208448-b95a79798f07?w=400&h=400&fit=crop",
          "description":
              "Fast wireless charging pad compatible with all Qi-enabled devices."
        }
      ]
    },
    {
      "id": 3,
      "videoUrl":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
      "sellerName": "Home & Garden Co",
      "sellerAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "followerCount": 67800,
      "isFollowing": false,
      "description":
          "Transform your living space with these amazing home decor pieces! Modern, elegant, and budget-friendly. Your guests will be impressed! #HomeDecor #InteriorDesign #ModernLiving",
      "likeCount": 12300,
      "commentCount": 678,
      "shareCount": 189,
      "isLiked": false,
      "taggedProducts": [
        {
          "id": 4,
          "name": "Modern Table Lamp",
          "price": "\$79.99",
          "image":
              "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop",
          "description":
              "Sleek modern table lamp with adjustable brightness settings."
        },
        {
          "id": 5,
          "name": "Decorative Plant Pot",
          "price": "\$34.99",
          "image":
              "https://images.unsplash.com/photo-1485955900006-10f4d324d411?w=400&h=400&fit=crop",
          "description":
              "Ceramic plant pot with drainage system, perfect for indoor plants."
        },
        {
          "id": 6,
          "name": "Wall Art Canvas",
          "price": "\$59.99",
          "originalPrice": "\$89.99",
          "image":
              "https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=400&h=400&fit=crop",
          "description":
              "Abstract wall art canvas to enhance your living room aesthetics."
        }
      ]
    },
    {
      "id": 4,
      "videoUrl":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
      "sellerName": "Fitness First",
      "sellerAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "followerCount": 156000,
      "isFollowing": true,
      "description":
          "Get fit with our premium workout gear! High-quality materials, comfortable fit, and stylish designs. Start your fitness journey today! #Fitness #Workout #HealthyLifestyle",
      "likeCount": 23450,
      "commentCount": 1234,
      "shareCount": 567,
      "isLiked": false,
      "taggedProducts": [
        {
          "id": 7,
          "name": "Yoga Mat Premium",
          "price": "\$39.99",
          "image":
              "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400&h=400&fit=crop",
          "description":
              "Non-slip yoga mat with extra cushioning for comfortable workouts."
        }
      ]
    },
    {
      "id": 5,
      "videoUrl":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
      "sellerName": "Beauty Essentials",
      "sellerAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "followerCount": 234000,
      "isFollowing": false,
      "description":
          "Discover the secret to glowing skin! Our skincare routine will transform your complexion in just 30 days. Natural ingredients, proven results! #Skincare #Beauty #GlowUp",
      "likeCount": 34560,
      "commentCount": 2145,
      "shareCount": 890,
      "isLiked": true,
      "taggedProducts": [
        {
          "id": 8,
          "name": "Vitamin C Serum",
          "price": "\$29.99",
          "originalPrice": "\$49.99",
          "image":
              "https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=400&h=400&fit=crop",
          "description":
              "Brightening vitamin C serum for radiant and youthful skin."
        },
        {
          "id": 9,
          "name": "Moisturizing Cream",
          "price": "\$24.99",
          "image":
              "https://images.unsplash.com/photo-1556228720-195a672e8a03?w=400&h=400&fit=crop",
          "description":
              "Hydrating face cream with hyaluronic acid for all skin types."
        }
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _pageController = PageController();

    _likeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _likeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _likeAnimationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _likeAnimationController.dispose();
    super.dispose();
  }

  void _handleVideoTap() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    HapticFeedback.lightImpact();
  }

  void _handleDoubleTap() {
    final currentVideo = _videoData[_currentIndex];
    setState(() {
      currentVideo['isLiked'] = !(currentVideo['isLiked'] as bool);
      if (currentVideo['isLiked'] as bool) {
        currentVideo['likeCount'] = (currentVideo['likeCount'] as int) + 1;
      } else {
        currentVideo['likeCount'] = (currentVideo['likeCount'] as int) - 1;
      }
    });

    if (currentVideo['isLiked'] as bool) {
      _likeAnimationController.forward().then((_) {
        _likeAnimationController.reverse();
      });
    }

    HapticFeedback.mediumImpact();
  }

  void _handleLongPress() {
    setState(() {
      _showContextMenu = true;
    });
    HapticFeedback.heavyImpact();
  }

  void _handleLike() {
    final currentVideo = _videoData[_currentIndex];
    setState(() {
      currentVideo['isLiked'] = !(currentVideo['isLiked'] as bool);
      if (currentVideo['isLiked'] as bool) {
        currentVideo['likeCount'] = (currentVideo['likeCount'] as int) + 1;
      } else {
        currentVideo['likeCount'] = (currentVideo['likeCount'] as int) - 1;
      }
    });
  }

  void _handleComment() {
    // Navigate to comments or show comments bottom sheet
    HapticFeedback.selectionClick();
  }

  void _handleShare() {
    // Implement share functionality
    HapticFeedback.selectionClick();
  }

  void _handleShop() {
    final currentVideo = _videoData[_currentIndex];
    final products =
        currentVideo['taggedProducts'] as List<Map<String, dynamic>>;

    if (products.isNotEmpty) {
      _showProductBottomSheet(products);
    }
  }

  void _handleFollow() {
    final currentVideo = _videoData[_currentIndex];
    setState(() {
      currentVideo['isFollowing'] = !(currentVideo['isFollowing'] as bool);
      if (currentVideo['isFollowing'] as bool) {
        currentVideo['followerCount'] =
            (currentVideo['followerCount'] as int) + 1;
      } else {
        currentVideo['followerCount'] =
            (currentVideo['followerCount'] as int) - 1;
      }
    });
  }

  void _handleProfileTap() {
    Navigator.pushNamed(context, '/seller-profile');
  }

  void _showProductBottomSheet(List<Map<String, dynamic>> products) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductBottomSheetWidget(
        products: products,
        onAddToCart: _handleAddToCart,
        onBuyNow: _handleBuyNow,
      ),
    );
  }

  void _handleAddToCart() {
    // Implement add to cart functionality
    HapticFeedback.lightImpact();
  }

  void _handleBuyNow() {
    // Navigate to checkout
    HapticFeedback.mediumImpact();
  }

  void _handleSave() {
    // Implement save video functionality
    setState(() {
      _showContextMenu = false;
    });
  }

  void _handleReport() {
    // Implement report functionality
    setState(() {
      _showContextMenu = false;
    });
  }

  void _handleNotInterested() {
    // Implement not interested functionality
    setState(() {
      _showContextMenu = false;
    });
  }

  void _handlePageChanged(int index) {
    setState(() {
      _currentIndex = index;
      _isPlaying = true;
    });
  }

  void _handlePullDown(DragUpdateDetails details) {
    if (details.delta.dy > 10 && !_showSearchBar) {
      setState(() {
        _showSearchBar = true;
      });
    }
  }

  void _hideSearchBar() {
    setState(() {
      _showSearchBar = false;
      _searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildVideoFeed(),
          _buildTopOverlay(),
          if (_showContextMenu) _buildContextMenu(),
          _buildLikeAnimation(),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on home
              break;
            case 1:
              Navigator.pushNamed(context, '/camera-recording');
              break;
            case 2:
              Navigator.pushNamed(context, '/seller-profile');
              break;
            case 3:
              Navigator.pushNamed(context, '/seller-dashboard');
              break;
            case 4:
              Navigator.pushNamed(context, '/user-profile');
              break;
          }
        },
      ),
    );
  }

  Widget _buildVideoFeed() {
    return GestureDetector(
      onPanUpdate: _handlePullDown,
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        onPageChanged: _handlePageChanged,
        itemCount: _videoData.length,
        itemBuilder: (context, index) {
          final video = _videoData[index];
          return _buildVideoItem(video, index == _currentIndex);
        },
      ),
    );
  }

  Widget _buildVideoItem(Map<String, dynamic> video, bool isActive) {
    return Stack(
      fit: StackFit.expand,
      children: [
        VideoPlayerWidget(
          videoUrl: video['videoUrl'] as String,
          isPlaying: isActive && _isPlaying,
          onTap: _handleVideoTap,
          onDoubleTap: _handleDoubleTap,
          onLongPress: _handleLongPress,
        ),
        _buildVideoOverlays(video),
      ],
    );
  }

  Widget _buildVideoOverlays(Map<String, dynamic> video) {
    return SafeArea(
      child: Stack(
        children: [
          // Left side - Seller info
          Positioned(
            left: 0,
            bottom: 15.h,
            child: SizedBox(
              width: 70.w,
              child: SellerInfoWidget(
                sellerName: video['sellerName'] as String,
                sellerAvatar: video['sellerAvatar'] as String,
                followerCount: video['followerCount'] as int,
                isFollowing: video['isFollowing'] as bool,
                onFollow: _handleFollow,
                onProfileTap: _handleProfileTap,
              ),
            ),
          ),

          // Right side - Engagement actions
          Positioned(
            right: 2.w,
            bottom: 15.h,
            child: EngagementActionsWidget(
              isLiked: video['isLiked'] as bool,
              likeCount: video['likeCount'] as int,
              commentCount: video['commentCount'] as int,
              shareCount: video['shareCount'] as int,
              onLike: _handleLike,
              onComment: _handleComment,
              onShare: _handleShare,
              onShop: _handleShop,
            ),
          ),

          // Bottom - Video description and products
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: VideoDescriptionWidget(
              description: video['description'] as String,
              taggedProducts:
                  video['taggedProducts'] as List<Map<String, dynamic>>,
              onProductTap: _handleShop,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopOverlay() {
    return SafeArea(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: _showSearchBar ? 15.h : 8.h,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.6),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          children: [
            if (_showSearchBar) ...[
              _buildSearchBar(),
              SizedBox(height: 2.h),
            ],
            _buildTopNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 6.h,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        onSubmitted: (value) {
          _hideSearchBar();
          // Implement search functionality
        },
        decoration: InputDecoration(
          hintText: 'Search products, sellers...',
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
          prefixIcon: CustomIconWidget(
            iconName: 'search',
            color: Colors.grey[600]!,
            size: 5.w,
          ),
          suffixIcon: GestureDetector(
            onTap: _hideSearchBar,
            child: CustomIconWidget(
              iconName: 'close',
              color: Colors.grey[600]!,
              size: 5.w,
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        ),
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildTopNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildNavTab('Home', true),
        SizedBox(width: 8.w),
        _buildNavTab('Search', false),
        SizedBox(width: 8.w),
        _buildNavTab('Camera', false),
        SizedBox(width: 8.w),
        _buildNavTab('Notifications', false),
        SizedBox(width: 8.w),
        _buildNavTab('Profile', false),
      ],
    );
  }

  Widget _buildNavTab(String title, bool isActive) {
    return GestureDetector(
      onTap: () {
        switch (title) {
          case 'Search':
            setState(() {
              _showSearchBar = !_showSearchBar;
            });
            break;
          case 'Camera':
            Navigator.pushNamed(context, '/camera-recording');
            break;
          case 'Notifications':
            // Handle notifications
            break;
          case 'Profile':
            Navigator.pushNamed(context, '/user-profile');
            break;
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4.w),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: Colors.white,
            shadows: [
              Shadow(
                offset: const Offset(0, 1),
                blurRadius: 2,
                color: Colors.black.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContextMenu() {
    return ContextMenuWidget(
      onSave: _handleSave,
      onReport: _handleReport,
      onNotInterested: _handleNotInterested,
      onClose: () {
        setState(() {
          _showContextMenu = false;
        });
      },
    );
  }

  Widget _buildLikeAnimation() {
    return AnimatedBuilder(
      animation: _likeAnimation,
      builder: (context, child) {
        return _likeAnimation.value > 0
            ? Center(
                child: Transform.scale(
                  scale: _likeAnimation.value,
                  child: Opacity(
                    opacity: 1.0 - _likeAnimation.value,
                    child: CustomIconWidget(
                      iconName: 'favorite',
                      color: AppTheme.errorLight,
                      size: 20.w,
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }
}