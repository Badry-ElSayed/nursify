# 📱 Application Screens

1️⃣ Get Started Screen

- Clean onboarding interface
- Smooth navigation to authentication

2️⃣ Authentication System

🔐 Login Page

📝 Sign Up Page

Secure authentication

Logout functionality

3️⃣ Dashboard Screen

The heart of the application.

📊 Top Statistics Cards:

Available Rooms

Total Patients

Remaining Tasks

Emergency Cases

📋 Bottom Section:

Live patient condition display:

🟢 In Treatment

🔵 Recovered

🔴 Critical

Real-time dynamic updates.

4️⃣ Patient Management

Doctors can:

Add patient name

Assign room number

Set patient condition:

In Treatment

Recovered

Critical

Helps in tracking hospital flow efficiently.

5️⃣ Task Management System

Doctors can create tasks with:

Task Title

Patient Name

Room Number

Priority Level

Priority system helps identify urgent tasks quickly.

6️⃣ Doctor Profile Page

Displays:

Doctor Name

Total Tasks

Completed Tasks

Remaining Tasks

Completion Percentage

Visual progress tracking to measure productivity.

7️⃣ Settings Page

Includes:

Change Name

Change Password

Dark Mode Toggle 🌙

Smooth Theme Animation

Logout Button

Modern UI experience with animated transitions.

✨ Core Features

✅ Patient Condition Tracking

✅ Task Management with Priority

✅ Real-Time Dashboard Analytics

✅ Performance Monitoring

✅ Dark / Light Mode with Animation

✅ Secure Authentication

✅ Clean & Modern UI

✅ Firebase Integration

✅ Scalable Architecture

🛠 Tech Stack

Flutter

Dart

Firebase Authentication

Cloud Firestore

State Management (Cubit / Bloc)

Material Design

🏗 Architecture

The app follows a clean and organized structure:

UI Layer (Screens)

Business Logic (Cubit / State Management)

Firebase Service Layer

Models for structured data handling

This ensures maintainability and scalability.

🔐 Security

Authentication protected routes

Firebase secured backend

Sensitive files excluded from GitHub

Keystore and Google Services files secured locally

📂 Project Structure
lib/
 ├── Authentication/
 ├── Dashboard/
 ├── Patients/
 ├── Tasks/
 ├── Profile/
 ├── Settings/
 ├── Firebase/
 ├── Cubit/
 └── Models/
⚙️ Installation Guide
1️⃣ Clone the repository
git clone https://github.com/yourusername/nursify.git
2️⃣ Navigate into project
cd nursify
3️⃣ Install dependencies
flutter pub get
4️⃣ Add your Firebase configuration

Place your:

google-services.json (Android)

GoogleService-Info.plist (iOS)

5️⃣ Run the app
flutter run
📊 Use Case Scenario

A doctor starts the shift:

Opens dashboard

Sees available rooms

Checks emergency patients

Reviews remaining tasks

Adds new patient if admitted

Creates tasks with priority

Everything in one clean interface.

🔮 Future Improvements

Push Notifications

Admin Panel

Multi-Doctor System

Hospital Branch Management

Analytics Charts

PDF Medical Reports

Role-Based Access

🎯 Why Nursify?

Because hospital workflow should be:

Organized

Fast

Clear

Data-driven

Nursify simplifies doctor workflow with smart management tools.

👨‍💻 Developed By

Badry Sayed
Flutter Developer
Passionate about building scalable medical solutions.

⭐ If you like this project

Give it a ⭐ on GitHub
It motivates future improvements 🚀