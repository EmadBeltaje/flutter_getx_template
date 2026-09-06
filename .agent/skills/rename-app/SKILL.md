---
name: rename-app
description: Renames the Flutter app display name on all platforms using rename_app. Use when the user asks to rename the app, change the app name, or set the launcher name.
---

# Rename app

If the user did not give a name, ask for it before running anything.

Then from the project root:

```
flutter pub run rename_app:main all="{App Name}"
```

Example: `flutter pub run rename_app:main all="My App Name"`

Done when the command exits 0. Report the name that was applied.
