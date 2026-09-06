# Agent

Read `.agent/context/architecture.md` and `.agent/context/coding-guideline.md` first, every chat, before touching any code — not just when a specific request seems to need them. They cover the project structure, layers, and conventions that apply no matter what's being built.

Skills teach **how**. This file picks **which** skill under `.agent/skills/` to open for the current request. Open every listed skill that applies, then follow it. Skip skills that do not apply.

| User wants | Open |
|---|---|
| New screen / page / module | `create-screen` + `ui-conventions` |
| New screen that also loads data | `create-screen` + `api-request` + `ui-conventions` |
| New widget, or edit a widget/screen UI | `ui-conventions` |
| New widget with new copy / language | `ui-conventions` + `localization` |
| New widget with new colors / extension | `ui-conventions` + `theme` |
| New controller only | `create-controller` |
| Theme, dark/light, default theme, colors, ThemeExtension, fonts | `theme` |
| Language, default language, translations, new locale | `localization` |
| New language that needs a new font | `localization` + `theme` |
| Rename the app | `rename-app` |
| Change package name / applicationId / bundle id | `change-package-name` |
| API / HTTP / fetch / BaseClient | `api-request` + `ui-conventions` |

Each name above is a folder under `.agent/skills/{name}/SKILL.md`.

Examples: "create a login screen" → `create-screen` + `ui-conventions`. "create a stats card widget" → `ui-conventions` (and `localization` / `theme` if copy or colors are new). "get todos on home" → `api-request` + `ui-conventions`.