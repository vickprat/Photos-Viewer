# Photos-Viewer
A photo viewer app that fetches photos from a 3rd party photo-sharing service Flickr and shows the results in a 3-column collection view.

Minimum Requirements
Xcode 12.1
No third party libraries are used. So it's very easy to build and run the project and also the build time is very less. Just clone the project, open the .xcodeproj file in Xcode and run it.

# Architecture
Used VIPER architecture to build this app. Lot of reasons to use VIPER architecture like it strictly follows SRP (Single Responsibility Principle) which increases testability, maintainability, scalability and reusability.
While using VIPER architecture, I only create the classes if there is really a need to create that class out of all the classes "View", "Interactor", "Presenter", "Entity", "Router".

# UI
No xibs or storyboards are used to create UI.

# Testing
Lots of tests have been added to increase the code coverage.
