# RacingUI

RacingUI is a SwiftUI-based project that focuses on building a responsive and scalable user interface for racing-related features. This documentation will guide you through the project structure, key components, and how to run the application.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

Before you begin, ensure you have the following installed:

- **iOS** 16.0+
- **Xcode** 15.0+
- **Swift** 5.5+
- **SwiftLint** (for linting the code)
- **Swift package Manager** 

### Installation

Follow these steps to set up the project on your machine:

1. **Clone the repository**:

   ```bash
   git clone https://github.com/devdallu/RacingUI.git
   
2. **Navigate to the project directory**:

   cd RacingUI/Next5Racing/
   
3.  **Open the project in Xcode**:

   open Next5Racing.xcodeproj
   Using Swift Package Manager, the dependencies should resolve automatically when you open the project in Xcode.

![Screenshot 2024-11-25 at 12 17 56 AM](https://github.com/user-attachments/assets/26c2eb66-1801-42fc-b516-ec6fcee079b6)

To resolve the error while installing your own Swift Package Manager package, follow these revised steps:

**Remove the "RacingUI" framework from the Target (General -> Frameworks).
![Screenshot 2024-11-25 at 12 18 27 AM](https://github.com/user-attachments/assets/4f5b186d-606f-4e7d-9ab2-1f1e58245f23)
Add the framework using its Git URL: https://github.com/devdallu/RacingUI.git.
![Screenshot 2024-11-25 at 12 20 10 AM](https://github.com/user-attachments/assets/1598c15e-58cc-401b-b231-28c5aebaaeac)
Select the appropriate target for the package.**
![Screenshot 2024-11-25 at 12 20 27 AM](https://github.com/user-attachments/assets/b89083d9-433d-4c8a-a00a-930d2e6b7372)


### Running the App
In Xcode, select the target device or simulator.
Press Cmd + R or click the Run button to build and run the application.

###Testing
Unit and integration tests can be found in the Next5RacingTests/ folder.
To execute the tests, press Cmd + U in Xcode or go to Product -> Test.

# Next5Racing App

A SwiftUI application that displays the next 5 upcoming races across different racing categories with real-time updates and filtering capabilities.

## Features

- Real-time display of next 5 upcoming races
- Category filtering (Horse racing, Harness racing, Greyhound racing)
- Auto-refresh functionality
- Pull-to-refresh support
- Countdown timer for each race
- Accessibility support
- Automatic removal of expired races
- Error handling

## Technical Architecture

### MVVM Architecture
1. **Views**
   - `RaceView`: Main view displaying the list of races and filter options
   - `RaceRowView`: Individual race item view
2. **ViewModels**
   - `RaceViewModel`: Manages race data, filtering, and business logic
   - `RaceRowViewModel`: Handles individual race item logic and countdown
3. **Services**
   - `RaceService`: Handles API communication
   - `NetworkManager`: Manages network connectivity status
  
```
RaceService → RaceViewModel → RaceView
                           ↓
                    RaceRowViewModel → RaceRowView
```

## Technical Implementation

### Race Updates
- Fetches races every 30 seconds automatically
- Removes races 60 seconds after their start time
- Updates countdown timer every second
- Handles network errors and displays appropriate messages

### State Management
The app uses an enum `RaceViewState` to manage different view states:
- Loading
- Loaded (with races)
- Empty
- Error

### Network Layer
- Uses async/await for network calls
- Implements error handling for various scenarios
- Checks network connectivity before making requests

## Error Handling

The app handles various error scenarios:
- Network connectivity issues
- API response errors
- Data parsing errors
- Empty states

## Testing

The app includes unit tests for:
- ViewModels
- Network layer
- Data parsing
- Timer functionality

Run tests using ⌘+U in Xcode.

## API Documentation

The app uses the Neds Racing API:
- Base URL: https://api.neds.com.au/rest/v1/racing/
- Endpoint: `?method=nextraces&count=10`

![Simulator Screenshot - iPhone 16 Plus - 2024-11-24 at 22 51 41](https://github.com/user-attachments/assets/dcb9d508-920a-4350-8031-cfa9fab3b6df)
