
# Moneybox iOS Technical Challenge

## Overview

Hi! This is the 'light' version of Moneybox app targeting iOS 15. This app follows the MVVM-C (Model-View-ViewModel-Coordinator) architectural pattern, providing a maintainable, scalable, and testable codebase.
 
### Key Features:
- MVVM-C Architecture: Structured using the Model-View-ViewModel-Coordinator pattern for improved organization and separation of concerns.
- SOLID Principles: Adheres to SOLID principles, enabling clean, readable, and maintainable code. This ensures flexibility and ease of future development.
- Programmatic UI: All user interfaces are created programmatically, avoiding the use of Interface Builder and enabling more control over the layout. Constraints are managed using NSLayoutConstraints, minimizing dependencies on third-party libraries. I personaly like using SnapKit in my UIKit projects.
- Accessibility: Designed with accessibility in mind, the app includes additional accessibility labels and hints for a smooth experience with VoiceOver. Selected screens support the Dynamic Type accessibility feature, enhancing usability for users with special needs.
- Design Patterns: Incorporates common design patterns such as Singleton and Delegate to facilitate efficient communication between components and ensure a coherent codebase.
- Dark Mode Support: The app seamlessly transitions between light and dark modes, offering users a personalized and comfortable viewing experience, regardless of ambient lighting conditions.
- Custom Views: A custom alert view is implemented to display errors and important notifications to users, enhancing the app's user feedback mechanisms and improving overall usability. The app includes a custom text field that replicates the functionality of the text field in the original Moneybox app, providing a familiar and intuitive input experience for users.
- Unit Testing: Comprehensive unit test coverage ensures the stability and reliability of the app, providing confidence during development and maintenance.
- UI Testing: All UI elements are equipped with accessibility identifiers, facilitating UI testing and automation.

![](wireframe.png)

