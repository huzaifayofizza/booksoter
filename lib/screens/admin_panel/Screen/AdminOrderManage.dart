import 'package:bookstore/constants.dart';
import 'package:bookstore/route/route_constants.dart';
import 'package:bookstore/route/screen_export.dart';

import 'package:bookstore/screens/admin_panel/Screen/DrawerWidget.dart';

import 'package:flutter/material.dart';

// Assuming you have a model class for Order (replace with yours)
class Order {
  final int id;
  final String status;
  final int quantity; // Assuming quantity is relevant
  final String customerName; // Assuming customer name is relevant
  final double amount;

  const Order(
      this.id, this.status, this.quantity, this.customerName, this.amount);
}

class AdminOrderManage extends StatefulWidget {
  @override
  State<AdminOrderManage> createState() => _AdminOrderManageState();
}

class _AdminOrderManageState extends State<AdminOrderManage> {
  // Sample fake order data
  final List<Order> orders = [
    Order(1, 'Pending', 2, 'John Doe', 39.99),
    Order(2, 'Shipped', 1, 'Jane Smith', 19.95),
    Order(3, 'Completed', 3, 'Michael Brown', 54.87),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Store Admin'),
      ),
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50.0),
              Text(
                'Orders Management',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: defaultPadding),
              DataTable(
                columns: const [
                  DataColumn(label: Text('S.No')),
                  DataColumn(label: Text('Order Status')),
                  DataColumn(label: Text('Quantity')),
                  DataColumn(label: Text('Customer Name')),
                  DataColumn(label: Text('Amount')),
                ],
                rows: orders.map((order) => _buildOrderDataRow(order)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogout() {
    // Implement logic to handle logout, such as navigating to a login screen
    Navigator.pushNamed(context, logInScreenRoute); // Example
  }

  DataRow _buildOrderDataRow(Order order) {
    return DataRow(
      cells: [
        DataCell(Text(order.id.toString())),
        DataCell(Text(order.status)),
        DataCell(Text(order.quantity.toString())),
        DataCell(Text(order.customerName)),
        DataCell(Text('\$${order.amount.toStringAsFixed(2)}')),
      ],
    );
  }
}
