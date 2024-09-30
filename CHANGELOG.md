# Changelog

All notable changes to the LinePatternMatcher package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2024-09-30

### Added
- Introduced `LogicType` class with `and` and `or` constants for improved code readability and maintainability.

### Changed
- Updated `PatternConfig` to use `LogicType` constants instead of string literals for logic specification.
- Modified JSON serialization and deserialization to work with the new `LogicType` constants.
- Updated test cases to use the new `LogicType` constants.

## [1.0.0] - 2024-09-30

### Added
- Initial release of LinePatternMatcher.
- Implemented PatternConfig class for defining individual patterns.
- Created LinePatternMatcher class for matching patterns across multiple lines of text.
- Added support for different pattern types: firstLine, secondLine, lastLine, and sequential.
- Implemented AND/OR logic for keyword matching.
- Added JSON serialization and deserialization for patterns.
- Implemented printPatterns and getPatternsString methods for easy pattern visualization.
- Created comprehensive test suite covering various scenarios.

### Changed
- Refactored pattern matching logic to use PatternConfig objects instead of raw maps.

### Fixed
- Corrected issue with accessing PatternConfig properties in match method.

## [0.1.0] - 2024-09-29

### Added
- Initial development version.
- Basic structure for LinePatternMatcher.
