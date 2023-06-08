import 'package:dio/dio.dart';

abstract class ApiService {
  Future<Response> get(String url);
  Future<Response> post(String url, {dynamic data});
  Future<Response> patch(String url, {dynamic data});
  Future<Response> delete(String url, {dynamic data});
  Future<Response> retryLastRequest();
  void cancelLastRequest();
}
