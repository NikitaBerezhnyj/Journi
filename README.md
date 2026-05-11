# Journi

<p align="center">
  <img src="./assets/icon.png" alt="App logo" width="200"/>
</p>

Journi is a simple app for blood donors that allows you to:

- Record donations of blood, plasma, and platelets.
- Track a timer until the next donation.
- View statistics of previous donations.

The app is currently small, but it may grow and gain new features in the future.

## Technologies

- [Flutter](https://flutter.dev/) — for cross-platform mobile development.
- [Dart](https://dart.dev/) — programming language.
- [Node.js](https://nodejs.org/) and [Husky](https://typicode.github.io/husky/) + [Commitlint](https://commitlint.js.org/) — for commit message validation.

## Running the App

1. Install Flutter and Dart on your system:  
   [Flutter installation guide](https://docs.flutter.dev/get-started/install)

2. Clone the repository:

```bash
git clone https://github.com/NikitaBerezhnyj/Journi.git
cd Journi
```

3. Install dependencies:

```bash
flutter pub get
npm install
```

4. Run on an emulator or physical device:

```bash
flutter run
```

## Commit Messages

The project uses [Husky](https://typicode.github.io/husky/) and [Commitlint](https://commitlint.js.org/) to validate commit messages.
All commits should follow the **Conventional Commits** style, for example:

```
feat: add new donation screen
fix: correct timer calculation
chore: setup commitlint
```

## License & Community Guidelines

- [GNU GPL v3 License](LICENSE) — project license.
- [Code of Conduct](CODE_OF_CONDUCT.md) — expected behavior for contributors.
- [Contributing Guide](CONTRIBUTING.md) — how to help the project.
- [Security Policy](SECURITY.md) — reporting security issues.
