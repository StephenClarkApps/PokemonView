## Pokémon View App
##### Stephen Clark -  29/04/2024

### Overview
This demo iOS application, built using Swift and SwiftUI, enables users to explore a searchable list of Pokémon and view detailed statistics and multimedia content for each Pokémon, leveraging the Pokémon API.

I though this was a cool little project as my Nephew loves Pokémon trading cards and so I though I would try and encorporate some of the elements of the cards into the detail view in the app. 

### Features
- **Searchable Pokémon List:** Dynamically search through Pokémon by name with results updating in real-time.
- **Pokémon Statistics:** View information on each Pokèmon including sprites and play their sounds on a dedicated Pokémon detail screen.
- **Accessibility Support:** Enhanced accessibility features such as VoiceOver, dynamic text resizing, and high-contrast UI. The app also supports Dark mode fully. 
- **Caching of Data:** This app will cache the list data, the individual Pokémon data, and the images and sounds, using Nuke and our custom audio logic. This means it's efficient (it won't re query or re-download data unless the user request it) and can support some offline functionality.

### Tech Stack
- **Languages/Frameworks:** Swift, SwiftUI, Combine, Realm, Swift Package Manager
- **Approach**: I took a broadly TDD approach (with a lot of adjustments)
- **API:** Pokémon API (https://pokeapi.co)
- **Database:** Realm for local data persistence
- **Audio Decoding:** OggDecoder for handling .ogg files (Pokémon sounds)
- **Images:** Nuke (for optimised image caching)
- **Tools:** Xcode, Git, Postman, Charles

### Development Approach and Best Practices
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

### Code Quality Elelemnts and SOLID Principles
- **Single Responsibility and Open/Closed:** Each class and function is designed to have a single responsibility and is open for extension but closed for modification.
- **Dependency Injection:** Used for managing dependencies in the network and data layers, facilitating easier unit testing and modularity.
- **Protocol-Oriented Programming:** Leveraged protocols to define blueprints for the network layer and caching mechanisms, enhancing the flexibility and testability of the code.

### Future Enhancements

- **Image Caching Configuration:** Customise the Nuke library settings to fine-tune image caching duration and performance to match our needs.

- **Error Handling UI:** Add UI elements alerting the user to any errors whether that be in Network handling, connectivity, or decoding.

- **Fetching the Species Data:** By fetching the Pokémon species data we could add the Pokémons "Flavor text" or the little quotation it says. 

- **More Data on the Details Screen:** Through the limitation of the project I'm actually only showing the "Basic" pokemon details, I'm not showing the progression or evolution of the Pokemon type, and I'm not showing much of the other info currently. For example the HP shown with be for the "Basic" verison of that particular Pokémon.

Ideally we would see more on the Species of Pokémon and on it's evolution. 


### Conclusion
This application not only showcases a robust use of modern Swift technologies and architectural best practices but also delivers a high-quality, accessible, and user-friendly experience for exploring Pokémon data.


### Licensing
- All Pokémon content is © Nintendo, Game Freak, and The Pokémon Company. This app is not a commerecial product it is only a code demo.
