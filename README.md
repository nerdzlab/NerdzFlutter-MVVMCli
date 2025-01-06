# MVVM CLI Tool

MVVM CLI Tool, a command-line utility designed to streamline the creation of MVVM (Model-View-ViewModel) projects. This tool automates the initial setup of your MVVM architecture, making it easier and faster to get started with your development process.

## Features & Usage

- **Create New Projects**: Generate a complete MVVM project.
- **Git Initial Commits(optional)**: Initial commits in created project.

Use `mvvm create`.

- **Analyze .arb files**: Analyze arb files for usage in dart code, and delete not necessary arb keys.

Use `mvvm analyze --arb`.

- **Generate Colors & TextStyles**: Generate colors from `.xml` files and TextStyles `from text_style_const.dart` file.

Use `mvvm generate` or specify the `--colors` or `--textStyle` to generate only one type: `mvvm generate --colors`.

## Installation

To install the MVVM CLI tool, run:

```bash
dart pub global activate mvvm_cli_nerdzlab
```

Once the tool is activated, you need to add the `.pub-cache/bin` directory to your system's PATH to ensure that you can run the `mvvm` commands from any location in your terminal. This can be done by adding the following line to your shell configuration file (e.g., .bashrc, .zshrc, or .bash_profile):

```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

## Verification

To verify that the installation was successful and the PATH is correctly set, run:

```bash
mvvm
```
