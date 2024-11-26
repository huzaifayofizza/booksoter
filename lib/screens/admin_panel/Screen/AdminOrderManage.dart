import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/screens/admin_panel/Screen/DrawerWidget.dart';

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
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('orders').get();
      List<Order> fetchedOrders = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Order(
          id: int.parse(doc.id), // Assuming the document ID is numeric
          status: data['status'] ?? 'Unknown',
          quantity: data['quantity'] ?? 0,
          customerName: data['customerName'] ?? 'Unknown',
          amount: (data['amount'] ?? 0.0).toDouble(),
        );
      }).toList();

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
      drawer: DrawerWidget(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loader
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50.0),
                    Text(
                      'Orders Management',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 16.0),
                    DataTable(
                      columns: const [
                        DataColumn(label: Text('S.No')),
                        DataColumn(label: Text('Order Status')),
                        DataColumn(label: Text('Quantity')),
                        DataColumn(label: Text('Customer Name')),
                        DataColumn(label: Text('Amount')),
                      ],
                      rows: orders
                          .asMap()
                          .entries
                          .map((entry) =>
                              _buildOrderDataRow(entry.key + 1, entry.value))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  DataRow _buildOrderDataRow(int index, Order order) {
    return DataRow(
      cells: [
        DataCell(Text(index.toString())), // Row number
        DataCell(Text(order.status)),
        DataCell(Text(order.quantity.toString())),
        DataCell(Text(order.customerName)),
        DataCell(Text('\$${order.amount.toStringAsFixed(2)}')),
      ],
    );
  }
}

class Order {
  final int id;
  final String status;
  final int quantity;
  final String customerName;
  final double amount;

  Order({
    required this.id,
    required this.status,
    required this.quantity,
    required this.customerName,
    required this.amount,
  });
}
