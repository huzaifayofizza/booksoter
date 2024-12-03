import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/screens/admin_panel/Screen/DrawerWidget.dart';

class Order {
  final String id;
  final String productName;
  final double price;
  final String customerName;
  final String status;
  final int quantity;
  final double amount;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final DateTime orderDate;

  Order({
    required this.id,
    required this.productName,
    required this.price,
    required this.customerName,
    required this.status,
    required this.quantity,
    required this.amount,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.orderDate,
  });

  get orderId => null;
}

class AdminOrderManage extends StatefulWidget {
  const AdminOrderManage({super.key});

  @override
  State<AdminOrderManage> createState() => _AdminOrderManageState();
}

class _AdminOrderManageState extends State<AdminOrderManage> {
  List<Order> orders = []; // List to store fetched orders
  bool isLoading = true; // For loading state

  @override
  void initState() {
    super.initState();
    fetchOrders(); // Fetch orders on initialization
  }

  Future<void> fetchOrders() async {
    try {
      QuerySnapshot orderSnapshot =
          await FirebaseFirestore.instance.collection('orderData').get();

      List<Order> fetchedOrders = [];
      for (var doc in orderSnapshot.docs) {
        Map<String, dynamic> orderData = doc.data() as Map<String, dynamic>;

        // Fetch product details
        DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
            .collection('products')
            .doc(orderData['productId'])
            .get();
        Map<String, dynamic> productData =
            productSnapshot.data() as Map<String, dynamic>;

        // Fetch user details
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(orderData['uid'])
            .get();
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        fetchedOrders.add(Order(
          id: doc.id,
          productName: productData['name'] ?? 'Unknown Product',
          price: productData['price']?.toDouble() ?? 0.0,
          customerName: userData['fullname'] ?? 'Unknown User',
          status: orderData['status'] ?? 'Pending',
          quantity: orderData['quantity'] ?? 1,
          amount: (productData['price']?.toDouble() ?? 0.0) *
              (orderData['quantity'] ?? 1),
          address: orderData['address'] ?? 'N/A',
          city: orderData['city'] ?? 'N/A',
          state: orderData['state'] ?? 'N/A',
          zipCode: orderData['zipCode'] ?? 'N/A',
          cardNumber: orderData['cardNumber'] ?? 'N/A',
          expiryDate: orderData['expiryDate'] ?? 'N/A',
          cvv: orderData['cvv'] ?? 'N/A',
          orderDate: (orderData['orderDate'] as Timestamp?)?.toDate() ??
              DateTime.now(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Store Admin - Orders'),
      ),
      drawer: const DrawerWidget(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Orders Management',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // Enable horizontal scroll
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('S.No')),
                        DataColumn(label: Text('Product Name')),
                        DataColumn(label: Text('Price')),
                        DataColumn(label: Text('Customer')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Quantity')),
                        DataColumn(label: Text('Total Amount')),
                        DataColumn(label: Text('Address')),
                        DataColumn(label: Text('City')),
                        DataColumn(label: Text('State')),
                        DataColumn(label: Text('Zip Code')),
                        DataColumn(label: Text('Card Number')),
                        DataColumn(label: Text('Expiry Date')),
                        DataColumn(label: Text('CVV')),
                        DataColumn(label: Text('Order Date')),
                      ],
                      rows: orders
                          .asMap()
                          .entries
                          .map((entry) =>
                              _buildOrderDataRow(entry.key + 1, entry.value))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  DataRow _buildOrderDataRow(int index, Order order) {
    return DataRow(
      cells: [
        DataCell(Text(index.toString())),
        DataCell(Text(order.productName)),
        DataCell(Text('\$${order.price.toStringAsFixed(2)}')),
        DataCell(Text(order.customerName)),
        DataCell(Text(order.status)),
        DataCell(Text(order.quantity.toString())),
        DataCell(Text('\$${order.amount.toStringAsFixed(2)}')),
        DataCell(Text(order.address)),
        DataCell(Text(order.city)),
        DataCell(Text(order.state)),
        DataCell(Text(order.zipCode)),
        DataCell(Text(order.cardNumber)),
        DataCell(Text(order.expiryDate)),
        DataCell(Text(order.cvv)),
        DataCell(Text(order.orderDate.toString())),
      ],
    );
  }
}
