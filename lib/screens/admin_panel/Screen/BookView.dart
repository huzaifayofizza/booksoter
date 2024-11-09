import 'package:bookstore/route/route_constants.dart';
import 'package:bookstore/route/screen_export.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(BookStoreView());
}

class BookStoreView extends StatefulWidget {
  @override
  _BookStoreViewState createState() => _BookStoreViewState();
}

class _BookStoreViewState extends State<BookStoreView> {
  // Sample book data, replace with your actual data source
  List<Book> books = [
    Book(
      title: 'The Lord of the Rings',
      author: 'J.R.R. Tolkien',
      genre: 'Fantasy',
      description: 'An epic high-fantasy tale of hobbits, rings, and fellowship.',
      price: 19.99,
      // imageUrl: 'assets/illustration/EmptyState_darkTheme.png',
    ),
    Book(
      title: 'Pride and Prejudice',
      author: 'Jane Austen',
      genre: 'Romance',
      description: 'A witty and romantic tale of love and social class.',
      price: 9.99,
      // imageUrl: 'assets/illustration/Failed_darkTheme.png',
    ),
    // Add more books here
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
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          return BookItem(book: books[index]);
        },
      ),
    );
  }
    void _handleLogout() {
    // Implement logic to handle logout, such as navigating to a login screen
    Navigator.pushNamed(context, logInScreenRoute); // Example
  }
}

class BookItem extends StatelessWidget {
  final Book book;

  const BookItem({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Image.asset(
            //   book.imageUrl,
            //   width: 30.0,
            //   height: 20.0,
            //   fit: BoxFit.cover,
            // ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'by ${book.author}',
                    style: TextStyle(fontSize: 12.0),
                  ),
                  Text(
                    book.genre,
                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                  SizedBox(height: 8.0),

                  Text(book.description, 
                    style: TextStyle(fontSize: 12.0, color: Colors.grey),),

                  SizedBox(height: 8.0),
                  Text(
                    '\$${book.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
  // final String imageUrl;

  Book({
    required this.title,
    required this.author,
    required this.genre,
    required this.description,
    required this.price,
    // required this.imageUrl,
  });

  
}