# MVVM CLI Tool

MVVM CLI Tool, a command-line utility designed to streamline the creation of MVVM (Model-View-ViewModel) projects. This tool automates the initial setup of your MVVM architecture, making it easier and faster to get started with your development process.

## Features

- **Create New Projects**: Generate a complete MVVM project.
- **Git Initial Commits(optional)**: Initial commits in created project.
- **Analyze .arb files**: Analyze arb files for uses in dart code `mvvm analyze --arb`.

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

## Usage

To use the CLI tool, navigate to your desired directory and run:

```bash
mvvm create
```
