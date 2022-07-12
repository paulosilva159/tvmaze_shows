# TVMaze Shows

An application for listing TV shows

## Getting Started

As a normal Flutter project, first of all, run `flutter pub get`.

### Building the app

As it uses `build_runner` for some functionalities, do also run `flutter pub run build_runner build.

### Running the app

Finally, run `flutter run` on your favorite device to play with it.

## This project contemplates the following points:

* List all of the series contained in the API used by the paging scheme provided by the
API.
* Allow users to search series by name.
* The listing and search views must show at least the name and poster image of the
series.
* After clicking on a series, the application should show the details of the series, showing
the following information:
  * Name
  * Poster
  * Days and time during which the series airs
  * Genres
  * Summary
  * List of episodes separated by season
* After clicking on an episode, the application should show the episode’s information,
including:
  * Name
  * Number
  * Season
  * Summary
  * Image, if there is one
* Allow the user to save a series as a favorite.
* Allow the user to delete a series from the favorites list.
* Allow the user to browse their favorite series in alphabetical order, and click on one to
see its details.
* Create a people search by listing the name and image of the person.
* After clicking on a person, the application should show the details of that person, such
as:
  * Name
  * Image
  * Series they have participated in, with a link to the series details.
* Allow the user to set a PIN number to secure the application and prevent unauthorized
users

