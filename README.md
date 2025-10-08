# Crypto Portfolio Tracker

A Flutter application to track your cryptocurrency portfolio. Users can add coins, specify quantities, see real-time prices, and view the total portfolio value. Built using **GetX** for state management and clean architecture principles.

---

## Features

- Splash screen with animated app name and logo.
- Fetch and display a list of cryptocurrencies from CoinGecko API.
- Search and select coins to add to your portfolio.
- Input the quantity of each coin owned.
- Display current market price per coin.
- Calculate and show total value of each holding and overall portfolio.
- Persist portfolio data locally using a storage service.
- Pull-to-refresh to update prices.
- Swipe left to remove a coin from the portfolio.
- Toast notifications when prices are updated.
- Handles API rate limits with friendly error messages, but not displayed due to User Experience.

---

## Architecture

The project uses **Clean Architecture**:

- **Core**: Constants, utilities, API services, base use case class.
- **Data Layer**: Remote data sources, repositories, models.
- **Domain Layer**: Entities, repository interfaces, use cases.
- **Presentation Layer**: UI pages, GetX controllers for state management.

---

## Dependencies

The app uses these packages:

- `get_it` – Dependency Injection
- `get` – GetX for state management
- `http` – API calls
- `get_storage` – Local storage (via StorageService)

Install dependencies:

```bash
flutter pub get
```

---

## Setup & Run

1. Clone the repository:

```bash
git clone <repository_url>
cd <project_folder>
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

4. (Optional) Build APK:

```bash
flutter build apk --release --split-per-abi
```

---

## Dependency Injection

All dependencies (API services, controllers, repositories, storage) are registered in `di_setup.dart` using **GetIt**. Call `configureDependencies()` in `main()` before `runApp()`

---

## Key Screens

- **Splash Screen** – Animated app name/logo while fetching coin list.
- **Dashboard** – Shows total portfolio value and list of coins in portfolio.
- **Coins Search Page** – Search and select coins to add.
- **Coin Detail Bottom Sheet** – Shows current price, quantity input, and add button.

---

## Notes

- Free-tier CoinGecko API has rate limits; friendly messages appear if limits are exceeded.
- Portfolio data persists across app restarts.
- Prices refresh automatically every 5-10 seconds if portfolio has coins.

---

## Author
@mrDathia
with
Knovator Technologies Private Limited  
[hello@knovator.com](mailto:hello@knovator.com) | [https://knovator.com](https://knovator.com)