### Criteria

For this task, you'll need to complete an iOS application using Swift and
SwiftUI, and the Pokemon API (https://pokeapi.co).

The app should include:
● A searchable list of Pokemon with their names and sprites.

● Detail screens for each Pokemon that list and visualise their statistics.


Notes:

● Feel free to use any additional third-party frameworks, such as
Alamofire.

○ (Although please don’t use a pre-built PokeAPI wrapper
framework)

● It’s totally up to you how the app looks, and the specifics of its
functionality.

The task will be assessed on the following aspects:
  ● Technical ability
  ○ High quality code.
  ○ Demonstrating good use of Swift technologies.
  ○ Strong understanding of SwiftUI best practices, state, data flow,
  and performance.
  ● Organisational skills
  ○ A tidy, clean, readable, and well-documented codebase.
  ○ Good use of git / version control.
  ● End product
  ○ How well the app works from a user’s point of view.

Something extra:
The following things are not required, but if you have the time and want any
extra opportunities to show off!
  ● Innovation: take advantage of new or recent Swift technologies.
  ● Accessibility: include support for VoiceOver, font scaling, and / or
  landscape.
  ● Multiplatform: support more than just iPhone, for example iOS and
  iPadOS.
  ● Visual pizzazz: great UI / UX.

### Process

To begin with a crated a simple iOS SwiftUI app with test bundles.

Secondly I created a logo by using various resources such as Adobe Stock and the publically avaliable svg files for the Pokemon logo.

I then began with a TDD aproach by creating a couple of simple tests covering the fetching of Pokémon names, and fetching Pokémon details, and filtering the Pokémon list or the Search functionality.

As time progressed it became obvious that no single enpoint in the API was going to give us everything we would wan to have for either the search view or the details view.

I reviewed the API documentation and used Postman to grab JSON responses fro the endpoint. I passed these into https://app.quicktype.io/ and edited the results adding compliance to the Codable and Hashable protocols allowing decoding with JSONDecoder etc.

I created a simple combine based networking layer to handle single endpoint queries.

My Nephew is a big fan of Pokémon trading cards so I had the idea to style the details view along the lines of one such card in terms of the positioning of the elements (roughly).

I found that one could get the sounds or cries of the Pokémon but that these were in oog format and hence I needed to do some extra work for converting the ogg files in order to play them.

Following on from that I continued with refactoring and tweaking the UI and adding tests as I progressed. 

TODO: - Fetch (Preload) images for each Pokémon on the fly as we scroll the list, these can then be cached, this means we don't have to grab too much data up front but enables us to meet the criteria of "A searchable list of Pokemon with their names and sprites" as the intial endpoint gives us their names only. 
