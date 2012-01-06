## [0.3.0](https://github.com/attinteractive/yacht/compare/0.2.7...0.3.0)

### Less features
* Remove some unnecessary Rails support features ([#18](https://github.com/attinteractive/yacht/issues/18))

### Add Travis CI to github repo

## [0.2.7](https://github.com/attinteractive/yacht/compare/0.2.6...0.2.7)

### Bugfixes
* Compatibility with ruby 1.8.7 ([#16](https://github.com/attinteractive/yacht/issues/16) Mani Tadayon)

### New features
* Don't monkeypatch Hash, use a module instead ([#11](https://github.com/attinteractive/yacht/issues/11) Mani Tadayon)

## [0.2.6](https://github.com/attinteractive/yacht/compare/0.2.5...0.2.6)

### Bugfixes
* Making it possible to have any environment without having a configuration ([#13](https://github.com/attinteractive/yacht/pull/13) Alf Mikula)
* Correct docs
* Update cucumber version in development dependencies
* Clean up documentation
* Clean up cucumber features


## [0.2.5](https://github.com/attinteractive/yacht/compare/0.2.0...0.2.5)

### Bugfixes
* Fix bug with default value for Yacht::Loader.dir by forcing manual setting of dir outside of rails

### New Features
* Add feature that allows export to javascript ([#2](https://github.com/attinteractive/yacht/issues/2) Mani Tadayon)
* Add :rails_env key when Rails is defined


## [0.2.0](https://github.com/attinteractive/yacht/compare/0.1.2...0.2.0)

### New Features
* Use Yacht for name of class instead of YachtLoader
 ([#1](https://github.com/attinteractive/yacht/issues/1) Mani Tadayon)
* Add Cucumber features
* Simplify RSpec examples covered by new cucumber features