import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';

class WineInputPage extends StatefulWidget {
  @override
  _WineInputPageState createState() => _WineInputPageState();
}

class _WineInputPageState extends State<WineInputPage> {
  final _formKey = GlobalKey<FormState>();
  final _database = FirebaseDatabase.instance.ref('wines');

  final _nameController = TextEditingController();
  final _regionController = TextEditingController();
  final _priceController = TextEditingController();

  String _selectedType = '';
  String _selectedCountry = '';

  Uint8List? _selectedImageBytes;
  String? _imageFileName;

  final List<String> wineTypes = ['Red', 'White', 'Sparkling'];
  final List<String> countries = [
    'Chile',
    'Argentina',
    'Australia',
    'Italy',
    'France'
  ];

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _selectedImageBytes = result.files.single.bytes;
        _imageFileName = result.files.single.name;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImageBytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Harap pilih gambar terlebih dahulu')),
        );
        return;
      }

      final wineData = {
        'name': _nameController.text.trim(),
        'region': _regionController.text.trim(),
        'price': _priceController.text.trim(),
        'type': _selectedType,
        'country': _selectedCountry,
        'imageFileName': _imageFileName ?? '',
        'image': base64Encode(_selectedImageBytes!), // ✅ simpan base64
      };

      await _database.push().set(wineData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wine berhasil disimpan ke Firebase!')),
      );

      _formKey.currentState?.reset();
      setState(() {
        _selectedType = '';
        _selectedCountry = '';
        _selectedImageBytes = null;
        _imageFileName = null;
      });
    }
  }

  Widget _buildDropdown(String label, List<String> items, String selectedValue,
      ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedValue.isEmpty ? null : selectedValue,
      decoration: InputDecoration(labelText: label),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      validator: (value) =>
          value == null || value.isEmpty ? 'Wajib dipilih' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Wine'),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.brown.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.brown),
                  ),
                  child: _selectedImageBytes == null
                      ? Center(
                          child: Text(
                            'Klik untuk memilih gambar wine',
                            style: TextStyle(color: Colors.brown),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(_selectedImageBytes!,
                              fit: BoxFit.cover),
                        ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama Wine'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _regionController,
                decoration: InputDecoration(labelText: 'Region'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration:
                    InputDecoration(labelText: 'Harga (contoh: 150000)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              SizedBox(height: 16),
              _buildDropdown('Jenis Wine', wineTypes, _selectedType, (val) {
                setState(() => _selectedType = val ?? '');
              }),
              SizedBox(height: 16),
              _buildDropdown('Negara', countries, _selectedCountry, (val) {
                setState(() => _selectedCountry = val ?? '');
              }),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Simpan Wine'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
