import 'dart:io';

import 'package:extreme_chess_v2/src/global/ui/ui_barrel.dart';
import 'package:dio/dio.dart';

class AppDioInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    late String failure;
    bool isServerError = false;
    print(err);
    switch (err.type) {
      case DioErrorType.badResponse:
        {
          print(err.response);
          String message = "An error ocurred";
          // if (err.response != null) {
          //   if (err.response?.data != null) {
          //     if (err.response?.data is Map<String, dynamic>) {
          //       // Check if it's a map
          //       if (err.response?.data["errors"] != null) {
          //         message = handleError(err.response?.data["errors"]);
          //       }
          //     } else {
          //       // Check if it's a list
          //       isServerError = true;
          //       message = "Server Internal Error";
          //     }
          //   }
          // }
          failure = message;
          break;
        }
      case DioErrorType.cancel:
        // Handle cancellation error
        failure = "Request cancelled.";
        break;

      case DioErrorType.sendTimeout:
        // Handle send timeout error
        failure = "Request timed out while sending data.";
        break;

      case DioErrorType.receiveTimeout:
        // Handle receive timeout error
        failure = "Request timed out while receiving data.";
        break;

      case DioErrorType.unknown:
        // Handle unknown error
        failure = "An unknown error occurred.";
        if (err.error is SocketException) {
          failure = "Network Unavailable";
        }

        break;

      case DioErrorType.connectionTimeout:
        // Handle connection timeout error
        failure = "Connection to the server timed out.";
        break;

      case DioErrorType.badCertificate:
        // Handle bad certificate error
        failure = "Encountered a bad SSL certificate.";
        break;

      case DioErrorType.connectionError:
        // Handle connection error
        failure = "Encountered a connection error.";
        break;
    }
    if (!isServerError) {
      Ui.showError(failure);
    }
    if (err.response == null) {
      handler.resolve(Response(
          requestOptions: RequestOptions(),
          statusCode: 0,
          statusMessage: "Network Unavailable"));
    } else {
      handler.resolve(err.response!);
    }
    // super.onError(err, handler);
  }

  static String handleError(dynamic msg) {
    if (msg is List) {
      if (msg.length == 1) {
        return msg[0];
      }
      return msg.join("\n");
    }
    return msg.toString();
  }
}
