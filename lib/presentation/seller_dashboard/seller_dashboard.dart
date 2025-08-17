import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../widgets/custom_tab_bar.dart';
import './widgets/analytics_chart_widget.dart';
import './widgets/metrics_card_widget.dart';
import './widgets/order_item_widget.dart';
import './widgets/product_item_widget.dart';
import './widgets/quick_action_button_widget.dart';
import './widgets/video_performance_item_widget.dart';

class SellerDashboard extends StatefulWidget {
  const SellerDashboard({super.key});

  @override
  State<SellerDashboard> createState() => _SellerDashboardState();
}

class _SellerDashboardState extends State<SellerDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentBottomIndex = 3;
  bool _isRefreshing = false;

  // Mock data for dashboard metrics
  final List<Map<String, dynamic>> _metricsData = [
    {
      "title": "Today's Sales",
      "value": "\$2,847",
      "subtitle": "vs yesterday",
      "icon": Icons.attach_money,
      "trend": 12.5,
      "color": Colors.green,
    },
    {
      "title": "Video Views",
      "value": "45.2K",
      "subtitle": "this week",
      "icon": Icons.visibility,
      "trend": 8.3,
      "color": Colors.blue,
    },
    {
      "title": "New Followers",
      "value": "1,234",
      "subtitle": "this month",
      "icon": Icons.people,
      "trend": -2.1,
      "color": Colors.purple,
    },
    {
      "title": "Pending Orders",
      "value": "23",
      "subtitle": "need attention",
      "icon": Icons.shopping_bag,
      "trend": 0.0,
      "color": Colors.orange,
    },
  ];

  // Mock data for video performance
  final List<Map<String, dynamic>> _videoPerformanceData = [
    {
      "id": "1",
      "title": "Summer Fashion Collection Haul",
      "thumbnail":
          "https://images.pexels.com/photos/1926769/pexels-photo-1926769.jpeg?auto=compress&cs=tinysrgb&w=400",
      "duration": "2:45",
      "views": 125000,
      "likes": 8500,
      "engagementRate": 6.8,
      "salesGenerated": 1250,
    },
    {
      "id": "2",
      "title": "Skincare Routine for Glowing Skin",
      "thumbnail":
          "https://images.pexels.com/photos/3762879/pexels-photo-3762879.jpeg?auto=compress&cs=tinysrgb&w=400",
      "duration": "3:12",
      "views": 89000,
      "likes": 6200,
      "engagementRate": 7.0,
      "salesGenerated": 890,
    },
    {
      "id": "3",
      "title": "Tech Gadgets You Need in 2024",
      "thumbnail":
          "https://images.pexels.com/photos/1279107/pexels-photo-1279107.jpeg?auto=compress&cs=tinysrgb&w=400",
      "duration": "4:30",
      "views": 156000,
      "likes": 12000,
      "engagementRate": 7.7,
      "salesGenerated": 2100,
    },
  ];

  // Mock data for products
  final List<Map<String, dynamic>> _productsData = [
    {
      "id": "1",
      "name": "Wireless Bluetooth Headphones",
      "price": 89.99,
      "stock": 45,
      "category": "Electronics",
      "image":
          "https://images.pexels.com/photos/3394650/pexels-photo-3394650.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
    {
      "id": "2",
      "name": "Organic Face Moisturizer",
      "price": 24.99,
      "stock": 8,
      "category": "Beauty",
      "image":
          "https://images.pexels.com/photos/4465124/pexels-photo-4465124.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
    {
      "id": "3",
      "name": "Vintage Denim Jacket",
      "price": 79.99,
      "stock": 23,
      "category": "Fashion",
      "image":
          "https://images.pexels.com/photos/1040945/pexels-photo-1040945.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
  ];

  // Mock data for orders
  final List<Map<String, dynamic>> _ordersData = [
    {
      "id": "ORD-2024-001",
      "customerName": "Sarah Johnson",
      "itemCount": 2,
      "total": 114.98,
      "status": "pending",
      "date": "Aug 17, 2024",
    },
    {
      "id": "ORD-2024-002",
      "customerName": "Michael Chen",
      "itemCount": 1,
      "total": 89.99,
      "status": "processing",
      "date": "Aug 16, 2024",
    },
    {
      "id": "ORD-2024-003",
      "customerName": "Emma Davis",
      "itemCount": 3,
      "total": 189.97,
      "status": "shipped",
      "date": "Aug 15, 2024",
    },
  ];

  // Mock data for analytics charts
  final List<Map<String, dynamic>> _salesChartData = [
    {"label": "Mon", "value": 1200},
    {"label": "Tue", "value": 1800},
    {"label": "Wed", "value": 1500},
    {"label": "Thu", "value": 2200},
    {"label": "Fri", "value": 2800},
    {"label": "Sat", "value": 3200},
    {"label": "Sun", "value": 2400},
  ];

  final List<Map<String, dynamic>> _engagementChartData = [
    {"label": "Week 1", "value": 45},
    {"label": "Week 2", "value": 52},
    {"label": "Week 3", "value": 48},
    {"label": "Week 4", "value": 67},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        variant: CustomAppBarVariant.standard,
        title: "Seller Dashboard",
        showProfileIcon: true,
        onProfilePressed: () => Navigator.pushNamed(context, '/user-profile'),
        actions: [
          IconButton(
            onPressed: () {
              // Show notifications
            },
            icon: Stack(
              children: [
                CustomIconWidget(
                  iconName: 'notifications',
                  color: colorScheme.onSurface,
                  size: 24,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          CustomTabBar(
            variant: CustomTabBarVariant.underline,
            tabs: const ['Overview', 'Analytics', 'Products', 'Orders'],
            onTap: (index) {
              _tabController.animateTo(index);
            },
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildAnalyticsTab(),
                  _buildProductsTab(),
                  _buildOrdersTab(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        variant: CustomBottomBarVariant.standard,
        currentIndex: _currentBottomIndex,
        onTap: (index) {
          setState(() {
            _currentBottomIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildOverviewTab() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Metrics Cards
          Text(
            "Today's Performance",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 3.w),
          Wrap(
            spacing: 3.w,
            runSpacing: 3.w,
            children: _metricsData.map((metric) {
              return MetricsCardWidget(
                title: (metric["title"] as String?) ?? "",
                value: (metric["value"] as String?) ?? "",
                subtitle: (metric["subtitle"] as String?) ?? "",
                icon: (metric["icon"] as IconData?) ?? Icons.analytics,
                iconColor: (metric["color"] as Color?) ?? colorScheme.primary,
                showTrend: true,
                trendValue: (metric["trend"] as double?) ?? 0.0,
                onTap: () {
                  // Navigate to detailed metrics
                },
              );
            }).toList(),
          ),
          SizedBox(height: 6.w),

          // Quick Actions
          Text(
            "Quick Actions",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 3.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              QuickActionButtonWidget(
                title: "New Video",
                icon: Icons.videocam,
                backgroundColor: Colors.red,
                onTap: () => Navigator.pushNamed(context, '/camera-recording'),
              ),
              QuickActionButtonWidget(
                title: "Add Product",
                icon: Icons.add_box,
                backgroundColor: Colors.green,
                onTap: () {
                  // Navigate to add product
                },
              ),
              QuickActionButtonWidget(
                title: "View Orders",
                icon: Icons.shopping_bag,
                backgroundColor: Colors.blue,
                onTap: () {
                  _tabController.animateTo(3);
                },
              ),
            ],
          ),
          SizedBox(height: 6.w),

          // Recent Video Performance
          Text(
            "Recent Video Performance",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 3.w),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _videoPerformanceData.length > 3
                ? 3
                : _videoPerformanceData.length,
            itemBuilder: (context, index) {
              return VideoPerformanceItemWidget(
                videoData: _videoPerformanceData[index],
                onTap: () {
                  // Navigate to video details
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnalyticsChartWidget(
            title: "Sales Trend (Last 7 Days)",
            chartData: _salesChartData,
            chartType: 'line',
            primaryColor: Colors.green,
          ),
          SizedBox(height: 4.w),
          AnalyticsChartWidget(
            title: "Engagement Rate (Weekly)",
            chartData: _engagementChartData,
            chartType: 'bar',
            primaryColor: Colors.blue,
          ),
          SizedBox(height: 4.w),

          // Video Performance List
          Text(
            "All Video Performance",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          SizedBox(height: 3.w),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _videoPerformanceData.length,
            itemBuilder: (context, index) {
              return VideoPerformanceItemWidget(
                videoData: _videoPerformanceData[index],
                onTap: () {
                  // Navigate to video analytics
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductsTab() {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Product Inventory",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to add product
                },
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: Colors.white,
                  size: 18,
                ),
                label: Text("Add Product"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.w),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _productsData.length,
            itemBuilder: (context, index) {
              return ProductItemWidget(
                productData: _productsData[index],
                onTap: () {
                  // Navigate to product details
                },
                onEdit: () {
                  // Navigate to edit product
                },
                onDelete: () {
                  // Show delete confirmation
                  _showDeleteProductDialog(index);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersTab() {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Management",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 3.w),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _ordersData.length,
            itemBuilder: (context, index) {
              return OrderItemWidget(
                orderData: _ordersData[index],
                onTap: () {
                  // Navigate to order details
                },
                onUpdateStatus: () {
                  _showUpdateStatusDialog(index);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteProductDialog(int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Product"),
        content: Text(
            "Are you sure you want to delete this product? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _productsData.removeAt(index);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showUpdateStatusDialog(int index) {
    final currentStatus =
        (_ordersData[index]["status"] as String?) ?? "pending";
    final statuses = ["pending", "processing", "shipped", "delivered"];
    String selectedStatus = currentStatus;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text("Update Order Status"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: statuses.map((status) {
              return RadioListTile<String>(
                title: Text(status.toUpperCase()),
                value: status,
                groupValue: selectedStatus,
                onChanged: (value) {
                  setDialogState(() {
                    selectedStatus = value!;
                  });
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _ordersData[index]["status"] = selectedStatus;
                });
                Navigator.pop(context);
              },
              child: Text("Update"),
            ),
          ],
        ),
      ),
    );
  }
}
