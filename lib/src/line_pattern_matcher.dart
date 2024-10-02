import 'dart:convert';

/// Represents the logic type for pattern matching.
class LogicType {
  /// Logical AND operation.
  static const String and = 'and';

  /// Logical OR operation.
  static const String or = 'or';
}

/// Configures a pattern for matching in LinePatternMatcher.
class PatternConfig {
  /// The type of pattern to match (e.g., 'firstLine', 'lastLine').
  final String type;

  /// List of keyword sets to match against.
  final List<List<String>> keywords;

  /// The logic to apply when matching keywords (AND or OR).
  final String logic;

  /// Creates a new [PatternConfig] instance.
  ///
  /// [type] specifies where to apply the pattern (e.g., 'firstLine').
  /// [keywords] is a list of keyword sets to match.
  /// [logic] determines how to combine keyword matches (default is AND).
  const PatternConfig({
    required this.type,
    required this.keywords,
    this.logic = LogicType.and,
  });

  /// Creates a [PatternConfig] from a JSON map.
  factory PatternConfig.fromJson(Map<String, dynamic> json) {
    return PatternConfig(
      type: json['type'],
      keywords: (json['keywords'] as List)
          .map((k) => (k as List).map((word) => word.toString()).toList())
          .toList(),
      logic: json['logic'] ?? LogicType.and,
    );
  }

  /// Converts this [PatternConfig] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'keywords': keywords,
      'logic': logic,
    };
  }

  @override
  String toString() {
    return 'PatternConfig{type: $type, keywords: $keywords, logic: $logic}';
  }
}

PatternConfig pattern({
  required String type,
  required List<List<String>> keywords,
  String logic = LogicType.and,
}) {
  return PatternConfig(type: type, keywords: keywords, logic: logic);
}

/// A utility for matching complex patterns across multiple lines of text.
class LinePatternMatcher {
  /// The list of pattern configurations to match against.
  final List<PatternConfig> patterns;

  /// Creates a new [LinePatternMatcher] with the given [patterns].
  const LinePatternMatcher(this.patterns);

  /// Creates a [LinePatternMatcher] from a JSON string.
  factory LinePatternMatcher.fromJson(String jsonString) {
    final List<dynamic> jsonList = json.decode(jsonString);
    final patterns =
        jsonList.map((item) => PatternConfig.fromJson(item)).toList();
    return LinePatternMatcher(patterns);
  }

  /// Converts this [LinePatternMatcher] to a JSON string.
  String toJson() {
    return json.encode(patterns.map((p) => p.toJson()).toList());
  }

  /// Attempts to match the [patterns] against the given [lines] of text.
  ///
  /// Returns true if all patterns match, false otherwise.
  bool match(List<String> lines) {
    if (lines.isEmpty) return false;

    int sequentialIndex = 0;
    for (var pattern in patterns) {
      String type = pattern.type;
      List<List<String>> keywords = pattern.keywords;
      String logic = pattern.logic;

      bool matched = false;
      switch (type) {
        case 'firstLine':
          matched = matchLine(lines.first, keywords, logic);
          break;
        case 'secondLine':
          matched =
              lines.length >= 2 ? matchLine(lines[1], keywords, logic) : false;
          break;
        case 'lastLine':
          matched = matchLine(lines.last, keywords, logic);
          break;
        case 'scattered':
          matched = matchScattered(lines, keywords, logic);
          break;
        case 'orderedScattered':
          matched = matchOrderedScattered(lines, keywords);
          break;
        case 'sequential':
          for (int i = sequentialIndex;
              i < lines.length - keywords.length + 1;
              i++) {
            if (matchSequential(
                lines.sublist(i, i + keywords.length), keywords)) {
              matched = true;
              sequentialIndex = i + keywords.length;
              break;
            }
          }
          break;
      }

      if (!matched) return false;
    }

    return true;
  }

  bool matchLine(String line, List<List<String>> keywords, String logic) {
    if (logic == LogicType.and) {
      return keywords.every((keywordSet) => matchKeywordSet(line, keywordSet));
    } else {
      return keywords.any((keywordSet) => matchKeywordSet(line, keywordSet));
    }
  }

  bool matchKeywordSet(String line, List<String> keywordSet) {
    return keywordSet.every((keyword) => line.contains(keyword));
  }

  bool matchScattered(
      List<String> lines, List<List<String>> keywords, String logic) {
    if (logic == LogicType.and) {
      return keywords.every((keywordSet) {
        return lines.any((line) => matchKeywordSet(line, keywordSet));
      });
    } else {
      return keywords.any((keywordSet) {
        return lines.any((line) => matchKeywordSet(line, keywordSet));
      });
    }
  }

  bool matchOrderedScattered(List<String> lines, List<List<String>> keywords) {
    int currentLineIndex = 0;
    for (var keywordSet in keywords) {
      bool foundMatch = false;
      for (int i = currentLineIndex; i < lines.length; i++) {
        if (matchKeywordSet(lines[i], keywordSet)) {
          foundMatch = true;
          currentLineIndex = i + 1;
          break;
        }
      }
      if (!foundMatch) {
        return false;
      }
    }
    return true;
  }

  bool matchSequential(List<String> lines, List<List<String>> keywords) {
    if (lines.length < keywords.length) return false;
    for (int i = 0; i < lines.length - keywords.length + 1; i++) {
      if (matchSequentialFrom(lines.sublist(i), keywords)) return true;
    }
    return false;
  }

  bool matchSequentialFrom(List<String> lines, List<List<String>> keywords) {
    for (int i = 0; i < keywords.length; i++) {
      if (!matchKeywordSet(lines[i], keywords[i])) return false;
    }
    return true;
  }

  void printPatterns() {
    print('LinePatternMatcher Patterns:');
    for (int i = 0; i < patterns.length; i++) {
      print('Pattern ${i + 1}:');
      print('  ${patterns[i]}');
    }
  }

  String getPatternsString() {
    StringBuffer buffer = StringBuffer('LinePatternMatcher Patterns:\n');
    for (int i = 0; i < patterns.length; i++) {
      buffer.writeln('Pattern ${i + 1}:');
      buffer.writeln('  ${patterns[i]}');
    }
    return buffer.toString();
  }
}
