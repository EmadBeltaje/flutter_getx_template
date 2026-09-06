---
name: create-screen
description: Creates a GetX screen module (controller, view, binding) under lib/app/modules and registers it in app routes. Use whenever the user asks to create a screen, page, or module, says get create screen, get create page, get create module, or wants a new GetX view plus controller plus binding with routing.
---

# Create screen

Scaffold a new GetX module: view, controller, binding, and route. This repo uses GetX Pattern (`lib/app/modules`). Write new screens there. Do not create `lib/presentation` — that layout is a different architecture and is not wired to `AppPages`.

Start from the templates in this skill, then add only extra UI or logic the user asked for. Existing modules may contain feature-specific API and widgets; those are not the scaffold.

## Name

Take the screen name from the user (`home`, `login`, `user profile`, `get create screen:home`). Optional parent: `on home` / `inside home` / `on the home module`.

1. Trim trailing `screen`, `view`, `page`, or `module` (any case) so `LoginScreen` becomes `login`.
2. `snake` = snake_case. `pascal` = PascalCase.
3. Classes are `{pascal}View`, `{pascal}Controller`, `{pascal}Binding`.
4. Files are `{snake}_view.dart`, `{snake}_controller.dart`, `{snake}_binding.dart`.
5. Route path segment is `/{snake}` with underscores turned into hyphens (`user_profile` → `/user-profile`).

## Destination

Read `pubspec.yaml` for the package `name`.

Find a directory named `modules` under `lib` (this repo: `lib/app/modules`).

| `on` parent | Folder |
|---|---|
| none | `{modules}/{snake}/` |
| given | Find a directory under `lib` whose path contains `/{parent}/` as a segment (prefer `{modules}/{parent}`). Put the new module at `{parent-dir}/{snake}/`. If no such folder exists, stop and say so. |

If that destination folder already exists, ask before overwriting. Do not silently replace it.

Create three subfolders: `bindings/`, `controllers/`, `views/`.

## Files

Write all three from the templates below. Substitute `{pascal}`, `{snake}`, and keep relative imports.

**`controllers/{snake}_controller.dart`**

```dart
import 'package:get/get.dart';

class {pascal}Controller extends GetxController {
  //TODO: Implement {pascal}Controller

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
```

**`views/{snake}_view.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/{snake}_controller.dart';

class {pascal}View extends GetView<{pascal}Controller> {
  const {pascal}View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('{pascal}View'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          '{pascal}View is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
```

**`bindings/{snake}_binding.dart`**

```dart
import 'package:get/get.dart';

import '../controllers/{snake}_controller.dart';

class {pascal}Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<{pascal}Controller>(
      () => {pascal}Controller(),
    );
  }
}
```

## Routes

Find `app_pages.dart` and `app_routes.dart` under `lib` (this repo: `lib/app/routes/`). Match the identifier style already used in those files (this repo uses lowercase: `home`, not `HOME`).

**`app_routes.dart`**

Inside `Routes`, add:

```dart
  static const {routeId} = _Paths.{routeId};
```

If this screen is nested (`on` a parent), instead:

```dart
  static const {routeId} = _Paths.{parentId} + _Paths.{routeId};
```

Inside `_Paths`, add:

```dart
  static const {routeId} = '/{route-segment}';
```

`{routeId}` matches existing style (`login` if the file uses `home`). `{route-segment}` is the snake name with `_` → `-`.

**`app_pages.dart`**

Add relative imports next to the existing module imports:

```dart
import '../modules/{path-from-modules}/bindings/{snake}_binding.dart';
import '../modules/{path-from-modules}/views/{snake}_view.dart';
```

`{path-from-modules}` is `{snake}` or `{parent}/{snake}`.

Insert a `GetPage` using the same shape already in the file:

```dart
    GetPage(
      name: _Paths.{routeId},
      page: () => const {pascal}View(),
      binding: {pascal}Binding(),
    ),
```

- Top-level: insert it in `static final routes` before the closing `];`.
- Nested (`on` parent): find the parent `GetPage`. If it has no `children`, add a `children: [ ... ]` list. Put the new `GetPage` inside that list. Leave the parent view and controller untouched.

If `_Paths` does not exist, use `Routes.{routeId}` as the `name:` and set `Routes.{routeId} = '/{route-segment}'`.

## Done

The work is done when:

- The three dart files exist at the destination and compile against the templates above.
- `app_routes.dart` declares the new path.
- `app_pages.dart` imports the view and binding and lists the `GetPage` (top-level or as a child).

## Examples

**`get create screen:home` / "create a home screen"**

```
lib/app/modules/home/bindings/home_binding.dart
lib/app/modules/home/controllers/home_controller.dart
lib/app/modules/home/views/home_view.dart
```

`Routes.home = _Paths.home`, `_Paths.home = '/home'`, plus a top-level `GetPage`.

**`get create screen:login on home` / "create a login screen on home"**

```
lib/app/modules/home/login/bindings/login_binding.dart
lib/app/modules/home/login/controllers/login_controller.dart
lib/app/modules/home/login/views/login_view.dart
```

`Routes.login = _Paths.home + _Paths.login`, `_Paths.login = '/login'`, and a child `GetPage` on home.
