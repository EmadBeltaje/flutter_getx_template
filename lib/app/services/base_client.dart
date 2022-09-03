import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get_utils/get_utils.dart';

import '../../config/translations/strings_enum.dart';
import '../components/custom_snackbar.dart';
import 'api_exceptions.dart';

class BaseClient {
  static final Dio _dio = Dio();
  static const int TIME_OUT_DURATION = 50000; // in milliseconds

  // GET request
  static get(
      String url, {
        Map<String, dynamic>? headers,
        Map<String, dynamic>? queryParameters,
        required Function(Response response) onSuccess,
        Function(ApiException)? onError,
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
      _handleDioError(error: error, url: url,onError: onError);
    }on SocketException { // No internet connection
      _handleSocketException(url: url,onError: onError);
    } on TimeoutException { // Api call went out of time
      _handleTimeoutException(url: url,onError: onError);
    } catch (error) { // unexpected error for example (parsing json error)
      _handleUnexpectedException(url: url,onError: onError,error: error);
    }
  }

  // POST request
  static post(
      String url, {
        Map<String, dynamic>? headers,
        Map<String, dynamic>? queryParameters,
        required Function(Response response) onSuccess,
        Function(ApiException)? onError,
        Function(int total, int progress)? onSendProgress, // while sending (uploading) progress
        Function(int total, int progress)? onReceiveProgress, // while receiving data(response)
        Function? onLoading,
        dynamic data,
      }) async {
    try {
      // 1) indicate loading state
      onLoading?.call();
      // 2) try to perform http request
      var response = await _dio.post(
        url,
        data: data,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
        queryParameters: queryParameters,
        options: Options(headers: headers,receiveTimeout: TIME_OUT_DURATION,sendTimeout: TIME_OUT_DURATION),
      );
      // 3) return response (api done successfully)
      await onSuccess.call(response);
    } on DioError catch (error) { // dio error (api reach the server but not performed successfully
      _handleDioError(error: error, url: url,onError: onError);
    }on SocketException { // No internet connection
      _handleSocketException(url: url,onError: onError);
    } on TimeoutException { // Api call went out of time
      _handleTimeoutException(url: url,onError: onError);
    } catch (error) { // unexpected error for example (parsing json error)
      _handleUnexpectedException(url: url,onError: onError,error: error);
    }
  }


  // PUT request
  static put(
      String url, {
        Map<String, dynamic>? headers,
        Map<String, dynamic>? queryParameters,
        required Function(Response response) onSuccess,
        Function(ApiException)? onError,
        Function(int total, int progress)? onSendProgress, // while sending (uploading) progress
        Function(int total, int progress)? onReceiveProgress, // while receiving data(response)
        Function? onLoading,
        dynamic data,
      }) async {
    try {
      // 1) indicate loading state
      onLoading?.call();
      // 2) try to perform http request
      var response = await _dio.put(
        url,
        data: data,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
        queryParameters: queryParameters,
        options: Options(headers: headers,receiveTimeout: TIME_OUT_DURATION,sendTimeout: TIME_OUT_DURATION),
      );
      // 3) return response (api done successfully)
      await onSuccess.call(response);
    } on DioError catch (error) { // dio error (api reach the server but not performed successfully
      _handleDioError(error: error, url: url,onError: onError);
    }on SocketException { // No internet connection
      _handleSocketException(url: url,onError: onError);
    } on TimeoutException { // Api call went out of time
      _handleTimeoutException(url: url,onError: onError);
    } catch (error) { // unexpected error for example (parsing json error)
      _handleUnexpectedException(url: url,onError: onError,error: error);
    }
  }


  // DELETE request
  static delete(
      String url, {
        Map<String, dynamic>? headers,
        Map<String, dynamic>? queryParameters,
        required Function(Response response) onSuccess,
        Function(ApiException)? onError,
        Function? onLoading,
        dynamic data,
      }) async {
    try {
      // 1) indicate loading state
      onLoading?.call();
      // 2) try to perform http request
      var response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers,receiveTimeout: TIME_OUT_DURATION,sendTimeout: TIME_OUT_DURATION),
      );
      // 3) return response (api done successfully)
      await onSuccess.call(response);
    } on DioError catch (error) { // dio error (api reach the server but not performed successfully
      _handleDioError(error: error, url: url,onError: onError);
    }on SocketException { // No internet connection
      _handleSocketException(url: url,onError: onError);
    } on TimeoutException { // Api call went out of time
      _handleTimeoutException(url: url,onError: onError);
    } catch (error) { // unexpected error for example (parsing json error)
      _handleUnexpectedException(url: url,onError: onError,error: error);
    }
  }

  /// download file
  static download({
    required String url, // file url
    required String savePath, // where to save file
    Function(ApiException)? onError,
    Function(int value,int progress)? onReceiveProgress,
    required Function onSuccess
  }) async {
    try{
      await _dio.download(
        url,
        savePath,
        options: Options(receiveTimeout: 999999,sendTimeout: 999999),
        onReceiveProgress: onReceiveProgress,
      );
      onSuccess();
    }catch(error){
      var exception = ApiException(url: url, message: error.toString());
      onError?.call(exception) ?? _handleError(error.toString());
    }
  }


  /// handle unexpected error
  static _handleUnexpectedException({Function(ApiException)? onError,required String url,required Object error}) {
    onError?.call(ApiException(message: error.toString(), url: url,)) ?? _handleError(error.toString());
  }

  /// handle timeout exception
  static _handleTimeoutException({Function(ApiException)? onError,required String url}) {
    onError?.call(ApiException(message: Strings.serverNotResponding.tr, url: url,)) ?? _handleError(Strings.serverNotResponding.tr);
  }

  /// handle timeout exception
  static _handleSocketException({Function(ApiException)? onError,required String url}) {
    onError?.call(ApiException(message: Strings.noInternetConnection.tr, url: url,)) ?? _handleError(Strings.noInternetConnection.tr);
  }

  /// handle Dio error
  static _handleDioError({required DioError error,Function(ApiException)? onError,required String url}) {
    // no internet connection
    if(error.message.toLowerCase().contains('socket')){
      return onError?.call(ApiException(message: Strings.noInternetConnection.tr, url: url,)) ?? _handleError(Strings.noInternetConnection.tr);
    }

    // check if the error is 500 (server problem)
    if(error.response?.statusCode == 500){
      var exception = ApiException(message: Strings.serverError.tr, url: url, statusCode: 500,);
      return onError?.call(exception) ?? handleApiError(exception);
    }

    var exception = ApiException(url: url, message: error.message,response: error.response,statusCode: error.response?.statusCode);
    return onError?.call(exception) ?? handleApiError(exception);
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
