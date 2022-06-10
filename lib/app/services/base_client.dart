import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get_utils/get_utils.dart';

import '../../config/translations/strings_enum.dart';
import '../components/custom_snackbar.dart';
import 'api_exceptions.dart';

class BaseClient {
  static final Dio _dio = Dio();
  static const int TIME_OUT_DURATION = 2;

  // GET request
  static get(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    required Function(Response response) onSuccess,
    required Function(ApiException)? onError,
    Function(int value, int progress)? onReceiveProgress,
    Function? onLoading,
  }) async {
    try {
      // 1) indicate loading state
      onLoading?.call();
      // 2) try to perform http request
      var response = await _dio.get(
        url,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        options: Options(headers: headers,),
      ).timeout(const Duration(seconds: TIME_OUT_DURATION));
      // 3) return response (api done successfully)
      await onSuccess(response);
    } on DioError catch (error) { // dio error (api reach the server but not performed successfully
      // no internet connection
      if(error.message.toLowerCase().contains('socket')){
        onError?.call(ApiException(message: Strings.noInternetConnection.tr, url: url,)) ?? _handleError(Strings.noInternetConnection.tr);
      }

      // no response
      if(error.response == null){
        var exception = ApiException(url: url, message: error.message,);
        return onError?.call(exception) ?? handleApiError(exception);
      }

      // check if the error is 500 (server problem)
      if(error.response?.statusCode == 500){
        var exception = ApiException(message: Strings.serverError.tr, url: url, statusCode: 500,);
        return onError?.call(exception) ?? handleApiError(exception);
      }
    }on SocketException { // No internet connection
      onError?.call(ApiException(message: Strings.noInternetConnection.tr, url: url,)) ?? _handleError(Strings.noInternetConnection.tr);
    } on TimeoutException { // Api call went out of time
      onError?.call(ApiException(message: Strings.serverNotResponding.tr, url: url,)) ?? _handleError(Strings.serverNotResponding.tr);
    } catch (error) { // unexpected error for example (parsing json error)
      onError?.call(ApiException(message: error.toString(), url: url,)) ?? _handleError(error.toString());
    }
  }


  /// handle error automaticly (if user didnt pass onError) method
  /// it will try to show the message from api if there is no message
  /// from api it will show the reason
  static handleApiError(ApiException apiException){
    // TODO -> ADD YOUR API ERROR MESSAGE POSITION
    String msg = apiException.response?.data?['message'] ?? apiException.message;
    CustomSnackBar.showCustomErrorToast(message: msg);
  }

  /// handle errors without response (500, out of time, no internet,..etc)
  static _handleError(String msg){
    CustomSnackBar.showCustomErrorToast(message: msg);
  }
}
