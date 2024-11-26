import 'package:bookstore/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String author, description, imageUrl, name, genre;
  final double price;

  ProductModel({
    required this.author,
    required this.description,
    required this.imageUrl,
    required this.name,
    required this.genre,
    required this.price,
  });

  // Factory method to create a ProductModel from Firestore data
  factory ProductModel.fromFirestore(Map<String, dynamic> data) {
    return ProductModel(
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
      return ProductModel.fromFirestore(doc.data() as Map<String, dynamic>);
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
      return ProductModel.fromFirestore(doc.data() as Map<String, dynamic>);
    }).toList();
  } catch (e) {
    print("Error fetching best sellers: $e");
  }

  return bestSellers;
}

// Function to fetch best sellers based on sales count
Future<List<ProductModel>> fetchnew_arrival() async {
  List<ProductModel> new_arrival = [];

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
    new_arrival = querySnapshot.docs.map((doc) {
      return ProductModel.fromFirestore(doc.data() as Map<String, dynamic>);
    }).toList();
  } catch (e) {
    print("Error fetching best sellers: $e");
  }

  return new_arrival;
}

// }
// List<ProductModel> demoFlashSaleProducts = [
//   ProductModel(
//     image: productDemoImg5,
//     title: "FS - Nike Air Max 270 Really React",
//     brandName: "Lipsy london",
//     price: 650.62,
//     priceAfetDiscount: 390.36,
//     dicountpercent: 40,
//   ),
//   ProductModel(
//     image: productDemoImg6,
//     title: "Green Poplin Ruched Front",
//     brandName: "Lipsy london",
//     price: 1264,
//     priceAfetDiscount: 1200.8,
//     dicountpercent: 5,
//   ),
//   ProductModel(
//     image: productDemoImg4,
//     title: "Mountain Beta Warehouse",
//     brandName: "Lipsy london",
//     price: 800,
//     priceAfetDiscount: 680,
//     dicountpercent: 15,
//   ),
// ];
// List<ProductModel> demoBestSellersProducts = [
//   ProductModel(
//     image: "https://i.imgur.com/tXyOMMG.png",
//     title: "Green Poplin Ruched Front",
//     brandName: "Lipsy london",
//     price: 650.62,
//     priceAfetDiscount: 390.36,
//     dicountpercent: 40,
//   ),
//   ProductModel(
//     image: "https://i.imgur.com/h2LqppX.png",
//     title: "white satin corset top",
//     brandName: "Lipsy london",
//     price: 1264,
//     priceAfetDiscount: 1200.8,
//     dicountpercent: 5,
//   ),
//   ProductModel(
//     image: productDemoImg4,
//     title: "Mountain Beta Warehouse",
//     brandName: "Lipsy london",
//     price: 800,
//     priceAfetDiscount: 680,
//     dicountpercent: 15,
//   ),
// ];
// List<ProductModel> kidsProducts = [
//   ProductModel(
//     image: "https://i.imgur.com/dbbT6PA.png",
//     title: "Green Poplin Ruched Front",
//     brandName: "Lipsy london",
//     price: 650.62,
//     priceAfetDiscount: 590.36,
//     dicountpercent: 24,
//   ),
//   ProductModel(
//     image: "https://i.imgur.com/7fSxC7k.png",
//     title: "Printed Sleeveless Tiered Swing Dress",
//     brandName: "Lipsy london",
//     price: 650.62,
//   ),
//   ProductModel(
//     image: "https://i.imgur.com/pXnYE9Q.png",
//     title: "Ruffle-Sleeve Ponte-Knit Sheath ",
//     brandName: "Lipsy london",
//     price: 400,
//   ),
//   ProductModel(
//     image: "https://i.imgur.com/V1MXgfa.png",
//     title: "Green Mountain Beta Warehouse",
//     brandName: "Lipsy london",
//     price: 400,
//     priceAfetDiscount: 360,
//     dicountpercent: 20,
//   ),
//   ProductModel(
//     image: "https://i.imgur.com/8gvE5Ss.png",
//     title: "Printed Sleeveless Tiered Swing Dress",
//     brandName: "Lipsy london",
//     price: 654,
//   ),
//   ProductModel(
//     image: "https://i.imgur.com/cBvB5YB.png",
//     title: "Mountain Beta Warehouse",
//     brandName: "Lipsy london",
//     price: 250,
//   ),
// ];
