# Password Saver Flutter App

A simple, secure password manager built with Flutter.  
This app lets you save passwords with descriptions, encrypts them using a private key you provide, and decrypts them only when you enter the correct key.  
All encryption is handled locally on your device using AES encryption with a unique IV for each entry.

---

## ✨ Features

- **Add Passwords:** Save passwords with a custom description (e.g., "Gmail", "Bank", etc.)
- **Strong Encryption:** Passwords are encrypted using AES with your private key and a unique IV.
- **Secure Decryption:** Decrypt and view your password by entering the correct private key.
- **No Cloud Storage:** All data is stored in memory for demo purposes (no persistent storage).
- **Simple UI:** Clean, user-friendly interface.

---

## 🚀 Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) (3.x recommended)
- Dart SDK

### Installation

1. **Clone this repository:**
    ```
    git clone https://github.com/yourusername/password_saver_flutter.git
    cd password_saver_flutter
    ```
2. **Install dependencies:**
    ```
    flutter pub get
    ```
3. **Run the app:**
    ```
    flutter run
    ```

---

## 🛡️ Security Notes

- **Encryption:** Uses AES encryption from the [`encrypt`](https://pub.dev/packages/encrypt) package. Each password is encrypted with a unique IV and your private key.
- **Private Key:** Never hardcoded or stored; you must enter it to encrypt or decrypt.
- **IV Storage:** The IV is stored with each entry to ensure correct decryption.
- **No Persistent Storage:** This demo app stores data in memory only. For real-world use, implement secure persistent storage (e.g., [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)).

---

## 📱 Screenshots

| Main Screen | Decrypt Dialog | Decrypted Password |
| ----------- | -------------- | ----------------- |
| *Add your screenshots here* | *Add your screenshots here* | *Add your screenshots here* |

---

## 🧑‍💻 Usage

1. **Add a password:**
    - Enter a description and password.
    - Tap "Encrypt & Save".
    - Enter your private key in the dialog.
2. **View a password:**
    - Tap the unlock icon next to an entry.
    - Enter your private key.
    - The decrypted password will appear in a secure dialog.

---

## 📝 License

This project is licensed under the MIT License.  
See [LICENSE](LICENSE) for details.

---

## 🙏 Acknowledgements

- [encrypt](https://pub.dev/packages/encrypt) package for AES encryption
- Flutter & Dart teams

---

**Feel free to contribute or suggest improvements!**

---

> **Warning:**  
> This project is for educational/demo purposes only.  
> For production, always use secure persistent storage and follow best security practices.
