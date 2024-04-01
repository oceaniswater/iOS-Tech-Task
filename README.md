
# Moneybox iOS Technical Challenge

## Overview

Hi! This is the 'light' version of Moneybox app targeting iOS 15. This app follows the MVVM-C (Model-View-ViewModel-Coordinator) architectural pattern, providing a maintainable, scalable, and testable codebase.
 
### Key Features:
- MVVM-C Architecture: Structured using the Model-View-ViewModel-Coordinator pattern for improved navigation, organization and separation of concerns.
- SOLID Principles: Adheres to SOLID principles, enabling clean, readable, and maintainable code. This ensures flexibility and ease of future development.
- Programmatic UI: All user interfaces are created programmatically, avoiding the use of Interface Builder and enabling more control over the layout. Constraints are managed using NSLayoutConstraints, minimizing dependencies on third-party libraries. I personaly like using SnapKit in my UIKit projects.
- Accessibility: Designed with accessibility in mind, the app includes additional accessibility labels and hints for a smooth experience with VoiceOver. Selected screens support the Dynamic Type accessibility feature, enhancing usability for users with special needs.
- Design Patterns: Incorporates common design patterns such as Singleton and Delegate to facilitate efficient communication between components and ensure a coherent codebase.
- Dark Mode Support: The app adjusts its appearance based on your iPhone's settings, ensuring a comfortable viewing experience in both light and dark modes.
- Custom Views: A custom alert view is implemented to display errors and important notifications to users, enhancing the app's user feedback mechanisms and improving overall usability. The app includes a custom text field that replicates the functionality of the text field in the original Moneybox app, providing a familiar and intuitive input experience for users.
- Unit Testing: Comprehensive unit test coverage ensures the stability and reliability of the app, providing confidence during development and maintenance.
- UI Testing: All UI elements are equipped with accessibility identifiers, facilitating UI testing and automation.

PS: I left refresh a button on the Account screen for your convinience. You would be able to check how the app works with expired/wrong token or logout and go to the Login screen.

![](https://github.com/oceaniswater/iOS-Tech-Task/blob/master/Media/1.png)
![](https://github.com/oceaniswater/iOS-Tech-Task/blob/master/Media/2.png)
![](https://github.com/oceaniswater/iOS-Tech-Task/blob/master/Media/3.png)

