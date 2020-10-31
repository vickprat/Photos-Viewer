# Photos-Viewer
A photo viewer app that fetches photos from a 3rd party photo-sharing service Flickr and shows the results in a 3-column collection view.

# Screenshots
Photo Search Screen | Photo Details Screen
:-------------------------:|:-------------------------:
![image](https://github.com/vickprat/Photos-Viewer/blob/master/PhotosViewerApp/Screenshots/Screen%20Shot%202020-10-31%20at%2011.17.26.png) | ![image](https://github.com/vickprat/Photos-Viewer/blob/master/PhotosViewerApp/Screenshots/Screen%20Shot%202020-10-31%20at%2011.17.54.png)

# Minimum Requirements
Only Xcode 12.1 is required. No third party libraries are used. So it's very easy to build and run the project and also the build time is very less. Just clone the project, open the .xcodeproj file in Xcode and run it.

# Architecture
Used VIPER architecture to build this app. Lot of reasons to use VIPER architecture like it strictly follows SRP (Single Responsibility Principle) which increases testability, maintainability, scalability and reusability.
While using VIPER architecture, I only create the classes if there is really a need to create that class out of all the classes "View", "Interactor", "Presenter", "Entity", "Router".

# UI
No xibs or storyboards are used to create UI.

# Testing
Tests have been added to increase the code coverage and the current code coverage is 20%.

# What's next
1. Better UI by adding some cool animations.
2. More details can be shown on the photo details screen.
3. UI tests and other unit tests should be added to increase the test coverage.
