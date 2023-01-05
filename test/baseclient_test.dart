import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart' hide Response;
import 'package:getx_skeleton/app/services/api_exceptions.dart';
import 'package:getx_skeleton/app/services/base_client.dart';
import 'package:getx_skeleton/config/translations/strings_enum.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';


/// the main point of the test is to make sure callbacks and function work
/// as it should with returning the right values handling errors correctly
/// and returning the right message for every different situation..etc
/// tests for api call
/// Successful (get,post,put,delete) requests
/// bad request
/// unauthorized
/// url not found

void main() {
  // adapter to mock dio
  final dioAdapter = DioAdapter(dio: BaseClient.dio);

  // dummy url
  String url = 'https://www.facebook.com/emadbeltaje';


  group('success api cases', () {
    /// test successful GET request
    test('successful GET api call', () async {
      Response? response;
      ApiException? exception;

      // simulate successful get request
      dioAdapter.onGet(url, (server) {
        server.reply(200, {'test' : 'Passed ✅'});
      });

      // perform api call
      await BaseClient.safeApiCall(
          url,
          RequestType.get,
          onSuccess: (res) {
            response = res;
          },
          onError: (e) {
            exception = e;
          }
      );

      // in successful get request case we expect 3 things
      // 1- response must not be null
      // 2- exception must be null (bcz there was no error) and api made successfully
      // 3- status code must be 200
      expect(response, isNotNull,reason: 'api response must not be null');
      expect(exception, isNull,reason: 'api error must be null');
      expect(response?.statusCode, 200,reason: 'status code must be 200');
    });



    /// test successful POST request
    test('successful POST api call', () async {
      Response? response;
      ApiException? exception;

      // simulate successful post request
      dioAdapter.onPost(url, (server) {
        server.reply(201, {'test' : 'Passed ✅'});
      });

      // perform api request
      await BaseClient.safeApiCall(
          url,
          RequestType.post,
          onSuccess: (res) {
            response = res;
          },
          onError: (e) {
            exception = e;
          }
      );

      // in successful post case we expect 3 things
      // 1- response must not be null
      // 2- exception must be null (bcz there was no error) and api made successfully
      // 3- status code must be 200/201
      expect(response, isNotNull,reason: 'api response must not be null');
      expect(exception, isNull,reason: 'api error must be null');
      expect(response?.statusCode, anyOf([200,201]),reason: 'status code must be 200 or 201');
    });



    /// test successful PUT request
    test('successful PUT api call', () async {
      Response? response;
      ApiException? exception;

      // simulate successful get request
      dioAdapter.onPut(url, (server) {
        server.reply(201, {'test' : 'Passed ✅'});
      });

      // perform api request
      await BaseClient.safeApiCall(
          url,
          RequestType.put,
          onSuccess: (res) {
            response = res;
          },
          onError: (e) {
            exception = e;
          }
      );

      // in successful PUT case we expect 3 things
      // 1- response must not be null
      // 2- exception must be null (bcz there was no error) and api made successfully
      // 3- status code must be 200/201
      expect(response, isNotNull,reason: 'api response must not be null');
      expect(exception, isNull,reason: 'api error must be null');
      expect(response?.statusCode, anyOf([200,201]),reason: 'status code must be 200 or 201');
    });



    /// test successful delete request
    test('successful DELETE api call', () async {
      Response? response;
      ApiException? exception;

      // simulate successful get request
      dioAdapter.onDelete(url, (server) {
        server.reply(204, {'test' : 'Passed ✅'});
      });

      // perform api request
      await BaseClient.safeApiCall(
          url,
          RequestType.delete,
          onSuccess: (res) {
            response = res;
          },
          onError: (e) {
            exception = e;
          }
      );

      // in successful delete case we expect 3 things
      // 1- response must not be null
      // 2- exception must be null (bcz there was no error) and api made successfully
      // 3- status code must be 201/204
      expect(response, isNotNull,reason: 'api response must not be null');
      expect(exception, isNull,reason: 'api error must be null');
      expect(response?.statusCode, anyOf([200,204]),reason: 'status code must be 200 or 204');
    });
  });


  group('fail api cases', () {
    /// 400 bad request test
    test('test bad request api call 400', () async {
      Response? response;
      ApiException? exception;

      // simulate successful get request
      String apiErrorMessage = 'Bad request';
      dioAdapter.onPost(url, (server) {
        server.reply(400, {
          'test' : 'Passed ✅',
          'error': apiErrorMessage,
        });
      });

      // perform api request
      await BaseClient.safeApiCall(
          url,
          RequestType.post,
          onSuccess: (res) {
            response = res;
          },
          onError: (e) {
            exception = e;
          }
      );

      // in bad request we expect 3 things
      // 1- response must be null
      // 2- exception must not be null
      // 3- status code must be 400
      // 4- exception.toString() should be the message from api
      expect(response, isNull,reason: 'response must be null bcz onSuccess will not be triggered');
      expect(exception, isNotNull,reason: 'api error must not be null');
      expect(exception?.statusCode, 400,reason: 'status code must be 400');
      expect(exception?.toString(), apiErrorMessage,reason: 'should take the error message from api');
    });



    /// test 401 un authorized request test
    test('test un authorized api request 401', () async {
      Response? response;
      ApiException? exception;

      // simulate successful get request
      String apiErrorMessage = 'Unauthorized Request';
      dioAdapter.onPost(url, (server) {
        server.reply(401, {
          'test' : 'Passed ✅',
          'error' : apiErrorMessage,
        });
      });

      // perform api request
      await BaseClient.safeApiCall(
          url,
          RequestType.post,
          onSuccess: (res) {
            response = res;
          },
          onError: (e) {
            exception = e;
          }
      );

      // in un authorized request we expect 3 things
      // 1- response must be null
      // 2- exception must not be null
      // 3- status code must be 401
      // 4- exception.toString() should be the message from api
      expect(response, isNull,reason: 'response must be null bcz onSuccess will not be triggered');
      expect(exception, isNotNull,reason: 'api error must not be null');
      expect(exception?.statusCode, 401,reason: 'status code must be 401');
      expect(exception?.toString(), apiErrorMessage,reason: 'should take the error message from api');
    });



    /// test url not found 404
    test('test url not found api call 404', () async {
      Response? response;
      ApiException? exception;

      // simulate successful get request
      dioAdapter.onPost(url, (server) {
        server.reply(404, null);
      });

      // perform api request
      await BaseClient.safeApiCall(
          url, // we miss with the url
          RequestType.post,
          onSuccess: (res) {
            response = res;
          },
          onError: (e) {
            exception = e;
          }
      );

      // in url not found request we expect 3 things
      // 1- response must be null
      // 2- exception must not be null
      // 3- status code must be 404
      // 3- exception.toString() = 'url not found'
      expect(response, isNull,reason: 'response must be null bcz onSuccess will not be triggered');
      expect(exception, isNotNull,reason: 'api exception must not be null');
      expect(exception?.statusCode, 404,reason: 'status code must be 404');
      expect(exception?.toString(), Strings.urlNotFound.tr,reason: 'message must be (url not found)');
    });


    /// test internal server error
    test('test internal server error 500', () async {
      Response? response;
      ApiException? exception;

      // simulate successful get request
      dioAdapter.onPost(url, (server) {
        server.reply(500, null);
      });

      // perform api request
      await BaseClient.safeApiCall(
          url, // we miss with the url
          RequestType.post,
          onSuccess: (res) {
            response = res;
          },
          onError: (e) {
            exception = e;
          }
      );

      // in url not found request we expect 3 things
      // 1- response must be null
      // 2- exception must not be null
      // 3- status code must be 500
      // 4- status error
      expect(response, isNull,reason: 'response must be null bcz onSuccess will not be triggered');
      expect(exception, isNotNull,reason: 'api exception must not be null');
      expect(exception?.statusCode, 500,reason: 'status code must be 404');
      expect(exception?.toString(), Strings.serverError.tr,reason: 'message must be (server error)');
    });
  });
}
