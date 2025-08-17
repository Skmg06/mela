import '../services/supabase_service.dart';
import '../models/product.dart';
import '../models/category.dart';

class ProductService {
  static final _client = SupabaseService.instance.client;

  // Get all active products with pagination
  static Future<List<Product>> getProducts({
    int limit = 20,
    int offset = 0,
    String? categoryId,
    String? search,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      var query = _client.from('products').select().eq('status', 'active');

      if (categoryId != null) {
        query = query.eq('category_id', categoryId);
      }

      if (search != null && search.isNotEmpty) {
        query = query.or('name.ilike.%$search%,description.ilike.%$search%');
      }

      if (minPrice != null) {
        query = query.gte('price', minPrice);
      }

      if (maxPrice != null) {
        query = query.lte('price', maxPrice);
      }

      final response = await query
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return response.map<Product>((json) => Product.fromJson(json)).toList();
    } catch (error) {
      throw Exception('Failed to fetch products: $error');
    }
  }

  // Get products by seller
  static Future<List<Product>> getProductsBySeller(String sellerId) async {
    try {
      final response = await _client
          .from('products')
          .select()
          .eq('seller_id', sellerId)
          .order('created_at', ascending: false);

      return response.map<Product>((json) => Product.fromJson(json)).toList();
    } catch (error) {
      throw Exception('Failed to fetch seller products: $error');
    }
  }

  // Get single product by ID
  static Future<Product> getProduct(String productId) async {
    try {
      final response =
          await _client.from('products').select().eq('id', productId).single();

      return Product.fromJson(response);
    } catch (error) {
      throw Exception('Failed to fetch product: $error');
    }
  }

  // Create new product (sellers only)
  static Future<Product> createProduct({
    required String name,
    required String description,
    required double price,
    double? originalPrice,
    required String categoryId,
    required List<String> images,
    required int inventoryCount,
    List<String>? tags,
  }) async {
    try {
      final response = await _client
          .from('products')
          .insert({
            'name': name,
            'description': description,
            'price': price,
            'original_price': originalPrice,
            'category_id': categoryId,
            'images': images,
            'inventory_count': inventoryCount,
            'tags': tags ?? [],
            'status': 'draft',
          })
          .select()
          .single();

      return Product.fromJson(response);
    } catch (error) {
      throw Exception('Failed to create product: $error');
    }
  }

  // Update product
  static Future<Product> updateProduct({
    required String productId,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    String? categoryId,
    List<String>? images,
    int? inventoryCount,
    List<String>? tags,
    String? status,
  }) async {
    try {
      final updateData = <String, dynamic>{};

      if (name != null) updateData['name'] = name;
      if (description != null) updateData['description'] = description;
      if (price != null) updateData['price'] = price;
      if (originalPrice != null) updateData['original_price'] = originalPrice;
      if (categoryId != null) updateData['category_id'] = categoryId;
      if (images != null) updateData['images'] = images;
      if (inventoryCount != null)
        updateData['inventory_count'] = inventoryCount;
      if (tags != null) updateData['tags'] = tags;
      if (status != null) updateData['status'] = status;

      final response = await _client
          .from('products')
          .update(updateData)
          .eq('id', productId)
          .select()
          .single();

      return Product.fromJson(response);
    } catch (error) {
      throw Exception('Failed to update product: $error');
    }
  }

  // Delete product
  static Future<void> deleteProduct(String productId) async {
    try {
      await _client.from('products').delete().eq('id', productId);
    } catch (error) {
      throw Exception('Failed to delete product: $error');
    }
  }

  // Get all categories
  static Future<List<Category>> getCategories() async {
    try {
      final response = await _client
          .from('categories')
          .select()
          .order('sort_order', ascending: true);

      return response.map<Category>((json) => Category.fromJson(json)).toList();
    } catch (error) {
      throw Exception('Failed to fetch categories: $error');
    }
  }

  // Get featured categories
  static Future<List<Category>> getFeaturedCategories() async {
    try {
      final response = await _client
          .from('categories')
          .select()
          .eq('is_featured', true)
          .order('sort_order', ascending: true);

      return response.map<Category>((json) => Category.fromJson(json)).toList();
    } catch (error) {
      throw Exception('Failed to fetch featured categories: $error');
    }
  }

  // Add to wishlist
  static Future<void> addToWishlist(String productId) async {
    try {
      await _client.from('wishlists').insert({
        'product_id': productId,
        'user_id': _client.auth.currentUser!.id,
      });
    } catch (error) {
      throw Exception('Failed to add to wishlist: $error');
    }
  }

  // Remove from wishlist
  static Future<void> removeFromWishlist(String productId) async {
    try {
      await _client
          .from('wishlists')
          .delete()
          .eq('product_id', productId)
          .eq('user_id', _client.auth.currentUser!.id);
    } catch (error) {
      throw Exception('Failed to remove from wishlist: $error');
    }
  }

  // Get user's wishlist
  static Future<List<Product>> getWishlist() async {
    try {
      final response = await _client
          .from('wishlists')
          .select('products(*)')
          .eq('user_id', _client.auth.currentUser!.id);

      return response
          .map<Product>((json) => Product.fromJson(json['products']))
          .toList();
    } catch (error) {
      throw Exception('Failed to fetch wishlist: $error');
    }
  }

  // Check if product is in wishlist
  static Future<bool> isInWishlist(String productId) async {
    try {
      final response = await _client
          .from('wishlists')
          .select('id')
          .eq('product_id', productId)
          .eq('user_id', _client.auth.currentUser!.id)
          .limit(1);

      return response.isNotEmpty;
    } catch (error) {
      return false;
    }
  }
}
