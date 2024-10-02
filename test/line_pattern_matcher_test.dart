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

  test('Scattered pattern', () {
    final matcher = LinePatternMatcher([
      PatternConfig(
        type: 'scattered',
        keywords: [
          ['Hello'],
          ['World'],
          ['Goodbye']
        ],
      )
    ]);
    expect(matcher.match(['Hello there', 'Nice World', 'Goodbye everyone']),
        isTrue);
    expect(matcher.match(['Hello there', 'Nice planet', 'See you']), isFalse);
    expect(matcher.match(['World Hello', 'Goodbye', 'Hi there']), isTrue);
  });

  test('Scattered pattern with OR logic', () {
    final matcher = LinePatternMatcher([
      PatternConfig(
          type: 'scattered',
          keywords: [
            ['Hello'],
            ['World'],
            ['Goodbye']
          ],
          logic: LogicType.or)
    ]);
    expect(matcher.match(['Hello there', 'Beautiful Earth', 'Bye everyone']),
        isTrue);
    expect(matcher.match(['Hi', 'Nice planet', 'See you']), isFalse);
  });

  test('OrderedScattered pattern', () {
    final matcher = LinePatternMatcher([
      PatternConfig(
        type: 'orderedScattered',
        keywords: [
          ['First'],
          ['Second'],
          ['Third']
        ],
      )
    ]);
    expect(
        matcher.match(
            ['First line', 'Something else', 'Second here', 'Third line']),
        isTrue);
    expect(matcher.match(['Second line', 'First here', 'Third line']), isFalse);
    expect(matcher.match(['First line', 'Third here', 'Second line']), isFalse);
  });

  test('OrderedScattered pattern with multiple keywords per set', () {
    final matcher = LinePatternMatcher([
      PatternConfig(
        type: 'orderedScattered',
        keywords: [
          ['Hello', 'World'],
          ['How', 'are'],
          ['Goodbye', 'everyone']
        ],
      )
    ]);
    expect(
        matcher.match([
          'Hello beautiful World',
          'Some other line',
          'How nice are you',
          'Goodbye to everyone'
        ]),
        isTrue);
    expect(matcher.match(['Hello World', 'Goodbye everyone', 'How are you']),
        isFalse);
  });

  test('Complex pattern with multiple types', () {
    final matcher = LinePatternMatcher([
      PatternConfig(type: 'firstLine', keywords: [
        ['Start']
      ]),
      PatternConfig(
        type: 'orderedScattered',
        keywords: [
          ['Hello'],
          ['World']
        ],
      ),
      PatternConfig(type: 'lastLine', keywords: [
        ['End']
      ])
    ]);
    expect(
        matcher.match([
          'Start here',
          'Hello there',
          'Something else',
          'World is nice',
          'End now'
        ]),
        isTrue);
    expect(
        matcher
            .match(['Start here', 'World is nice', 'Hello there', 'End now']),
        isFalse);
    expect(
        matcher
            .match(['Begin here', 'Hello there', 'World is nice', 'End now']),
        isFalse);
  });
}
