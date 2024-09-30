import 'package:test/test.dart';
import 'package:line_pattern_matcher/line_pattern_matcher.dart';

void main() {
  group('LinePatternMatcher Tests', () {
    test('Simple firstLine pattern', () {
      final matcher = LinePatternMatcher([
        PatternConfig(type: 'firstLine', keywords: [
          ['Hello']
        ])
      ]);
      expect(matcher.match(['Hello, World!']), isTrue);
      expect(matcher.match(['Hi, World!']), isFalse);
    });

    test('Multiple patterns', () {
      final matcher = LinePatternMatcher([
        PatternConfig(type: 'firstLine', keywords: [
          ['Hello']
        ]),
        PatternConfig(type: 'lastLine', keywords: [
          ['Goodbye']
        ])
      ]);
      expect(
          matcher.match(['Hello, World!', 'How are you?', 'Goodbye!']), isTrue);
      expect(matcher.match(['Hello, World!', 'How are you?', 'See you!']),
          isFalse);
    });

    test('OR logic', () {
      final matcher = LinePatternMatcher([
        PatternConfig(
            type: 'firstLine',
            keywords: [
              ['Hello'],
              ['Hi']
            ],
            logic: LogicType.or)
      ]);
      expect(matcher.match(['Hello, World!']), isTrue);
      expect(matcher.match(['Hi, World!']), isTrue);
      expect(matcher.match(['Hey, World!']), isFalse);
    });

    test('Sequential pattern', () {
      final matcher = LinePatternMatcher([
        PatternConfig(type: 'sequential', keywords: [
          ['First'],
          ['Second']
        ])
      ]);
      expect(
          matcher.match(['First line', 'Second line', 'Third line']), isTrue);
      expect(
          matcher.match(['First line', 'Third line', 'Second line']), isFalse);
    });

    test('Empty input', () {
      final matcher = LinePatternMatcher([
        PatternConfig(type: 'firstLine', keywords: [
          ['Hello']
        ])
      ]);
      expect(matcher.match([]), isFalse);
    });

    test('JSON serialization and deserialization', () {
      final originalMatcher = LinePatternMatcher([
        PatternConfig(type: 'firstLine', keywords: [
          ['Hello']
        ]),
        PatternConfig(type: 'lastLine', keywords: [
          ['Goodbye']
        ])
      ]);

      final json = originalMatcher.toJson();
      final deserializedMatcher = LinePatternMatcher.fromJson(json);

      expect(deserializedMatcher.match(['Hello, World!', 'Goodbye!']), isTrue);
      expect(deserializedMatcher.match(['Hi, World!', 'See you!']), isFalse);
    });
  });

  test('Print patterns', () {
    final matcher = LinePatternMatcher([
      PatternConfig(
          type: 'firstLine',
          keywords: [
            ['Hello']
          ],
          logic: 'and'),
      PatternConfig(
          type: 'lastLine',
          keywords: [
            ['Goodbye']
          ],
          logic: 'and')
    ]);

    expect(
        matcher.getPatternsString(),
        contains(
            'PatternConfig{type: firstLine, keywords: [[Hello]], logic: and}'));
    expect(
        matcher.getPatternsString(),
        contains(
            'PatternConfig{type: lastLine, keywords: [[Goodbye]], logic: and}'));
  });
}
