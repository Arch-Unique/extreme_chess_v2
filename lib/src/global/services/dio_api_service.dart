import 'package:extreme_chess_v2/src/global/interfaces/api_service.dart';
import 'package:extreme_chess_v2/src/global/services/barrel.dart';
import 'package:extreme_chess_v2/src/src_barrel.dart';
import 'package:extreme_chess_v2/src/utils/constants/prefs/prefs.dart';
import 'package:dio/dio.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';

class DioApiService extends GetxService implements ApiService {
  final Dio _dio;
  RequestOptions? _lastRequestOptions;
  CancelToken _cancelToken = CancelToken();
  final prefService = Get.find<MyPrefService>();
  Rx<ErrorTypes> currentErrorType = ErrorTypes.noInternet.obs;

  DioApiService()
      : _dio = Dio(
          BaseOptions(baseUrl: AppUrls.baseURL),
        ) {
    _dio.interceptors.add(AppDioInterceptor());
  }

  @override
  Future<Response> delete(String url, {data, bool hasToken = true}) async {
    final response = await _dio.delete(url,
        data: data,
        cancelToken: _cancelToken,
        options: Options(headers: _getHeader(hasToken)));
    _lastRequestOptions = response.requestOptions;

    return response;
  }

  @override
  Future<Response> get(String url, {bool hasToken = true}) async {
    final response = await _dio.get(url,
        cancelToken: _cancelToken,
        options: Options(headers: _getHeader(hasToken)));
    _lastRequestOptions = response.requestOptions;

    return response;
  }

  @override
  Future<Response> patch(String url, {data, bool hasToken = true}) async {
    final response = await _dio.patch(url,
        data: data,
        cancelToken: _cancelToken,
        options: Options(headers: _getHeader(hasToken)));
    _lastRequestOptions = response.requestOptions;

    return response;
  }

  @override
  Future<Response> post(String url, {data, bool hasToken = true}) async {
    final response = await _dio.post(url,
        data: data,
        cancelToken: _cancelToken,
        options: Options(headers: _getHeader(hasToken)));
    _lastRequestOptions = response.requestOptions;

    return response;
  }

  @override
  Future<Response> retryLastRequest() async {
    if (_lastRequestOptions != null) {
      final response = await _dio.request(
        _lastRequestOptions!.path,
        data: _lastRequestOptions!.data,
        options: Options(
          method: _lastRequestOptions!.method,
          headers: _lastRequestOptions!.headers,
          // Add any other options if needed
        ),
        cancelToken: _cancelToken,
      );

      return response;
    }
    return Response(
        requestOptions: RequestOptions(),
        statusCode: 404,
        statusMessage: "No Last Request");
  }

  @override
  void cancelLastRequest() {
    _cancelToken.cancel('Request cancelled');
    _cancelToken = CancelToken();
  }

  isSuccess(int? statusCode) {
    return UtilFunctions.isSuccess(statusCode);
  }

  Map<String, dynamic>? _getHeader([bool hasToken = true]) {
    return hasToken
        ? {
            "Authorization":
                "Bearer ${prefService.get(MyPrefs.mpUserJWT) ?? ""}"
          }
        : {};
  }

  List<T> getListOf<T>(dynamic rawRes) {
    // assert((T == Facility) || (T == Patient) || (T == Donation));
    print(rawRes);

    List<T> fg = [];

    // if (rawRes is List) {
    //   final res = rawRes;
    //   for (var i = 0; i < res.length; i++) {
    //     final f = res[i];
    //     if (T == Facility) {
    //       fg.add(Facility.fromJson(f) as T);
    //     } else if (T == Patient) {
    //       fg.add(Patient.fromJson(f) as T);
    //     } else if (T == Donation) {
    //       fg.add(Donation.fromJson(f) as T);
    //     }
    //   }
    // }
    if (fg.isEmpty) {
      // fg = _demoList<T>();
      print(fg);
    }

    return fg;
  }

  // List<T> _demoList<T>() {
  //   List<T> fg = [];
  //   if (T == Facility) {
  //     fg = List.generate(
  //         10,
  //         (index) => Facility(
  //             patients: List.generate(Random().nextInt(10),
  //                 (index) => Patient(id: index.toString()))) as T);
  //   } else if (T == Patient) {
  //     fg = List.generate(
  //         Random().nextInt(10), (index) => Patient(id: index.toString()) as T);
  //   } else if (T == Donation) {
  //     fg = List.generate(
  //         Random().nextInt(10),
  //         (index) => Donation(
  //             rawdate: DateTime.now().subtract(Duration(days: index * 3)),
  //             patient: Patient()) as T);
  //   }
  //   print(T);
  //   return fg;
  // }
}
