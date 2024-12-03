import 'package:bookstore/screens/admin_panel/Screen/DrawerWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookStoreView extends StatefulWidget {
  const BookStoreView({super.key});

  @override
  _BookStoreViewState createState() => _BookStoreViewState();
}

class _BookStoreViewState extends State<BookStoreView> {
  List<Book> books = [];
  List<String> docIds = []; // Store document IDs
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('products').get();
      List<Book> fetchedBooks = [];
      List<String> fetchedDocIds = [];

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        fetchedBooks.add(
          Book(
            title: data['name'] ?? '',
            author: data['author'] ?? '',
            genre: data['genre'] ?? '',
            description: data['description'] ?? '',
            price: (data['price'] ?? 0).toDouble(),
            imageUrl: data['imageUrl'] ?? '',
          ),
        );
        fetchedDocIds.add(doc.id); // Save document IDs
      }

      setState(() {
        books = fetchedBooks;
        docIds = fetchedDocIds;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching books: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteBook(int index) async {
    try {
      String docId = docIds[index];
      print('Deleting document with ID: $docId');

      // Delete the document from Firestore
      await FirebaseFirestore.instance
          .collection('products')
          .doc(docId)
          .delete();

      // Update UI after deletion
      setState(() {
        books.removeAt(index);
        docIds.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book deleted successfully')),
      );
    } catch (e) {
      print('Error deleting document: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting book')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Store'),
      ),
      drawer: const DrawerWidget(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                return BookItem(
                  book: books[index],
                  onDelete: () => deleteBook(index), // Pass delete function
                );
              },
            ),
    );
  }
}

class BookItem extends StatelessWidget {
  final Book book;
  final VoidCallback onDelete; // Callback for delete action

  const BookItem({super.key, required this.book, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Display
          if (book.imageUrl.isNotEmpty)
            Image.network(
              book.imageUrl,
              width: 100,
              height: 150,
              fit: BoxFit.cover,
            )
          else
            Container(
              width: 100,
              height: 150,
              color: Colors.grey[300],
              child: const Icon(Icons.image_not_supported),
            ),
          const SizedBox(width: 10.0),
          // Book Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'by ${book.author}',
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    'Genre: ${book.genre}',
                    style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    book.description,
                    style: TextStyle(fontSize: 12.0, color: Colors.grey[500]),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    '\$${book.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Delete Button
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete, // Call delete action
          ),
        ],
      ),
    );
  }
}

class Book {
  final String title;
  final String author;
  final String genre;
  final String description;
  final double price;
  final String imageUrl;

  Book({
    required this.title,
    required this.author,
    required this.genre,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}
