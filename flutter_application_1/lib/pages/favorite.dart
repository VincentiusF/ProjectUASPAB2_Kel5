import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritePage extends StatefulWidget {
  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Map<String, dynamic>> favoriteItems = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    String? favoritesData = prefs.getString('favorites');
    if (favoritesData != null) {
      try {
        final List<dynamic> decoded = json.decode(favoritesData);
        setState(() {
          favoriteItems = decoded
              .whereType<Map<String, dynamic>>() // hanya data map
              .where((item) => item['id'] != null) // pastikan ada id
              .toList();
        });
      } catch (e) {
        print('Error loading favorites: $e');
      }
    }
  }

  Future<void> _removeFromFavorites(dynamic id) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteItems
          .removeWhere((item) => item['id']?.toString() == id?.toString());
    });
    await prefs.setString('favorites', json.encode(favoriteItems));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Wine berhasil dihapus dari favorit')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Favorites",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: favoriteItems.isEmpty
          ? const Center(
              child: Text(
                "No favorites yet!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                final item = favoriteItems[index];

                final image = item['image'] ?? 'lib/images/no-image.png';
                final name = item['name'] ?? 'Unknown Wine';
                final price = item['price'] ?? 0;
                final id = item['id'] ?? 'unknown';

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: image.toString().startsWith('http')
                          ? Image.network(
                              image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'lib/images/no-image.png',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          : Image.asset(
                              image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                    ),
                    title: Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeFromFavorites(id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
