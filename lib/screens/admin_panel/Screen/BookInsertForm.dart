import 'dart:io';

import 'package:bookstore/constants.dart';
import 'package:bookstore/route/screen_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class BookStoreAdmin extends StatefulWidget {
  @override
  State<BookStoreAdmin> createState() => _BookStoreAdminState();
}

class _BookStoreAdminState extends State<BookStoreAdmin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Add book form state variables
  String _title = '';
  String _author = '';
  String _description = '';
  String _genre = '';
  String _price = '';
  XFile? _imageFile; // Variable to store the selected image

  // Drawer navigation logic
  int _selectedIndex = 0; // Initially selected index for drawer items

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Store Admin'),
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
              title: const Text('User Profile'),
             onTap: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminUserAccount()),
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "Book Insert Form ",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: defaultPadding),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Title',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title.';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _title = newValue!,
                  ),
                  const SizedBox(height: defaultPadding),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Author',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the author.';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _author = newValue!,
                  ),
                  const SizedBox(height: defaultPadding),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Genre',
                      hintMaxLines: 5,
                    ),
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Genre.';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _description = newValue!,
                  ),
                  const SizedBox(height: defaultPadding),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'description',
                    ),
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description.';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _genre = newValue!,
                  ),
                  const SizedBox(height: defaultPadding),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Price',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Price.';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _price = newValue!,
                  ),
                  const SizedBox(height: defaultPadding),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Choose Cover Image'),
                  ),
                  if (_imageFile != null)
                    Image.file(
                      File(_imageFile!.path),
                      height: 100,
                      width: 100,
                    ),
                  const SizedBox(height: defaultPadding),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // Add book to database or perform other actions, including uploading the image
                        print(
                            'Book added: $_title by $_author ($_description) with genre $_genre and price $_price');
                        // Handle image upload here:
                        // ...
                      }
                    },
                    child: const Text('Add Book'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogout() {
    // Implement logic to handle logout, such as navigating to a login screen
    Navigator.pushNamed(context, logInScreenRoute); // Example
  }
}
