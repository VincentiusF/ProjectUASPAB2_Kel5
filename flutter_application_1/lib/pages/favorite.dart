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
              .whereType<Map<String, dynamic>>()
              .where((item) => item['id'] != null)
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
      backgroundColor: Colors.brown.shade50,
      appBar: AppBar(
        title: const Text(
          "Favorites",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.brown,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: favoriteItems.isEmpty
          ? const Center(
              child: Text(
                "Favorite Kosong!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                final item = favoriteItems[index];

                final image = item['image'] ?? 'lib/images/no-image.png';
                final name = item['name'] ?? 'Unknown Wine';
                final price = item['price'] ?? 0;
                final id = item['id'] ?? 'unknown';

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.brown.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Builder(
                        builder: (_) {
                          if (image.toString().startsWith('http')) {
                            return Image.network(
                              image,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'lib/images/no-image.png',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                );
                              },
                            );
                          } else if (image.toString().length > 100) {
                            try {
                              final bytes = base64Decode(image);
                              return Image.memory(
                                bytes,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              );
                            } catch (e) {
                              return Image.asset(
                                'lib/images/no-image.png',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              );
                            }
                          } else {
                            return Image.asset(
                              image,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            );
                          }
                        },
                      ),
                    ),
                    title: Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}',
                        style: const TextStyle(
                          color: Colors.brown,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _removeFromFavorites(id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
