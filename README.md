🎯 FocusFlow — Master Your Momentum

**FocusFlow** is a premium, high-performance Task Management application developed as the **Week 3 Final Capstone Project** for the Flutter Development Internship. It represents a complete integration of modern UI/UX design, state management, and local data persistence.

---

✨ Elite Features

- **🚀 Cinematic Splash Screen**: A professional entry experience featuring a custom fade-in animation, branding, and smooth transitions.
- **💾 Local Data Persistence**: Built with `SharedPreferences`, ensuring all tasks are serialized to JSON and stored locally. Your productivity data remains safe even after app restarts.
- **📊 Real-time Progress Dashboard**: A dynamic summary card that calculates and displays your task completion percentage through an interactive progress bar.
- **🎨 Premium UI/UX (Material 3)**:
  - Modern Indigo & Slate color palette.
  - Custom Modal Bottom Sheets for task input.
  - Interactive haptic-style checkboxes.
  - Clean, minimalist list cards with date/time stamps.
- **🏗 Professional Architecture**: Built using a **Service-Oriented Architecture** (separating Data Models, Business Logic, and UI) for better scalability and code readability.

---

🛠 Tech Stack

- **Framework:** [Flutter](https://flutter.dev) (Material 3)
- **Language:** [Dart](https://dart.dev)
- **Persistence:** [SharedPreferences](https://pub.dev/packages/shared_preferences)
- **Utility:** [Intl](https://pub.dev/packages/intl) (Date/Time Formatting)
- **Design Pattern:** Model-View-Service (MVS)

---

🎥 Demo Video
Watch FocusFlow in action, showcasing the animated entry, task creation, and data persistence:
[![Watch the Demo] 
https://github.com/user-attachments/assets/3a9032fd-28d2-4278-af17-424eb4b1aac5

> **Note:** The video demonstrates the full flow: Splash Screen ➔ Dashboard ➔ Adding Tasks ➔ Data Persistence (App Restart).


📸 Screenshots

<p align="center">
<img width="1080" height="2436" alt="1000121768" src="https://github.com/user-attachments/assets/0acacc1a-ea49-41a9-a332-68e68b7a5670" />
<img width="1080" height="2436" alt="1000121769" src="https://github.com/user-attachments/assets/044824d2-e20f-43a7-a29c-ede4065e0c29" />
<img width="1080" height="2436" alt="1000121772" src="https://github.com/user-attachments/assets/f2a72ee9-0954-460b-874b-0d58f1519344" />
</p>

---
📂 Project Structure
Following industry standards, 
```text
lib/
├── models/
│   └── task.dart           # Data Class & JSON Serialization
├── screens/
│   ├── splash_screen.dart  # Animation & Entry Logic
│   └── home_screen.dart    # Dashboard & Task Management UI
├── services/
│   └── task_service.dart   # SharedPreferences & Storage Logic
└── main.dart               # App Configuration & Global Theme

🚀 Installation & Setup
Clone the repository:
git clone https://github.com/Mohsinraza676/Task_flow_app.git

Navigate to the project folder:
cd Task_flow_app

Install dependencies:
flutter pub get

Run the project:
flutter run

👨‍💻 Author
Syed Mohsin Raza
Flutter Development Intern
