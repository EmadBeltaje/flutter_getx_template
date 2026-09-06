---
name: change-package-name
description: Changes the Android/iOS application id using change_app_package_name. Use when the user asks to change package name, applicationId, bundle id, or app id.
---

# Change package name

If the user did not give a package id, ask for it. It must look like `com.company.app` (dot-separated, no spaces).

Then from the project root:

```
flutter pub run change_app_package_name:main {package.id}
```

Example: `flutter pub run change_app_package_name:main com.new.package.name`

Done when the command exits 0. Report the package id that was applied.
