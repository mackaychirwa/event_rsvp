# event_rsvp

## Table of Contents
- [event\_rsvp](#event_rsvp)
  - [Table of Contents](#table-of-contents)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Project Structure](#project-structure)
    - [Architecture](#architecture)
      - [Core](#core)
        - [Error](#error)
        - [Network](#network)
        - [Use Cases](#use-cases)
        - [Data Models](#data-models)
      - [Domain Layer](#domain-layer)
        - [Entities](#entities)
        - [Database/Repository](#databaserepository)
      - [Presentation Layer](#presentation-layer)
        - [Cubit/Bloc](#cubitbloc)
        - [Pages](#pages)
        - [Widgets](#widgets)

# Getting Started

## Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Visual Studio Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio) or [Xcode](https://developer.apple.com/xcode/)
- [Android Emulator](https://developer.android.com/studio/run/emulator) or [iOS Simulator](https://developer.apple.com/documentation/xcode/running_your_app_in_the_simulator_or_on_a_device)
- [Git](https://git-scm.com/downloads)

## Installation
1. Clone the repository
```
git clone
```
2. Install dependencies
```
flutter pub get
```
3. (only for iOS)
```
pod install
```
4. Run the application
```
flutter run
```

## Project Structure
The project is structured as follows:
```
lib
├───core
│   ├───error
│   ├───network
│   ├───usecases
│   ├───utils
├───screens
│   ├───dashboard
│       ├───database
│       ├───model
│       ├───bloc/cubit
│   ├───widgets
      ├───components
      ├───dialogs
```

### Architecture
The application uses the Clean Architecture pattern, with the following layers:

#### Core
This layer contains the most fundamental elements of the application. It includes common utilities, interfaces, and abstractions that are not specific to any particular feature.

##### Error
Handling and categorizing errors or exceptions.

##### Network
Defining networking-related abstractions.

##### Use Cases
Interfaces for use cases that the domain layer can implement.

##### Data Models
This layer contains the data models for a screen.

#### Domain Layer
This layer contains the core business logic and entities of the application.

##### Entities
Objects that represent business entities and hold essential data and behavior.

##### Database/Repository
Interfaces that define the contract for interacting with data sources in the data layer.

#### Presentation Layer
This is the user interface layer responsible for rendering the UI and handling user interactions.

##### Cubit/Bloc
The Cubit/Bloc layer is responsible for handling state management and business logic for a screen.

##### Pages
The Pages layer is responsible for rendering the UI for a screen.

##### Widgets
The Widgets layer is responsible for rendering the UI components for a screen.