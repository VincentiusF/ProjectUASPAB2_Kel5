import 'package:flutter/material.dart';
import '../services/gemini_service.dart';

class WineRecommendationPage extends StatefulWidget {
  const WineRecommendationPage({Key? key}) : super(key: key);

  @override
  _WineRecommendationPageState createState() => _WineRecommendationPageState();
}

class _WineRecommendationPageState extends State<WineRecommendationPage> {
  final TextEditingController _preferencesController = TextEditingController();
  final GeminiService _geminiService = GeminiService();
  String _recommendation = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekomendasi Wine'),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.brown[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Ceritakan preferensi wine Anda, seperti rasa yang disukai, jenis makanan yang akan disantap, atau suasana yang ingin diciptakan.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _preferencesController,
                decoration: InputDecoration(
                  labelText: 'Preferensi Wine Anda',
                  hintText: 'Contoh: "Saya suka wine yang manis dan buah-buahan, untuk diminum saat makan malam romantis"',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _getRecommendation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: _isLoading 
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Dapatkan Rekomendasi', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 24),
              if (_recommendation.isNotEmpty)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Rekomendasi Wine:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.brown,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Divider(),
                        const SizedBox(height: 8),
                        Text(_recommendation),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getRecommendation() async {
    if (_preferencesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan masukkan preferensi Anda')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final recommendation = await _geminiService.getWineRecommendation(
        _preferencesController.text,
      );
      
      setState(() {
        _recommendation = recommendation;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _recommendation = 'Error: $e';
        _isLoading = false;
      });
    }
  }
}