import 'dart:convert';
import 'package:http/http.dart' as http;


class GeminiService {
  // API key untuk Gemini - sebaiknya gunakan variabel lingkungan atau metode penyimpanan aman lainnya
  final String apiKey = 'AIzaSyDzM9UJqwcHaQNGVL_2rS3R2S2emakvxQk';
  // URL yang diperbarui untuk API Gemini - menggunakan model terbaru
  final String baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

  // Metode untuk mendapatkan rekomendasi wine berdasarkan preferensi pengguna
  Future<String> getWineRecommendation(String userPreference) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text': 'Kamu adalah sommelier wine profesional. Berdasarkan preferensi berikut, rekomendasikan wine yang cocok: $userPreference. Berikan detail tentang rasa, aroma, dan dengan makanan apa wine tersebut cocok disantap. Jawab dalam Bahasa Indonesia.'
                }
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 300,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Print response untuk debugging
        print('Gemini API Response: $data');
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        print('Gemini API Error: ${response.statusCode}, Body: ${response.body}');
        return 'Error mendapatkan rekomendasi: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      print('Exception during API call: $e');
      return 'Gagal mendapatkan rekomendasi: $e';
    }
  }
}