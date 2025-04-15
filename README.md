# 📒 Comood – Your Daily Mood Journal

**Comood** is a simple, beautiful, and personal iOS journaling app that helps users track their daily, weekly, and monthly moods. Whether you're feeling joyful, anxious, or anything in between, Comood gives you a space to reflect and grow.

---

## 👥 Team Members

This project was collaboratively developed by:
- Evelyn Wijaya  
- Shierly Anastasia Lie  
- Valentinus

---

## 🌈 Features

- 🎡 Select your daily mood using a custom carousel UI
- 🗨️ Answer daily reflective questions
- 📝 Add notes to your mood entries
- 📆 View mood history through a calendar view
- 📊 See weekly and monthly mood statistics
- 🔔 Get daily reminders via notifications

---

## 🚧 Problem & Solution

Many people struggle to consistently track their emotional well-being. Comood solves this by providing a friendly, interactive, and non-judgmental space to log and reflect on emotions—helping users recognize patterns over time and support their mental health journey.

---

## 🛠️ Tech Stack

| Tool / Framework      | Purpose                              |
|-----------------------|--------------------------------------|
| `SwiftUI`             | UI development (declarative UI)      |
| `SwiftData`           | Local data storage for mood entries  |
| `UserNotifications`   | Daily notification reminders         |

---

## 🧩 Architecture Overview

- Mood input is saved via `SwiftData`
- Daily mood reminders triggered using `UserNotifications`
- Data is visualized on Home and Statistic views

---

## 🖼️ Screenshots / Demo

| Input Mood | Statistics | Profile |
|------------|------------|---------|
| ![image](https://github.com/user-attachments/assets/8562cc81-adb7-4318-b747-6bd819eb14ea) | ![image](https://github.com/user-attachments/assets/403ba074-6f4b-45da-beeb-8b9f2dd39de8) | ![image](https://github.com/user-attachments/assets/8e507e2b-792a-437a-b032-db8f2730e731) |

---

## 📦 Getting Started

To run this app locally:

1. Clone the repository  
```bash
git clone https://github.com/evelynwijaya/comood.git
```
2. Open Comood.xcodeproj in Xcode 15 or later
3. Run on Simulator or Device
