---
name: api-request
description: Adds a BaseClient.safeApiCall method to a controller, with URL, HTTP method, return model, loading/error/success status, and optional raw JSON model. Use when the user wants an API call, HTTP request, fetch, post, BaseClient, or to load data into a screen.
---

# API request

Collect anything missing, then add the call on the named controller. Models are **raw** `fromJson` / `toJson` classes. Do not add Hive (`@HiveType`, `part '*.g.dart'`) unless the user asks for a Hive model. `UserModel` is Hive on purpose; new models are not.

## Ask for

| Field | Examples |
|---|---|
| Function name | `getTodos`, `login` |
| HTTP method | `get`, `post`, `put`, `delete` (`RequestType`) |
| URL | full URL or path to hang off `Constants.baseUrl` |
| Return type | an existing model, or JSON plus a new model name |
| Controller / screen | e.g. `home` → `HomeController` |

If any of these are missing, ask. List existing model files under `lib/app/data/models/` (ignore `*.g.dart`) so the user can pick one.

## URL

Add or reuse a constant:

```dart
class Constants {
  static const baseUrl = 'https://jsonplaceholder.typicode.com';
  static const todosApiUrl = baseUrl + '/todos';
}
```

If the URL shares `baseUrl`, add `static const {name}ApiUrl = baseUrl + '/{path}';`. Otherwise add a full `static const {name}ApiUrl = 'https://...';`.

## New raw model

When the user pastes JSON and a name (`Todo`), write `lib/app/data/models/{snake}_model.dart`. Example JSON:

```json
{
  "userId": 1,
  "id": 1,
  "title": "delectus aut autem",
  "completed": false
}
```

```dart
class TodoModel {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  TodoModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      completed: json['completed'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'completed': completed,
    };
  }
}
```

Nested objects get their own classes with `fromJson`. Lists use `List<X>.from((json['items'] as List).map((e) => X.fromJson(e)))`.

If they chose an existing model, import it and parse with that `fromJson`.

## Controller method

Find `{pascal}Controller` for the named screen/module. If it does not exist, stop and say so (create the screen/controller first).

Keep `ApiCallStatus apiCallStatus` and `update()` on the controller. Hold the result in a field matching the return type.

**GET list** (`getTodos` → `List<TodoModel>`):

```dart
import 'package:get/get.dart';

import '../../../../utils/constants.dart';
import '../../../data/models/todo_model.dart';
import '../../../services/api_call_status.dart';
import '../../../services/base_client.dart';

class HomeController extends GetxController {
  List<TodoModel>? data;
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;

  Future<void> getTodos() async {
    await BaseClient.safeApiCall(
      Constants.todosApiUrl,
      RequestType.get,
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) {
        final list = response.data as List;
        data = list
            .map((e) => TodoModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        apiCallStatus = ApiCallStatus.success;
        update();
      },
      onError: (error) {
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
      },
    );
  }

  @override
  void onInit() {
    getTodos();
    super.onInit();
  }
}
```

**POST** (body via `data:`):

```dart
  Future<void> login() async {
    await BaseClient.safeApiCall(
      Constants.loginApiUrl,
      RequestType.post,
      data: {
        'email': email,
        'password': password,
      },
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) {
        user = UserDto.fromJson(Map<String, dynamic>.from(response.data));
        apiCallStatus = ApiCallStatus.success;
        update();
      },
      onError: (error) {
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
      },
    );
  }
```

`RequestType` is `get`, `post`, `put`, `delete`. Optional args on `safeApiCall`: `headers`, `queryParameters`, `data`. If `onError` is omitted, `BaseClient` still shows an error snackbar; still set `apiCallStatus = ApiCallStatus.error` in `onError` so the UI can show the error slot.

Call the method from `onInit` when the screen should load data immediately. Otherwise leave it for a button.

`ApiCallStatus` values: `holding`, `loading`, `success`, `error`, `empty`, `cache`, `refresh`.

## View

The screen that shows this data uses `MyWidgetsAnimator` (ui-conventions). This skill only adds the request + model + URL.

## Done

- URL constant exists.
- Raw model exists or an existing one is used (no Hive unless asked).
- Named controller has the method, `ApiCallStatus`, `onLoading` / `onSuccess` / `onError`, and `update()`.
