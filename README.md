# Quizzical App

A Flutter quiz application built with a modular architecture following MVC pattern and using Riverpod for state management.

## 📁 Project Structure

The project follows a feature-based modular architecture:

```
lib/
├── app/                          # Feature modules
│   ├── welcome/                  # Welcome screen feature
│   │   ├── controller/          # Welcome screen controllers (Riverpod)
│   │   ├── model/               # Welcome screen models and states
│   │   ├── view/                # Welcome screen views
│   │   └── widgets/             # Welcome screen specific widgets
│   │
│   └── category/                # Category selection feature
│       ├── controller/          # Category controllers
│       ├── model/              # Category models and states
│       ├── view/               # Category views
│       └── widgets/            # Category specific widgets
│
├── core/                        # Core functionality
│   └── routes/                 # App routing configuration
│
├── shared/                      # Shared resources
│   ├── constants/              # App-wide constants
│   └── widgets/               # Reusable widgets
│
└── main.dart                    # App entry point
```

## 🏗️ Architecture Features

- **MVC + Widget Pattern**: Clean separation of concerns
- **Riverpod State Management**: Reactive and type-safe
- **Modular Design**: Features are self-contained
- **Shared Resources**: Consistent styling and reusable components
- **Type-safe Routing**: Using GoRouter

## 🎨 Design System

- **Primary Color**: Sea Green (#2E8B57)
- **Custom Components**: Reusable buttons, cards, and layouts
- **Responsive Design**: Adapts to different screen sizes
