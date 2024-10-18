# Changelog

## [1.2.1](https://github.com/woodpecker-ci/plugin-kaniko/releases/tag/1.2.1) - 2024-10-18

### ❤️ Thanks to all contributors! ❤️

@6543

### 📦️ Dependency

- chore(deps): update woodpeckerci/plugin-docker-buildx docker tag to v5 [[#44](https://github.com/woodpecker-ci/plugin-kaniko/pull/44)]
- chore(deps): update woodpeckerci/plugin-ready-release-go docker tag to v2 [[#40](https://github.com/woodpecker-ci/plugin-kaniko/pull/40)]

### Misc

- Use current format of ENV in Dockerfile [[#39](https://github.com/woodpecker-ci/plugin-kaniko/pull/39)]
- [pre-commit.ci] pre-commit autoupdate [[#43](https://github.com/woodpecker-ci/plugin-kaniko/pull/43)]

## [1.2.0](https://github.com/woodpecker-ci/plugin-kaniko/releases/tag/1.2.0) - 2024-09-05

### ❤️ Thanks to all contributors! ❤️

@tkikuchi2000, @6543

### ✨ Features

- Add insecure options [[#36](https://github.com/woodpecker-ci/plugin-kaniko/pull/36)]

### Misc

- Update pipeline to use lates buildx plugin [[#37](https://github.com/woodpecker-ci/plugin-kaniko/pull/37)]

## [1.1.3](https://github.com/woodpecker-ci/plugin-kaniko/releases/tag/1.1.3) - 2024-07-23

### ❤️ Thanks to all contributors! ❤️

@ztelliot, @pre-commit-ci[bot]

### 🐛 Bug Fixes

- Fix build arg [[#35](https://github.com/woodpecker-ci/plugin-kaniko/pull/35)]

### Misc

- [pre-commit.ci] pre-commit autoupdate [[#33](https://github.com/woodpecker-ci/plugin-kaniko/pull/33)]

## [1.1.2](https://github.com/woodpecker-ci/plugin-kaniko/releases/tag/1.1.2) - 2024-05-13

### ❤️ Thanks to all contributors! ❤️

@6543, @qwerty287, @renovate[bot]

### 🐛 Bug Fixes

- Fix build arg quoting [[#31](https://github.com/woodpecker-ci/plugin-kaniko/pull/31)]

### Misc

- bump kaniko to v1.22.0 [[#32](https://github.com/woodpecker-ci/plugin-kaniko/pull/32)]
- Add CODEOWNERS [[#30](https://github.com/woodpecker-ci/plugin-kaniko/pull/30)]
- chore(deps): update woodpeckerci/plugin-docker-buildx docker tag to v4 [[#28](https://github.com/woodpecker-ci/plugin-kaniko/pull/28)]

## [1.1.1](https://github.com/woodpecker-ci/plugin-kaniko/releases/tag/1.1.1) - 2024-02-01

### ❤️ Thanks to all contributors! ❤️

@6543

### 🐛 Bug Fixes

- make plugin.sh executable again [[#23](https://github.com/woodpecker-ci/plugin-kaniko/pull/23)]

## [1.1.0](https://github.com/woodpecker-ci/plugin-kaniko/releases/tag/1.1.0) - 2024-01-31

### ❤️ Thanks to all contributors! ❤️

@nicolas-r, @renovate[bot], @qwerty287

### 📈 Enhancement

- Add two new options (--ignore-var-run and env_file), review the dry-run logic and try to fix some issues [[#20](https://github.com/woodpecker-ci/plugin-kaniko/pull/20)]

### 📚 Documentation

- Fix author key [[#14](https://github.com/woodpecker-ci/plugin-kaniko/pull/14)]

### Misc

- chore(deps): update woodpeckerci/plugin-docker-buildx docker tag to v3 [[#22](https://github.com/woodpecker-ci/plugin-kaniko/pull/22)]
- Use cleartext username [[#21](https://github.com/woodpecker-ci/plugin-kaniko/pull/21)]

## [1.0.0](https://github.com/woodpecker-ci/plugin-kaniko/releases/tag/1.0.0) - 2024-01-12

### ❤️ Thanks to all contributors! ❤️

@6543

### 💥 Breaking changes

- Add `dry-run` setting and docs.md [[#12](https://github.com/woodpecker-ci/plugin-kaniko/pull/12)]
- Switch to Woodpecker Environment Variables [[#9](https://github.com/woodpecker-ci/plugin-kaniko/pull/9)]

### Misc

- chore(deps): update alpine docker tag to v3.19 [[#11](https://github.com/woodpecker-ci/plugin-kaniko/pull/11)]

## [0.1.1](https://github.com/woodpecker-ci/plugin-kaniko/releases/tag/0.1.1) - 2024-01-12

### ❤️ Thanks to all contributors! ❤️

@6543

### 🐛 Bug Fixes

- Fix release pipeline [[#7](https://github.com/woodpecker-ci/plugin-kaniko/pull/7)]

## [0.1.0](https://github.com/woodpecker-ci/plugin-kaniko/releases/tag/0.1.0) - 2024-01-12

### ❤️ Thanks to all contributors! ❤️

@6543, @renovate[bot], @CrimsonFez, @foosinn, @bonifaido, @Mokto, @Jumba, @annProg, @kradalby, @cloudowski, @zicklag, @makarono, @anguslees, @myers

### ✨ Features

- Add support for docker hub mirrors and update image version [[#1](https://github.com/woodpecker-ci/plugin-kaniko/pull/1)]

### Misc

- Fix some more linting issues [[#5](https://github.com/woodpecker-ci/plugin-kaniko/pull/5)]
- Init pipeline [[#3](https://github.com/woodpecker-ci/plugin-kaniko/pull/3)]
- chore: Configure Renovate [[#2](https://github.com/woodpecker-ci/plugin-kaniko/pull/2)]
