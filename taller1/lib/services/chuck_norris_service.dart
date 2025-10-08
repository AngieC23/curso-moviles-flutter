import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/joke.dart';

class ChuckNorrisService {
  // Obtener la URL base desde las variables de entorno, con fallback
  static String get _baseUrl => 
      dotenv.env['CHUCK_NORRIS_API_URL'] ?? 'https://api.chucknorris.io/jokes';
  
  static const Duration _timeout = Duration(seconds: 10);

  // Método para verificar la configuración del servicio
  static void logConfiguration() {
    print('🔧 Chuck Norris Service Configuration:');
    print('   Base URL: $_baseUrl');
    print('   Timeout: $_timeout');
    print('   Environment loaded: ${dotenv.isEveryDefined(['CHUCK_NORRIS_API_URL'])}');
  }

  // Obtener un chiste aleatorio
  static Future<Joke> getRandomJoke() async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/random'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return Joke.fromJson(jsonData);
      } else {
        throw HttpException(
            'Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } on TimeoutException {
      throw Exception('Tiempo de espera agotado. Verifica tu conexión a internet.');
    } on SocketException {
      throw Exception('Sin conexión a internet. Verifica tu red.');
    } on FormatException {
      throw Exception('Error al procesar la respuesta del servidor.');
    } on HttpException {
      rethrow;
    } catch (e) {
      throw Exception('Error inesperado: ${e.toString()}');
    }
  }

  // Obtener chistes por categoría
  static Future<Joke> getJokeByCategory(String category) async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/random?category=$category'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return Joke.fromJson(jsonData);
      } else {
        throw HttpException(
            'Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } on TimeoutException {
      throw Exception('Tiempo de espera agotado. Verifica tu conexión a internet.');
    } on SocketException {
      throw Exception('Sin conexión a internet. Verifica tu red.');
    } on FormatException {
      throw Exception('Error al procesar la respuesta del servidor.');
    } on HttpException {
      rethrow;
    } catch (e) {
      throw Exception('Error inesperado: ${e.toString()}');
    }
  }

  // Obtener categorías disponibles
  static Future<List<String>> getCategories() async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/categories'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.cast<String>();
      } else {
        throw HttpException(
            'Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } on TimeoutException {
      throw Exception('Tiempo de espera agotado. Verifica tu conexión a internet.');
    } on SocketException {
      throw Exception('Sin conexión a internet. Verifica tu red.');
    } on FormatException {
      throw Exception('Error al procesar la respuesta del servidor.');
    } on HttpException {
      rethrow;
    } catch (e) {
      throw Exception('Error inesperado: ${e.toString()}');
    }
  }

  // Buscar chistes por texto
  static Future<List<Joke>> searchJokes(String query) async {
    if (query.trim().isEmpty) {
      throw const FormatException('La búsqueda no puede estar vacía.');
    }

    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/search?query=${Uri.encodeQueryComponent(query)}'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> jokesJson = jsonData['result'] ?? [];
        return jokesJson.map((joke) => Joke.fromJson(joke)).toList();
      } else {
        throw HttpException(
            'Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } on TimeoutException {
      throw Exception('Tiempo de espera agotado. Verifica tu conexión a internet.');
    } on SocketException {
      throw Exception('Sin conexión a internet. Verifica tu red.');
    } on FormatException {
      throw Exception('Error al procesar la respuesta del servidor.');
    } on HttpException {
      rethrow;
    } catch (e) {
      throw Exception('Error inesperado: ${e.toString()}');
    }
  }

  // Obtener múltiples chistes aleatorios para el listado
  static Future<List<Joke>> getMultipleRandomJokes({int count = 10}) async {
    final List<Joke> jokes = [];
    final List<Future<Joke>> futures = [];

    // Crear múltiples peticiones paralelas
    for (int i = 0; i < count; i++) {
      futures.add(getRandomJoke());
    }

    try {
      // Esperar a que todas las peticiones se completen
      final results = await Future.wait(futures);
      jokes.addAll(results);
      
      // Remover duplicados por ID
      final Map<String, Joke> uniqueJokes = {};
      for (final joke in jokes) {
        uniqueJokes[joke.id] = joke;
      }
      
      return uniqueJokes.values.toList();
    } catch (e) {
      // Si falla la carga múltiple, intentar al menos una
      try {
        final singleJoke = await getRandomJoke();
        return [singleJoke];
      } catch (e2) {
        rethrow;
      }
    }
  }
}