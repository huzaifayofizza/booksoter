import 'dart:io';

import 'package:bookstore/constants.dart';
import 'package:bookstore/route/screen_export.dart';
import 'package:bookstore/screens/admin_panel/Screen/DrawerWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class BookStoreAdmin extends StatefulWidget {
  @override
  State<BookStoreAdmin> createState() => _BookStoreAdminState();
}

class _BookStoreAdminState extends State<BookStoreAdmin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  final _nameController = TextEditingController();
  final _genreController = TextEditingController();
  final _authorController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  XFile? _imageFile;
  String? _imageUrl;
  bool _isLoading = false;

  final cloudinary = CloudinaryPublic(
    'daqa1s0x8', // Replace with your cloud name
    'book_image', // Replace with your upload preset
    cache: false,
  );

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<String?> _uploadToCloudinary() async {
    if (_imageFile == null) return null;

    try {
      CloudinaryResponse response;

      if (kIsWeb) {
        // For web platform
        final bytes = await _imageFile!.readAsBytes();
        response = await cloudinary.uploadFile(
          CloudinaryFile.fromBytesData(
            bytes,
            identifier: 'upload',
            folder: 'products',
            resourceType: CloudinaryResourceType.Image,
          ),
        );
      } else {
        // For mobile platform
        response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(
            _imageFile!.path,
            folder: 'products',
            resourceType: CloudinaryResourceType.Image,
          ),
        );
      }

      return response.secureUrl;
    } catch (e) {
      print('Error uploading to Cloudinary: $e');
      return null;
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate() || _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and select an image')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Upload image to Cloudinary
      _imageUrl = await _uploadToCloudinary();

      if (_imageUrl == null) throw Exception('Failed to upload image');

      // Save product data to Firestore
      await FirebaseFirestore.instance.collection('products').add({
        'name': _nameController.text,
        'author': _authorController.text,
        'genre': _genreController.text,
        'description': _descriptionController.text,
        'price': double.parse(_priceController.text),
        'imageUrl': _imageUrl,
         'createdAt': FieldValue.serverTimestamp(),
         'salesCount' : 0,

         
      });

      // Clear form fields after successful submission
      _nameController.clear();
      _authorController.clear();
      _genreController.clear();
      _priceController.clear();
      _descriptionController.clear();
      setState(() {
        _imageFile = null;
        _imageUrl = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product uploaded successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading product: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Store Admin'),
      ),
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title.';
                      }
                    },
                  ),
                  const SizedBox(height: defaultPadding),
                  TextFormField(
                    controller: _authorController,
                    decoration: const InputDecoration(
                      labelText: 'author',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a author.';
                      }
                    },
                  ),
                  const SizedBox(height: defaultPadding),
                  TextFormField(
                    controller: _genreController,
                    decoration: const InputDecoration(
                      labelText: 'Genre',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Genre.';
                      }
                    },
                  ),
                  const SizedBox(height: defaultPadding),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Description.';
                      }
                    },
                  ),
                  const SizedBox(height: defaultPadding),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Price.';
                      }
                    },
                  ),
                  const SizedBox(height: defaultPadding),
                  ElevatedButton(
                    child: const Text('Choose Cover Image'),
                    onPressed: () => _pickImage(ImageSource.gallery),
                  ),
                  if (_imageFile != null) ...[
                    kIsWeb
                        ? Image.network(_imageFile!.path, height: 200)
                        : Image.file(File(_imageFile!.path), height: 200),
                    SizedBox(height: 16),
                  ],
                  const SizedBox(height: defaultPadding),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveProduct,
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text('Upload Product'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleLogout() {
    // Implement logic to handle logout, such as navigating to a login screen
    Navigator.pushNamed(context, logInScreenRoute); // Example
  }
}
