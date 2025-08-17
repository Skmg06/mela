import '../services/supabase_service.dart';
import '../models/order.dart';

class OrderService {
  static final _client = SupabaseService.instance.client;

  // Create new order
  static Future<Order> createOrder({
    required double totalAmount,
    required Map<String, dynamic> shippingAddress,
    required List<Map<String, dynamic>> items,
    String? paymentMethod,
    String? notes,
  }) async {
    try {
      // Create order
      final orderResponse = await _client
          .from('orders')
          .insert({
            'total_amount': totalAmount,
            'shipping_address': shippingAddress,
            'payment_method': paymentMethod,
            'notes': notes,
            'status': 'pending',
          })
          .select()
          .single();

      final orderId = orderResponse['id'] as String;

      // Create order items
      final orderItems = items
          .map((item) => {
                'order_id': orderId,
                'product_id': item['product_id'],
                'seller_id': item['seller_id'],
                'quantity': item['quantity'],
                'unit_price': item['unit_price'],
                'total_price': item['total_price'],
              })
          .toList();

      await _client.from('order_items').insert(orderItems);

      return Order.fromJson(orderResponse);
    } catch (error) {
      throw Exception('Failed to create order: $error');
    }
  }

  // Get user's orders (buyer perspective)
  static Future<List<Order>> getUserOrders() async {
    try {
      final response = await _client
          .from('orders')
          .select()
          .eq('buyer_id', _client.auth.currentUser!.id)
          .order('created_at', ascending: false);

      return response.map<Order>((json) => Order.fromJson(json)).toList();
    } catch (error) {
      throw Exception('Failed to fetch orders: $error');
    }
  }

  // Get seller's orders (seller perspective)
  static Future<List<Order>> getSellerOrders() async {
    try {
      final response = await _client
          .from('orders')
          .select('*, order_items!inner(*)')
          .eq('order_items.seller_id', _client.auth.currentUser!.id)
          .order('created_at', ascending: false);

      return response.map<Order>((json) => Order.fromJson(json)).toList();
    } catch (error) {
      throw Exception('Failed to fetch seller orders: $error');
    }
  }

  // Get single order details
  static Future<Map<String, dynamic>> getOrderDetails(String orderId) async {
    try {
      final orderResponse =
          await _client.from('orders').select().eq('id', orderId).single();

      final itemsResponse = await _client
          .from('order_items')
          .select(
              '*, products(*), user_profiles!seller_id(full_name, business_name)')
          .eq('order_id', orderId);

      return {
        'order': Order.fromJson(orderResponse),
        'items': itemsResponse,
      };
    } catch (error) {
      throw Exception('Failed to fetch order details: $error');
    }
  }

  // Update order status (seller only)
  static Future<Order> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    try {
      final response = await _client
          .from('orders')
          .update({'status': status})
          .eq('id', orderId)
          .select()
          .single();

      return Order.fromJson(response);
    } catch (error) {
      throw Exception('Failed to update order status: $error');
    }
  }

  // Cancel order (buyer only, within time limit)
  static Future<Order> cancelOrder(String orderId) async {
    try {
      final response = await _client
          .from('orders')
          .update({'status': 'cancelled'})
          .eq('id', orderId)
          .eq('buyer_id', _client.auth.currentUser!.id)
          .select()
          .single();

      return Order.fromJson(response);
    } catch (error) {
      throw Exception('Failed to cancel order: $error');
    }
  }

  // Get order statistics for seller dashboard
  static Future<Map<String, dynamic>> getSellerOrderStats() async {
    try {
      final totalOrdersData = await _client
          .from('order_items')
          .select('order_id')
          .eq('seller_id', _client.auth.currentUser!.id)
          .count();

      final pendingOrdersData = await _client
          .from('order_items')
          .select('order_id')
          .eq('seller_id', _client.auth.currentUser!.id)
          .eq('orders.status', 'pending')
          .count();

      final revenueData = await _client
          .from('order_items')
          .select('total_price')
          .eq('seller_id', _client.auth.currentUser!.id);

      final totalRevenue = revenueData.fold<double>(
          0.0, (sum, item) => sum + (item['total_price'] as num).toDouble());

      return {
        'total_orders': totalOrdersData.count,
        'pending_orders': pendingOrdersData.count,
        'total_revenue': totalRevenue,
      };
    } catch (error) {
      throw Exception('Failed to fetch order statistics: $error');
    }
  }

  // Get recent orders for seller dashboard
  static Future<List<dynamic>> getRecentOrders({int limit = 5}) async {
    try {
      final response = await _client
          .from('order_items')
          .select('*, orders(*), products(name)')
          .eq('seller_id', _client.auth.currentUser!.id)
          .order('created_at', ascending: false)
          .limit(limit);

      return response;
    } catch (error) {
      throw Exception('Failed to fetch recent orders: $error');
    }
  }

  // Search orders
  static Future<List<Order>> searchOrders({
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var query = _client
          .from('orders')
          .select()
          .eq('buyer_id', _client.auth.currentUser!.id);

      if (status != null) {
        query = query.eq('status', status);
      }

      if (startDate != null) {
        query = query.gte('created_at', startDate.toIso8601String());
      }

      if (endDate != null) {
        query = query.lte('created_at', endDate.toIso8601String());
      }

      final response = await query.order('created_at', ascending: false);

      return response.map<Order>((json) => Order.fromJson(json)).toList();
    } catch (error) {
      throw Exception('Failed to search orders: $error');
    }
  }
}
