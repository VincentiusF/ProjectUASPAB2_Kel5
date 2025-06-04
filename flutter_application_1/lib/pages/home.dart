import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/favorite.dart';
import 'package:flutter_application_1/pages/keranjang.dart';
import 'package:flutter_application_1/pages/search.dart';
import 'package:flutter_application_1/pages/profile_screen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> items = [
    {
      'id': 1,
      'name': 'VINA VENTISQUERO RESERVA MERLOT 88AG 2021',
      'price': 447000,
      'image': 'wine1.jpg'
    },
    {
      'id': 2,
      'name': 'VINA VENTISQUERO CLASSICO CABERNET SAUVIGNON 2018',
      'price': 516000,
      'image': 'wine2.jpg'
    },
    {
      'id': 3,
      'name': 'MONTES ALPHA MERLOT',
      'price': 516000,
      'image': 'wine3.jpg',
    },
    {
      'id': 4,
      'name': 'CATENA ALAMOS MALBEC',
      'price': 447000,
      'image': 'wine4.jpg'
    },
  ];

  String _selectedSort = 'Popularity';

  Future<void> _addToCart(Map<String, dynamic> item) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> cart = [];

    String? cartData = prefs.getString('cart');
    if (cartData != null) {
      cart = List<Map<String, dynamic>>.from(json.decode(cartData));
    }

    int index = cart.indexWhere((cartItem) => cartItem['id'] == item['id']);
    if (index >= 0) {
      cart[index]['quantity'] += 1;
    } else {
      cart.add({
        'id': item['id'],
        'name': item['name'],
        'image': item['image'],
        'price': item['price'],
        'quantity': 1
      });
    }

    prefs.setString('cart', json.encode(cart));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item['name']} added to cart')),
    );
  }

  Future<void> _addToFavorites(Map<String, dynamic> item) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> favorites = [];

    String? favoritesData = prefs.getString('favorites');
    if (favoritesData != null) {
      favorites = List<Map<String, dynamic>>.from(json.decode(favoritesData));
    }

    bool isAlreadyFavorite =
        favorites.any((favoriteItem) => favoriteItem['id'] == item['id']);

    if (!isAlreadyFavorite) {
      favorites.add(item);
      prefs.setString('favorites', json.encode(favorites));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${item['name']} added to favorites')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${item['name']} is already in favorites')),
      );
    }
  }

  void _sortItems(String criterion) {
    setState(() {
      _selectedSort = criterion;
      if (criterion == 'Price: Low to High') {
        items.sort((a, b) => a['price'].compareTo(b['price']));
      } else if (criterion == 'Price: High to Low') {
        items.sort((a, b) => b['price'].compareTo(a['price']));
      }
    });
  }

  int _selectedIndex = 0;

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WineSearchPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FavoritePage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Go Wine"),
        backgroundColor: Colors.brown,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
            tooltip: 'Cart',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/images/banner-wine.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Sort by:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: _selectedSort,
                    items: const [
                      DropdownMenuItem(
                          value: 'Popularity', child: Text('Popularity')),
                      DropdownMenuItem(
                          value: 'Price: Low to High',
                          child: Text('Price: Low to High')),
                      DropdownMenuItem(
                          value: 'Price: High to Low',
                          child: Text('Price: High to Low')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        _sortItems(value);
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final imageIndex = index + 1;
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'lib/images/wine$imageIndex.jpg'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(10)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Rp ${item['price'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => _addToCart(item),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.brown,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    child: const Text('Add to Cart'),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.favorite_border, color: Colors.red),
                                    onPressed: () => _addToFavorites(item),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.brown,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: _onBottomNavTapped,
      ),
    );
  }
}
