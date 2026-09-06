---
name: create-controller
description: Creates a GetX controller in a module’s controllers folder and registers it in that module’s binding with Get.lazyPut. Use whenever the user asks to create a controller, says get create controller, wants a new GetxController on a screen or module, or passes on/with like get create controller:dialog on home.
---

# Create controller

Add a GetxController the same way `get create controller:name on folder` does. Write the file from the templates in this skill. Do not copy an existing controller — those files often contain feature-specific API and UI logic.

## Name and options

From the user (`dialog`, `dialogcontroller`, `get create controller:dialog on home`):

| Piece | Meaning |
|---|---|
| name | Controller identity |
| `on {folder}` | Module/folder to place it in. Search `lib` for a directory whose path contains `/{folder}/` as a segment. Prefer `lib/app/modules/{folder}` when it exists. If no folder matches, stop and say so. |
| `with {file-or-url}` | Optional custom template. Local dart file or a URL that returns dart. |

1. Trim a trailing `controller` (any case) so `dialogcontroller` and `dialog` both become `dialog`.
2. `snake` = snake_case. `pascal` = PascalCase.
3. Class is always `{pascal}Controller`.
4. File is always `{snake}_controller.dart`.

## Destination

If `on` is set, write:

```
{found-folder}/controllers/{snake}_controller.dart
```

Create `controllers/` if it is missing.

If `on` is omitted, write:

```
lib/app/controllers/{snake}_controller.dart
```

If that file already exists, ask before overwriting.

## Default file

When `with` is not given, write:

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

## Custom template (`with`)

Read the file or URL body, then replace:

| Token | Replacement |
|---|---|
| `@controller` | `{pascal}Controller` |
| `@view` | `{pascal}View` |
| `@screen` | `{pascal}Screen` |
| `@binding` | `{pascal}Binding` |
| `@package` | package `name` from `pubspec.yaml` |
| `@import` | `import 'package:get/get.dart';` |

Write the substituted dart to the destination path above.

## Binding

After the controller file exists, find a binding to register it:

Walk up from the controller’s directory looking for a file named `{folder}_binding.dart` or `{folder}.controller.binding.dart`, where `{folder}` is the `on` name (snake_case). Example: `on home` → `home_binding.dart`.

If a binding is found:

1. Add an import for the new controller next to the other relative imports, e.g. `import '../controllers/{snake}_controller.dart';` (adjust `../` to the real relative path from the binding file).
2. Skip the import if it is already there.
3. Inside `void dependencies() {`, insert at the top of the body:

```dart
    Get.lazyPut<{pascal}Controller>(
      () => {pascal}Controller(),
    );
```

Keep the binding’s existing `Get.lazyPut` calls. Match its indent and trailing-comma style.

If no binding file is found, leave routing/DI alone — the controller file is still created.

Do not create a view, a new binding, or a route. This skill only adds a controller (and updates an existing binding when one belongs to that folder).

## Done

The work is done when:

- `{snake}_controller.dart` exists at the destination with class `{pascal}Controller`.
- If a matching binding existed, it imports that controller and `Get.lazyPut`s it inside `dependencies()`.

## Examples

**`get create controller:dialog on home`**

```
lib/app/modules/home/controllers/dialog_controller.dart
```

Class `DialogController`. `home_binding.dart` gains the import and:

```dart
    Get.lazyPut<DialogController>(
      () => DialogController(),
    );
```

**`get create controller:dialogcontroller on home`**

Same files as above (`dialog` after stripping the `controller` suffix) so the class is `DialogController`, not `DialogcontrollerController`.

**`get create controller:auth`** (no `on`)

```
lib/app/controllers/auth_controller.dart
```

Register in a binding only if `auth_binding.dart` is found while walking up from that file.
