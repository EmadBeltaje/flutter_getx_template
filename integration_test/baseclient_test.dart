import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/services/base_client.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:integration_test/integration_test.dart';


/// this is widget test for BaseClient and the main point of it
/// is to test if BaseClient shows error (Snackbar) automatically if you
/// don't pass onError() callback


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // adapter to mock dio
  final dioAdapter = DioAdapter(dio: BaseClient.dio);

  // dummy url
  String url = 'https://www.facebook.com/emadbeltaje';

  group('Error cases in BaseClient', () {
    testWidgets('Error case with error message from api', (tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            body: Center(child: Text('Testing..')),
          ),
        ),
      );

      // mock dio response
      String apiErrorMessage = 'Bad Request';
      dioAdapter.onPost(url, (server) {
        server.reply(400, {
          'error': apiErrorMessage,
        });
      });

      // perform api request
      await BaseClient.safeApiCall(
        url,
        RequestType.post,
        onSuccess: (res) {},
      );

      // update ui to show the snackbar
      await tester.pumpAndSettle();

      // in unauthorized request we expect 2 things
      // 1- snackbar should be displayed
      // 2- snackbar text must be our error message from api
      expect(Get.isSnackbarOpen, true);
      expect(find.text(apiErrorMessage), findsOneWidget);

      // close snackbar
      await Future.delayed(const Duration(seconds: 2));
      Get.closeAllSnackbars();
      await tester.pumpAndSettle();
    });


    testWidgets('Error case with no message from api', (tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            body: Center(child: Text('Testing..')),
          ),
        ),
      );

      // mock dio response
      dioAdapter.onPost(url, (server) {
        server.reply(401, null);
      });

      // perform api request
      await BaseClient.safeApiCall(
        url,
        RequestType.post,
        onSuccess: (res) {},
      );

      // update ui to show the snackbar
      await tester.pumpAndSettle();

      // in error case with no message from api we expect
      // snackbar to be displayed
      // and the message will be from dio (so it will not be user friendly)
      // you can always change message from ApiException => toString() method
      expect(Get.isSnackbarOpen, true);

      // close snackbar
      await Future.delayed(const Duration(seconds: 2));
      Get.closeAllSnackbars();
      await tester.pumpAndSettle();
    });
  });
}
