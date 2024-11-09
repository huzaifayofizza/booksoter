import 'package:bookstore/constants.dart';
import 'package:bookstore/route/route_constants.dart';
import 'package:bookstore/route/screen_export.dart';
import 'package:bookstore/screens/admin_panel/Screen/BookInsertForm.dart';
import 'package:flutter/material.dart';

class AdminUserAccount extends StatefulWidget {
  @override
  _AdminUserAccountState createState() => _AdminUserAccountState();
}

class _AdminUserAccountState extends State<AdminUserAccount> {
  List<User> users = [
    User(email: 'user1@example.com', password: 'password1'),
    User(email: 'user2@example.com', password: 'password2'),
    // Add more users here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Store Admin'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Book Store Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Book View'),
              onTap: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookStoreView()),
                  );
                });
              },
            ),
            ListTile(
              title: const Text('Book Insert'),
              onTap: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookStoreAdmin()),
                  );
                });
              },
            ),
            ListTile(
              title: const Text('Orders Manage'),
              onTap: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminOrderManage()),
                  );
                });
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () => _handleLogout(), // Implement logout logic here
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50.0),
              Text(
                "User Accounts ",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: defaultPadding),
              DataTable(
                columns: [
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Password')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: [
                  // Add data rows for each user account
                  DataRow(
                    cells: [
                      DataCell(Text('huzaifafizza981770@gmail.com')),
                      DataCell(
                          Text('***********')), // Password should be hidden
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                // Handle edit button press
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                // Handle delete button press
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('danishhanif123@gmail.com')),
                      DataCell(
                          Text('***********')), // Password should be hidden
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                // Handle edit button press
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                // Handle delete button press
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Add more data rows for other user accounts
                ],
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
}

class User {
  final String email;
  final String password;

  User({required this.email, required this.password});
}
