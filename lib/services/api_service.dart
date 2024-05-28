import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.escuelajs.co/api/v1'));

  Future<String?> login(String username, String password) async {
    try {
      final response = await _dio.post(
        'https://dummyjson.com/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        return response.data['token'];
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<dynamic>> getProducts() async {
    try {
      final response = await _dio.get('/products', queryParameters: {'offset': 0, 'limit': 20});
      return response.data;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> createProduct(Map<String, dynamic> productData) async {
    try {
      await _dio.post('/products', data: productData);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateProduct(int id, Map<String, dynamic> productData) async {
    try {
      await _dio.put('/products/$id', data: productData);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _dio.delete('/products/$id');
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }
}
