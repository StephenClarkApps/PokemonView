### Pokémon View App

#### Overview
This iOS application, built using Swift and SwiftUI, enables users to explore a searchable list of Pokémon and view detailed statistics and multimedia content for each Pokémon, leveraging the Pokémon API.

#### Features
- **Searchable Pokémon List:** Dynamically search through Pokémon by name with results updating in real-time.
- **Detailed Pokémon Statistics:** View detailed information including sprites and sounds on a dedicated Pokémon detail screen.
- **Accessibility Support:** Enhanced accessibility features such as VoiceOver, dynamic text resizing, and high-contrast UI.

#### Technical Stack
- **Languages/Frameworks:** Swift, SwiftUI
- **Approach**: Broadly TDD (with a lot of adjustments)
- **API:** Pokémon API (https://pokeapi.co)
- **Database:** Realm for local data persistence
- **Audio Decoding:** OggDecoder for handling .ogg files (Pokémon sounds)
- **Images:** Nuke (for optimised image caching)
- **Tools:** Xcode, Git, Postman

#### Development Approach and Best Practices
1. **Test-Driven Development (TDD):**
   - Started with defining unit tests for API data fetching and UI interactions. So initially that was just fetching the Pokemon list and Pokemon Details for a specific Pokemon.
   - Integrated UI tests to ensure the application behaves as expected on the front-end.

2. **Model-View-ViewModel (MVVM):**
   - Adopted MVVM architecture to separate business logic and UI, enhancing maintainability and testability.
   - Used ViewModels to handle presentation logic, making the UI code cleaner and focused on layout and user interactions.

3. **Efficient Data Handling:**
   - Utilised Realm for efficient local storage and retrieval of Pokémon data.
   - Optimized data fetching by deducing image URLs from Pokémon IDs, reducing the need for extensive network requests.

4. **Multimedia Management:**
   - Implemented functionality to decode and play Pokémon cries using OggDecoder, adding an immersive element to the detail views.

5. **Accessibility and Usability:**
   - Enhanced user interface accessibility with clear labels and dynamic text for visually impaired users.
   - Ensured that the application supports various screen sizes and orientations seamlessly.

#### Challenges and Solutions
- **Data Caching:**
  - Encountered issues with optimal data caching in Realm. Planned optimisations include adjusting data retrieval strategies and refining Realm configuration.
- **Media Handling:**
  - Addressed the challenge of playing .ogg audio formats not supported natively on iOS by integrating a third-party decoder.

#### Code Quality and SOLID Principles
- **Single Responsibility and Open/Closed:** Each class and function is designed to have a single responsibility and is open for extension but closed for modification.
- **Dependency Injection:** Used for managing dependencies in the network and data layers, facilitating easier unit testing and modularity.
- **Protocol-Oriented Programming:** Leveraged protocols to define blueprints for the network layer and caching mechanisms, enhancing the flexibility and testability of the code.

#### Future Enhancements
- **Realm Performance Tuning:** Further optimize the caching mechanism to enhance data retrieval performance. Fixes for any caching issues with the list data. 
- **Image Caching Configuration:** Customise the Nuke library settings to fine-tune image caching duration and performance to match our needs.

#### Conclusion
This application not only showcases a robust use of modern Swift technologies and architectural best practices but also delivers a high-quality, accessible, and user-friendly experience for exploring Pokémon data.

### Installation and Running the App
- **Installation:** Clone the repository, install necessary dependencies, and open the project in Xcode.
- **Running the App:** Select a target device or simulator in Xcode and run the application.


#### Licensing
- All Pokémon content is © Nintendo, Game Freak, and The Pokémon Company. This app is not a commerecial product it is only a code demo.
