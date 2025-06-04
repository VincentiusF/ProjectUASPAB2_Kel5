import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/wine.dart';
import '../data/data.dart';
import 'detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WineSearchPage extends StatefulWidget {
  @override
  _WineSearchPageState createState() => _WineSearchPageState();
}

class _WineSearchPageState extends State<WineSearchPage> {
  int itemsToShow = 2;
  String searchQuery = "";
  String selectedType = "";
  String selectedPrice = "";
  String selectedCountry = "";
  List<Map<String, dynamic>> cart = [];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _loadCart();
  }

  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedType = prefs.getString('selectedType') ?? '';
      selectedPrice = prefs.getString('selectedPrice') ?? '';
      selectedCountry = prefs.getString('selectedCountry') ?? '';
    });
  }

  void _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    String? cartData = prefs.getString('cart');
    if (cartData != null) {
      cart = List<Map<String, dynamic>>.from(json.decode(cartData));
    }
    setState(() {});
  }

  void _addToCart(Wine wine) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> item = {
      'name': wine.name,
      'price': _parsePrice(wine.price),
      'quantity': 1
    };

    setState(() {
      cart.add(item);
    });

    prefs.setString('cart', json.encode(cart));
  }

  void _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedType', selectedType);
    prefs.setString('selectedPrice', selectedPrice);
    prefs.setString('selectedCountry', selectedCountry);
  }

  List<Wine> get filteredWine {
    return wineData.where((wine) {
      final matchesSearch = searchQuery.isEmpty ||
          wine.name.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesType = selectedType.isEmpty ||
          wine.type.toLowerCase().contains(selectedType.toLowerCase());

      final priceInt = _parsePrice(wine.price);
      final matchesPrice = selectedPrice.isEmpty ||
          (selectedPrice == "< Rp500.000" && priceInt < 500000) ||
          (selectedPrice == "Rp500.000 - Rp1.000.000" &&
              priceInt >= 500000 &&
              priceInt <= 1000000) ||
          (selectedPrice == "> Rp1.000.000" && priceInt > 1000000);

      final matchesCountry = selectedCountry.isEmpty ||
          wine.country.toLowerCase() == selectedCountry.toLowerCase();

      return matchesSearch && matchesType && matchesPrice && matchesCountry;
    }).toList();
  }

  int _parsePrice(String price) {
    final priceWithoutCurrency = price.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(priceWithoutCurrency) ?? 0;
  }

  void loadMore() {
    setState(() {
      itemsToShow = (itemsToShow + 2).clamp(0, filteredWine.length);
    });
  }

  void resetFilters() {
    setState(() {
      selectedType = "";
      selectedPrice = "";
      selectedCountry = "";
    });
    _savePreferences();
  }

  void navigateToDetail(Wine wine) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WineDetailScreen(wine: wine),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Search"),
        titleTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
        backgroundColor: Colors.brown,
        leading: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.brown,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 218, 211, 211),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.9),
                      spreadRadius: 2,
                      blurRadius: 5)
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Cari wine",
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDropdownButton(
                    "Jenis Wine", ["Red", "White", "Sparkling"], selectedType,
                    (value) {
                  setState(() {
                    selectedType = value ?? "";
                    _savePreferences();
                  });
                }),
                const SizedBox(width: 8),
                _buildDropdownButton(
                    "Harga",
                    ["< Rp500.000", "Rp500.000 - Rp1.000.000", "> Rp1.000.000"],
                    selectedPrice, (value) {
                  setState(() {
                    selectedPrice = value ?? "";
                    _savePreferences();
                  });
                }),
                const SizedBox(width: 8),
                _buildDropdownButton(
                    "Negara",
                    ["Chile", "Argentina", "Australia", "Italy", "France"],
                    selectedCountry, (value) {
                  setState(() {
                    selectedCountry = value ?? "";
                    _savePreferences();
                  });
                }),
              ],
            ),
            const SizedBox(height: 16),
            if (selectedType.isNotEmpty ||
                selectedPrice.isNotEmpty ||
                selectedCountry.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (selectedType.isNotEmpty)
                    Chip(
                      label: Text(selectedType),
                      onDeleted: () {
                        setState(() {
                          selectedType = "";
                          _savePreferences();
                        });
                      },
                      deleteIcon: const Icon(Icons.close),
                    ),
                  if (selectedPrice.isNotEmpty)
                    Chip(
                      label: Text(selectedPrice),
                      onDeleted: () {
                        setState(() {
                          selectedPrice = "";
                          _savePreferences();
                        });
                      },
                      deleteIcon: const Icon(Icons.close),
                    ),
                  if (selectedCountry.isNotEmpty)
                    Chip(
                      label: Text(selectedCountry),
                      onDeleted: () {
                        setState(() {
                          selectedCountry = "";
                          _savePreferences();
                        });
                      },
                      deleteIcon: const Icon(Icons.close),
                    ),
                ],
              ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredWine.isEmpty
                  ? Center(child: Text("No results found"))
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.50,
                      ),
                      itemCount: itemsToShow.clamp(0, filteredWine.length),
                      itemBuilder: (context, index) {
                        final wine = filteredWine[index];
                        return GestureDetector(
                          onTap: () => navigateToDetail(wine),
                          child: Card(
                            elevation: 10,
                            shadowColor: Colors.black45,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(wine.imagePath),
                                        fit: BoxFit.fill,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(wine.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text("${wine.region}, ${wine.country}"),
                                      Text("${wine.type}"),
                                      Text("Rp${wine.price}",
                                          style: TextStyle(color: Colors.red)),
                                      const SizedBox(height: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          _addToCart(wine);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    "Wine berhasil ditambahkan ke keranjang")),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                          backgroundColor: Colors.brown,
                                        ),
                                        child: Container(
                                          width: double.infinity,
                                          child: Center(
                                            child: Text(
                                              "Tambah Ke Keranjang",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            if (itemsToShow < filteredWine.length)
              ElevatedButton.icon(
                onPressed: loadMore,
                icon: const Icon(Icons.add, color: Colors.black),
                label: const Text("Load More",
                    style: TextStyle(color: Colors.black)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownButton(String hint, List<String> items,
      String selectedValue, Function(String?) onChanged) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 218, 211, 211),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: DropdownButtonFormField<String>(
          value: selectedValue.isEmpty ? null : selectedValue,
          decoration: InputDecoration(
            labelText: hint,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          ),
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: onChanged,
          isExpanded: true,
        ),
      ),
    );
  }
}
