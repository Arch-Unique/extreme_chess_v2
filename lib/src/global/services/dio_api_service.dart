import 'package:extreme_chess_v2/src/global/interfaces/api_service.dart';
import 'package:extreme_chess_v2/src/global/model/barrel.dart';
import 'package:extreme_chess_v2/src/global/model/user.dart';
import 'package:extreme_chess_v2/src/global/services/barrel.dart';
import 'package:extreme_chess_v2/src/src_barrel.dart';
import 'package:extreme_chess_v2/src/utils/constants/prefs/prefs.dart';
import 'package:dio/dio.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:socket_io_client/socket_io_client.dart';

class DioApiService extends GetxService implements ApiService {
  final Dio _dio;
  RequestOptions? _lastRequestOptions;
  CancelToken _cancelToken = CancelToken();
  final prefService = Get.find<MyPrefService>();
  Rx<ErrorTypes> currentErrorType = ErrorTypes.noInternet.obs;
  Socket socket = io(
      AppUrls.homeURL,
      OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .disableAutoConnect() // disable auto-connection
          // .setExtraHeaders({'foo': 'bar'}) // optional
          .setPath("/playgame")
          .build());

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
    // print(response);
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
        ? {"x-access-token": prefService.get(MyPrefs.mpUserJWT) ?? ""}
        : {};
  }

  List<T> getListOf<T>(dynamic rawRes) {
    // assert((T == Facility) || (T == Patient) || (T == Donation));
    print(rawRes);

    List<T> fg = [];

    if (rawRes is List) {
      final res = rawRes;
      for (var i = 0; i < res.length; i++) {
        final f = res[i];
        if (T == AvailableUser) {
          fg.add(AvailableUser.fromJson(f) as T);
        } else if (T == User) {
          fg.add(User.fromJson(f) as T);
        } else if (T == Game) {
          fg.add(Game.fromJson(f) as T);
        } else if (T == Contributor) {
          fg.add(Contributor.fromJson(f) as T);
        }
      }
    }
    if (fg.isEmpty) {
      // fg = _demoList<T>();
      // print(fg);
    }
    print(fg);

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
