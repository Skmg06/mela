import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductTaggingWidget extends StatefulWidget {
  final bool isVisible;
  final VoidCallback onClose;
  final Function(Offset, Map<String, dynamic>) onProductTagged;

  const ProductTaggingWidget({
    super.key,
    required this.isVisible,
    required this.onClose,
    required this.onProductTagged,
  });

  @override
  State<ProductTaggingWidget> createState() => _ProductTaggingWidgetState();
}

class _ProductTaggingWidgetState extends State<ProductTaggingWidget> {
  final List<Map<String, dynamic>> _productTags = [];
  final List<Map<String, dynamic>> _availableProducts = [
    {
      "id": 1,
      "name": "Wireless Headphones",
      "price": "\$89.99",
      "image":
          "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300&h=300&fit=crop",
      "category": "Electronics"
    },
    {
      "id": 2,
      "name": "Leather Jacket",
      "price": "\$199.99",
      "image":
          "https://images.unsplash.com/photo-1551028719-00167b16eac5?w=300&h=300&fit=crop",
      "category": "Fashion"
    },
    {
      "id": 3,
      "name": "Coffee Mug",
      "price": "\$24.99",
      "image":
          "https://images.unsplash.com/photo-1514228742587-6b1558fcf93a?w=300&h=300&fit=crop",
      "category": "Home"
    },
    {
      "id": 4,
      "name": "Running Shoes",
      "price": "\$129.99",
      "image":
          "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=300&h=300&fit=crop",
      "category": "Sports"
    },
    {
      "id": 5,
      "name": "Smartphone Case",
      "price": "\$39.99",
      "image":
          "https://images.unsplash.com/photo-1556656793-08538906a9f8?w=300&h=300&fit=crop",
      "category": "Accessories"
    },
  ];

  void _showProductSelector(Offset position) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
            height: 60.h,
            decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20))),
            child: Column(children: [
              // Handle bar
              Container(
                  margin: EdgeInsets.only(top: 2.h),
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2))),
              // Header
              Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Select Product',
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface)),
                        GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: CustomIconWidget(
                                iconName: 'close',
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                                size: 24)),
                      ])),
              // Search bar
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3))),
                  child: Row(children: [
                    CustomIconWidget(
                        iconName: 'search',
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                        size: 20),
                    SizedBox(width: 3.w),
                    Expanded(
                        child: TextField(
                            decoration: InputDecoration(
                                hintText: 'Search products...',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface
                                        .withValues(alpha: 0.6))))),
                  ])),
              SizedBox(height: 2.h),
              // Products list
              Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      itemCount: _availableProducts.length,
                      itemBuilder: (context, index) {
                        final product = _availableProducts[index];
                        return GestureDetector(
                            onTap: () {
                              _addProductTag(position, product);
                              Navigator.pop(context);
                            },
                            child: Container(
                                margin: EdgeInsets.only(bottom: 2.h),
                                padding: EdgeInsets.all(3.w),
                                decoration: BoxDecoration(
                                    color:
                                        AppTheme.lightTheme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: AppTheme
                                            .lightTheme.colorScheme.outline
                                            .withValues(alpha: 0.2))),
                                child: Row(children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CustomImageWidget(
                                          imageUrl: product["image"] as String,
                                          width: 15.w,
                                          height: 15.w,
                                          fit: BoxFit.cover)),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                        Text(product["name"] as String,
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600,
                                                color: AppTheme.lightTheme
                                                    .colorScheme.onSurface)),
                                        SizedBox(height: 0.5.h),
                                        Text(product["category"] as String,
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: AppTheme.lightTheme
                                                    .colorScheme.onSurface
                                                    .withValues(alpha: 0.6))),
                                        SizedBox(height: 0.5.h),
                                        Text(product["price"] as String,
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w700,
                                                color: AppTheme.lightTheme
                                                    .colorScheme.onSurface)),
                                      ])),
                                  CustomIconWidget(
                                      iconName: 'add_circle_outline',
                                      color: AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                      size: 24),
                                ])));
                      })),
            ])));
  }

  void _addProductTag(Offset position, Map<String, dynamic> product) {
    setState(() {
      _productTags.add({
        'position': position,
        'product': product,
        'id': _productTags.length + 1,
      });
    });
    widget.onProductTagged(position, product);
  }

  void _removeProductTag(int index) {
    setState(() {
      _productTags.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return const SizedBox.shrink();

    return Stack(children: [
      // Overlay
      Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withValues(alpha: 0.3),
          child: GestureDetector(
              onTapDown: (details) {
                final position = details.localPosition;
                _showProductSelector(position);
              },
              child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Stack(children: [
                    // Instructions
                    Positioned(
                        top: 15.h,
                        left: 0,
                        right: 0,
                        child: Center(
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Text('Tap anywhere to tag a product',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500))))),
                    // Product tags
                    ..._productTags.asMap().entries.map((entry) {
                      final index = entry.key;
                      final tag = entry.value;
                      final position = tag['position'] as Offset;
                      final product = tag['product'] as Map<String, dynamic>;

                      return Positioned(
                          left: position.dx - 15,
                          top: position.dy - 15,
                          child: GestureDetector(
                              onTap: () => _removeProductTag(index),
                              child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.red, width: 2),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.3),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2)),
                                      ]),
                                  child: Center(
                                      child: Text('${tag['id']}',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w700))))));
                    }).toList(),
                  ])))),
      // Close button
      Positioned(
          top: 0,
          right: 0,
          child: SafeArea(
              child: GestureDetector(
                  onTap: widget.onClose,
                  child: Container(
                      margin: EdgeInsets.all(4.w),
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8)),
                      child: CustomIconWidget(
                          iconName: 'close', color: Colors.white, size: 24))))),
    ]);
  }
}
