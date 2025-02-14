# MobileChallengeUala

https://github.com/user-attachments/assets/0f16f2a6-e83d-4b10-9cb3-2feb043dedf6

## Description
This is an iOS application developed in SwiftUI that allows users to explore a list of cities, search for specific cities, view their location on a map, and mark cities as favorites. The application consumes city data from a remote web service and uses UserDefaults to persist the user's favorite cities.

## Features
- **City Listing**: Displays a list of cities with details such as name, country, and coordinates.
- **City Search**: Real-time search functionality that allows users to filter cities by name.
- **Map Visualization**: Shows the location of each city on an interactive MapKit map.
- **Favorites Management**: Users can mark cities as favorites and access a filtered list of their preferred cities.
- **Favorites Persistence**: Favorite cities are saved locally using UserDefaults, so they persist between application sessions.
- **Orientation Adaptability**: The user interface adapts to both portrait and landscape device orientations, offering an optimal experience in both.
- **Unit Tests**: Includes unit tests to ensure the robustness and correct operation of CityViewModel and CityViewService.

## Technologies Used
- **Swift**: Main programming language.
- **SwiftUI**: Declarative user interface framework for building the application's UI.
- **Combine**: Framework for handling asynchronous events (although not explicitly seen in the provided code, it could be implicitly used in the @Published management within CityViewModel).
- **URLSession**: Used to perform HTTP requests and obtain city data from a web service.
- **JSONDecoder**: To decode JSON data received from the web service into CityModel objects.
- **UserDefaults**: For local persistence of favorite cities.
- **MapKit**: Apple framework for integrating maps into the application.
- **XCTest**: Apple's unit testing framework to ensure code quality.

## Requirements
- **iOS 15.0+**
- **Xcode 13.0+**

## Setup and Installation

1. **Clone the repository**:
    ```bash
    git clone git@github.com:EngineeringLatamAvenga/ignacio_mendez_ios_challenge.git
    cd MobileChallengeUala
    ```

2. **Open the project in Xcode**:
    Open the `MobileChallengeUala.xcodeproj` file with Xcode.

3. **Run the application**:
    Select a simulator or iOS device as the destination and run the project by pressing the "Play" (▶) button.

## Usage
- **Upon launching the application**, a list of cities will be loaded. If loading is in progress, a progress indicator will be displayed.
- **Explore cities**: Scroll through the list of cities in the main view.
- **Search for cities**: Use the search bar at the top to filter cities by name. The search is performed in real-time as you type.
- **View on map**: Tap a city in the list to view its location on a map in a detailed view.
- **Mark as favorite**: In each city row, there is a star button. Tap the star to mark or unmark a city as a favorite.
- **Filter by favorites**: Tap the heart button in the navigation bar to show or hide only the cities you have marked as favorites.
- **Landscape Orientation**: On devices in landscape orientation, the application displays the city list and the map simultaneously in a split-screen view, enhancing the user experience.

## Architecture
The application follows an **MVVM** (Model-View-ViewModel) architecture pattern:

- **Model**: `CityModel.swift` defines the data structure for cities and coordinates.
- **View**: The `.swift` files ending in `View.swift` (such as `CityListView.swift`, `CityRowView.swift`, `ContentView.swift`, `MapView.swift`) represent the user interface built with SwiftUI.
- **ViewModel**: `CityViewModel.swift` acts as an intermediary between the Model and the View. It manages business logic, data fetching from the service (`CityViewService.swift`), filtering, searching, and the UI state (loading, filtered cities, selected city, etc.).
- **Service**: `CityViewService.swift` is responsible for communication with the remote data source, abstracting network logic.
- **Manager**: `FavoritesManager.swift` manages the logic for favorite cities, using UserDefaults for persistence.

This design promotes maintainability, testability, and scalability of the application.

## Testing
The project includes unit tests for the `CityViewModel` and `CityViewService` in the `MobileChallengeUalaTests` and `MobileChallengeUalaTests` directories, respectively. These tests ensure the correct operation of the business logic and integration with the data service.

To run the tests, go to the Xcode menu **Product > Test** (or press **Cmd+U**).

## Author
**Nacho Mendez**
