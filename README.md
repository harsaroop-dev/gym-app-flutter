# Gym App

A Flutter-based mobile application to help you track your fitness journey, log your workouts, and visualize your progress with insightful charts.

## About The Project

This app is designed for fitness enthusiasts who want a simple, effective way to monitor their physical progress. Whether your goal is to lose weight, gain muscle, or maintain a healthy lifestyle, this app provides the tools to track key metrics like bodyweight, workout performance, sleep patterns, and daily steps. All data is visualized through graphs, making it easy to see your trends and stay motivated.

### Key Features

- **Bodyweight Tracking**: Log your weight regularly and view your progress on a time-series graph to see if you're on track with your weight loss or muscle gain goals.
- **Detailed Workout Logging**: Record your exercises, including sets, reps, and weight lifted for various muscle groups.
- **Vital Statistics Monitoring**: Keep track of other important health metrics, including daily sleep duration, steps taken, and calories consumed.
- **Visual Progress Charts**: Interactive charts provide a clear visual representation of your fitness trends over time.
- **Secure Authentication**: Leverages Firebase Authentication for secure user sign-up, login, and Google Sign-In capabilities.

### Tech Stack

- **Framework**: Flutter
- **Backend**: Firebase (Authentication, Firestore, Storage)
- **State Management**: Flutter Riverpod
- **Charts**: fl_chart
- **Platform**: Android & iOS

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

- Flutter SDK: [Installation Guide](https://flutter.dev/docs/get-started/install)
- Git: [Installation Guide](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

### Installation & Setup

1.  **Set up Firebase:**

    - Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project.
    - Add an Android app and an iOS app to your Firebase project. Follow the on-screen instructions.
    - Download the `google-services.json` file for Android and place it in the `android/app/` directory.
    - Download the `GoogleService-Info.plist` file for iOS and place it in the `ios/Runner/` directory.
    - In the Firebase Console, enable **Authentication** (Email/Password and Google providers) and **Firestore Database**.

2.  **Set up Environment Variables:**

    - Create a file named `.env` in the root of your project.
    - Add your Firebase project keys to this file. You can find these in your downloaded configuration files or in the Firebase project settings.
    - Use this template:
      ```env
      # .env.example
      ANDROID_API_KEY="your_android_api_key"
      ANDROID_APP_ID="your_android_app_id"
      IOS_API_KEY="your_ios_api_key"
      IOS_APP_ID="your_ios_app_id"
      MESSAGING_SENDER_ID="your_Messaginger_id"
      PROJECT_ID="your_project_id"
      STORAGE_BUCKET="your_storage_bucket"
      ANDROID_CLIENT_ID="your_android_client_id"
      IOS_CLIENT_ID="your_ios_client_id"
      IOS_BUNDLE_ID="your_ios_bundle_id"
      ```

3.  **Run the App:**
    ```sh
    flutter pub get
    flutter run
    ```

## Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.
