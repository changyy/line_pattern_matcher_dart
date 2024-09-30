# LinePatternMatcher

[![pub package](https://img.shields.io/pub/v/line_pattern_matcher.svg)](https://pub.dev/packages/line_pattern_matcher)
[![Build Status](https://github.com/changyy/line_pattern_matcher_dart/workflows/Dart/badge.svg)](https://github.com/changyy/line_pattern_matcher/actions)

LinePatternMatcher is a flexible Dart package for matching complex patterns across multiple lines of text. It's particularly useful for log analysis, text processing, and pattern recognition tasks.

## Features

- Support for multiple pattern types: firstLine, secondLine, lastLine, and sequential
- AND/OR logic for keyword matching using predefined LogicType constants
- Custom pattern definitions using simple Map structures
- JSON serialization and deserialization support
- Pattern visualization functionality
- Efficient processing for large text datasets

## Installation

Add this line to your package's pubspec.yaml file:

```yaml
dependencies:
  line_pattern_matcher: ^1.0.1
```

Then run:

```
dart pub get
```

## Usage

### Basic Usage

```dart
import 'package:line_pattern_matcher/line_pattern_matcher.dart';

void main() {
  final matcher = LinePatternMatcher([
    PatternConfig(
      type: 'firstLine',
      keywords: [['Hello'], ['Hi']],
      logic: LogicType.or
    ),
    PatternConfig(
      type: 'lastLine',
      keywords: [['Goodbye']]
    )
  ]);

  final lines = [
    'Hello, World!',
    'This is a test.',
    'Goodbye!'
  ];

  if (matcher.match(lines)) {
    print('Pattern matched!');
  } else {
    print('Pattern not matched.');
  }
}
```

### Complex Pattern Example

```dart
final complexMatcher = LinePatternMatcher([
  PatternConfig(
    type: 'firstLine',
    keywords: [
      ['[User List]'],
      ['[Chat Room]']
    ],
    logic: LogicType.or
  ),
  PatternConfig(
    type: 'secondLine',
    keywords: [
      ['Total Users:', 'Online:']
    ]
  ),
  PatternConfig(
    type: 'sequential',
    keywords: [
      ['Name:', 'Status:'],
      ['Last Seen:']
    ]
  ),
  PatternConfig(
    type: 'lastLine',
    keywords: [
      ['End of List']
    ]
  )
]);

List<String> sampleText = [
  '[User List]',
  'Total Users: 1000, Online: 150',
  'Name: John Doe, Status: Active',
  'Last Seen: 5 minutes ago',
  'Name: Jane Smith, Status: Idle',
  'Last Seen: 1 hour ago',
  'End of List'
];

bool matched = complexMatcher.match(sampleText);
print(matched ? 'Complex pattern matched!' : 'Complex pattern not matched.');
```

### JSON Serialization and Deserialization

```dart
String jsonString = matcher.toJson();
LinePatternMatcher deserializedMatcher = LinePatternMatcher.fromJson(jsonString);
```

### Printing Patterns

```dart
matcher.printPatterns();
// or
String patternsString = matcher.getPatternsString();
print(patternsString);
```

## Advanced Usage

- Custom Pattern Types: Extend the `PatternConfig` class to create custom pattern types for specific use cases.
- Performance Optimization: For large text datasets, consider using stream processing or parallel processing to improve efficiency.
- Pattern Composition: Combine multiple `LinePatternMatcher` instances for more complex text analysis tasks.

## Contributing

Contributions are welcome! Please feel free to submit pull requests or create issues to improve this package.

### Development Setup

1. Clone the repository
2. Run `dart pub get` to install dependencies
3. Make your changes
4. Run tests with `dart test`
5. Submit a pull request with your changes

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

For a detailed changelog, please see the [CHANGELOG.md](CHANGELOG.md) file.

## Support

If you encounter any issues or have questions, please file an issue on the [GitHub issue tracker](https://github.com/yourusername/line_pattern_matcher/issues).
