
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductModel {
  final String id, author, description, imageUrl, name, genre;
  final double price;

  ProductModel({
    required this.id,
    required this.author,
    required this.description,
    required this.imageUrl,
    required this.name,
    required this.genre,
    required this.price,
  });

  // Factory method to create a ProductModel from Firestore data
  factory ProductModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ProductModel(
      id: id, // Use the passed doc ID as the product ID
      author: data['author'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      name: data['name'] ?? '',
      genre: data['genre'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
    );
  }
}

// Function to fetch all products sorted by price (descending)
Future<List<ProductModel>> fetchProducts() async {
  List<ProductModel> products = [];

  try {
    // Replace 'products' with the name of your Firestore collection
    CollectionReference collection =
        FirebaseFirestore.instance.collection('products');

    // Query the products collection and order by price (descending)
    QuerySnapshot querySnapshot =
        await collection.orderBy('price', descending: true).get();

    // Map Firestore documents to ProductModel
    products = querySnapshot.docs.map((doc) {
      return ProductModel.fromFirestore(doc.data() as Map<String, dynamic>,
          doc.id); // Pass doc.id as the product ID
    }).toList();
  } catch (e) {
    print("Error fetching products: $e");
  }

  return products;
}

// Function to fetch best sellers based on sales count
Future<List<ProductModel>> fetchBestSellers() async {
  List<ProductModel> bestSellers = [];

  try {
    // Replace 'products' with the name of your Firestore collection
    CollectionReference collection =
        FirebaseFirestore.instance.collection('products');

    // Query for products with sales count >= 100
    QuerySnapshot querySnapshot = await collection
        .where("salesCount",
            isGreaterThan: 1) // Fetch products with salesCount > 1
        .orderBy("salesCount",
            descending: true) // Order by salesCount in descending order
        .get();

    // Map Firestore documents to ProductModel
    bestSellers = querySnapshot.docs.map((doc) {
      return ProductModel.fromFirestore(doc.data() as Map<String, dynamic>,
          doc.id); // Pass doc.id as the product ID
    }).toList();
  } catch (e) {
    print("Error fetching best sellers: $e");
  }

  return bestSellers;
}

// Function to fetch new arrivals based on creation timestamp
Future<List<ProductModel>> fetchNewArrivals() async {
  List<ProductModel> newArrival = [];

  try {
    // Replace 'products' with the name of your Firestore collection
    CollectionReference collection =
        FirebaseFirestore.instance.collection('products');

    // Query for products ordered by the 'createdAt' timestamp (descending)
    QuerySnapshot querySnapshot = await collection
        .orderBy('createdAt',
            descending: true) // Get most recent products first
        .get();

    // Map Firestore documents to ProductModel
    newArrival = querySnapshot.docs.map((doc) {
      return ProductModel.fromFirestore(doc.data() as Map<String, dynamic>,
          doc.id); // Pass doc.id as the product ID
    }).toList();
  } catch (e) {
    print("Error fetching new arrivals: $e");
  }

  return newArrival;
}

// Function to fetch bookmarked products based on user wishlist
Future<List<ProductModel>> fetchBookmarkedProducts() async {
  List<ProductModel> bookmarkedProducts = [];

  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      print("User is not logged in.");
      return [];
    }

    // Get the user's wishlist
    final wishlistRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('wishlist');

    final wishlistSnapshot = await wishlistRef.get();

    if (wishlistSnapshot.docs.isEmpty) {
      print("No products in wishlist.");
      return [];
    }

    // Get product IDs from the wishlist
    List<String> productIds =
        wishlistSnapshot.docs.map((doc) => doc['productId'] as String).toList();

    // Fetch products from the 'products' collection using the IDs
    final productsCollection =
        FirebaseFirestore.instance.collection('products');
    final querySnapshot = await productsCollection
        .where(FieldPath.documentId, whereIn: productIds)
        .get();

    // Map Firestore documents to ProductModel
    bookmarkedProducts = querySnapshot.docs.map((doc) {
      return ProductModel.fromFirestore(
          doc.data(), doc.id);
    }).toList();
  } catch (e) {
    print("Error fetching bookmarked products: $e");
  }

  return bookmarkedProducts;
}

// Function to fetch new arrivals based on creation timestamp
Future<List<ProductModel>> fetchBookCategory() async {
  // ignore: non_constant_identifier_names
  List<ProductModel> BookCategory = [];

  try {
    // Replace 'products' with the name of your Firestore collection
    CollectionReference collection =
        FirebaseFirestore.instance.collection('products');

    // Query for products ordered by the 'createdAt' timestamp (descending)
    QuerySnapshot querySnapshot = await collection.get();

    // Map Firestore documents to ProductModel
    BookCategory = querySnapshot.docs.map((doc) {
      return ProductModel.fromFirestore(doc.data() as Map<String, dynamic>,
          doc.id); // Pass doc.id as the product ID
    }).toList();
  } catch (e) {
    print("Error fetching Book Category: $e");
  }

  return BookCategory;
}
