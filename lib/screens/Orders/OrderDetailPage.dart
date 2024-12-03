import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum OrderStatus {
  placed,
  processing,
  shippedInTransit,
  shippedOutForDelivery,
  delivered
}

class Order {
  final String productName;
  final double price;
  final OrderStatus status;
  final double amount;
  final DateTime orderDate;
  final Map<String, dynamic> productDetails;
  final String productImageUrl;

  Order({
    required this.productName,
    required this.price,
    required this.status,
    required this.amount,
    required this.orderDate,
    required this.productDetails,
    required this.productImageUrl,
  });
}

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key});

  @override
  State<OrderDetailsPage> createState() => OrderDetailsPageState();
}

class OrderDetailsPageState extends State<OrderDetailsPage> {
  List<Order> orders = [];
  bool isLoading = true;
  String currentUserId = "";

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchOrders();
  }

  Future<void> getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.uid;
      });
    } else {
      // Handle the case where the user is not authenticated
      // For example, you could redirect to a login screen or show an error message
      print("User is not authenticated");
    }
  }

  Future<void> fetchOrders() async {
    try {
      QuerySnapshot orderSnapshot = await FirebaseFirestore.instance
          .collection('orderData')
          .where('uid', isEqualTo: currentUserId)
          .get();

      List<Order> fetchedOrders = [];
      for (var doc in orderSnapshot.docs) {
        Map<String, dynamic> orderData = doc.data() as Map<String, dynamic>;

        DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
            .collection('products')
            .doc(orderData['productId'])
            .get();
        Map<String, dynamic> productData =
            productSnapshot.data() as Map<String, dynamic>;

        fetchedOrders.add(Order(
          productName: productData['name'] ?? 'Unknown Product',
          price: productData['price']?.toDouble() ?? 0.0,
          status: _parseOrderStatus(
              orderData['status']), // Parse status from backend
          amount: (productData['price']?.toDouble() ?? 0.0) *
              (orderData['quantity'] ?? 1),
          orderDate: (orderData['orderDate'] as Timestamp?)?.toDate() ??
              DateTime.now(),
          productDetails: productData,
          productImageUrl: productData['imageUrl'] ?? '',
        ));
      }

      setState(() {
        orders = fetchedOrders;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching orders: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  OrderStatus _parseOrderStatus(String? statusString) {
    // Implement logic to parse status from backend format
    // For example, if the backend sends "Shipped (In Transit)", you can extract the status and location information
    // and return the appropriate OrderStatus enum value.
    // You can use string manipulation or regular expressions to parse the status.

    // Placeholder implementation:
    switch (statusString) {
      case 'Placed':
        return OrderStatus.placed;
      case 'Processing':
        return OrderStatus.processing;
      case 'Shipped (In Transit)':
        return OrderStatus.shippedInTransit;
      case 'Shipped (Out for Delivery)':
        return OrderStatus.shippedOutForDelivery;
      case 'Delivered':
        return OrderStatus.delivered;
      default:
        return OrderStatus.placed; // Default to placed if unknown
    }
  }

  Widget _buildOrderCard(Order order) {
    String statusText = order.status.toString().split('.')[1];
    String locationText = order.status.toString().split('(').length > 1
        ? order.status.toString().split('(')[1].replaceAll(')', '')
        : '';

    Color statusColor;

    switch (order.status) {
      case OrderStatus.placed:
        statusColor = Colors.black;
        break;
      case OrderStatus.processing:
        statusColor = Colors.blueAccent;
        break;
      case OrderStatus.shippedInTransit:
      case OrderStatus.shippedOutForDelivery:
        statusColor = Colors.green;
        break;
      case OrderStatus.delivered:
        statusColor = Colors.deepPurple;
        break;
      default:
        statusColor = Colors.red;
    }

    return Card(
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            order.productImageUrl,
            width: 60.0,
            height: 120.0,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Icon(Icons.error),
            ),
          ),
        ),
        title: Text(order.productName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price: \$${order.price}',
              style: const TextStyle(fontSize: 12.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.orderDate.toString(),
                  style: const TextStyle(fontSize: 12.0),
                ),
                GestureDetector(
                  child: Text(
                    'Status: $statusText${locationText.isNotEmpty ? ' ($locationText)' : ''}',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders Detail'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return _buildOrderCard(orders[index]);
              },
            ),
    );
  }
}
