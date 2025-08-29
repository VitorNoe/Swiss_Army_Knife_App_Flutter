# Swiss Army Knife App

This is a multi-functional Flutter application, designed to be a digital "Swiss Army Knife," offering a variety of utilities for daily tasks. The application includes unit converters, measurement converters, text tools, a calculator, a password generator, a currency converter, and date and time tools.

## Features

- **Unit Converter**: Convert between different units of measurement (length, weight, temperature, volume).
- **Measurement Converter**: Convert between imperial and metric systems.
- **Text Tools**: Count characters and words, reverse text, change case (uppercase/lowercase/title case), remove extra spaces and line breaks, and get text statistics.
- **Calculator**: A basic calculator for arithmetic operations.
- **Password Generator**: Create strong and secure passwords with customizable options (length, inclusion of uppercase, lowercase, numbers, and special characters).
- **Currency Converter**: Convert currencies using real-time exchange rates (requires internet connection).
- **Date & Time Tools**: Includes a timezone converter, date difference calculator, stopwatch, and timer.

## Project Structure

The project follows the standard Flutter application structure, with the addition of a `screens` directory within `lib` to organize the different functionalities of the application.

```
swiss_army_knife_app/
├── lib/
│   ├── main.dart
│   ├── swiss_army_knife_app.dart
│   └── screens/
│       ├── calculator_screen.dart
│       ├── currency_converter_screen.dart
│       ├── datetime_tools_screen.dart
│       ├── home_screen.dart
│       ├── measurement_converter_screen.dart
│       ├── password_generator_screen.dart
│       ├── text_tools_screen.dart
│       └── unit_converter_screen.dart
├── LICENCE
├── pubspec.yaml
├── README.md
├── ACTIVITY.md
└── ... (other Flutter generated files and directories)
```

## How to Run the Project

To run this project, you will need to have the Flutter SDK installed on your machine. Follow the steps below:

1.  **Clone the repository:**
    ```bash
    git clone <YOUR_REPOSITORY_URL>
    cd swiss_army_knife_app
    ```

2.  **Get dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the application:**
    ```bash
    flutter run
    ```

    You can specify the target device (e.g., `flutter run -d chrome` for web, `flutter run -d emulator-5554` for Android).

## Dependencies

The main dependencies used in this project are:

-   `http`: For making HTTP requests (used in the currency converter).
-   `intl`: For date and number formatting (used in date and time tools).

All dependencies can be found in the `pubspec.yaml` file.

## Contribution

Contributions are welcome! Feel free to open issues and pull requests for improvements, bug fixes, or new features.

## License

This project is licensed under the [MIT License](LICENSE).
