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
