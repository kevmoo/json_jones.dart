import 'dart:convert';
import 'dart:html';

import 'package:dart_style/dart_style.dart';

final _area = querySelector('#json_input') as TextAreaElement;
final _code = querySelector('#code') as DivElement;

final _formatter = new DartFormatter();

String _prettyJson(json) => const JsonEncoder.withIndent('  ').convert(json);

void main() {
  print("loaded!");

  _area.onPaste.listen(_update);

  _area.onChange.listen(_update);

  _area.value = _prettyJson(_sample);
  _update();
}

void _update([_]) {
  _area.style.borderColor = '';

  try {
    print(_area.value);
    var validContent = JSON.decode(_area.value) as Map;
    _writeClass(validContent);
  } catch (e) {
    print(e);
    _area.style.borderColor = 'red';
  }
}

const _className = 'TheClass';

void _writeClass(Map<String, dynamic> json) {
  var buffer = new StringBuffer();

  buffer.writeln('class $_className {');

  // fields
  buffer.writeAll(json.keys.map((k) => 'final $k;'), '\n');

  buffer.writeln();
  buffer.writeln();

  // normal constructor
  buffer.write('$_className(');
  buffer.writeAll(json.keys.map((k) => 'this.$k'), ',');
  buffer.write(');');

  buffer.writeln();
  buffer.writeln();

  // fromJson constructor
  buffer.writeln('factory $_className.fromJson(Map<String, dynamic> json) => ');
  buffer.writeln('new $_className(');
  buffer.writeAll(json.keys.map((k) => 'json["$k"]'), ',');
  buffer.writeln(');');

  buffer.writeln();
  buffer.writeln();

  // toJson helper
  buffer.writeln('Map<String, dynamic> toJson() => ');
  buffer.writeln('{');
  buffer.writeAll(json.keys.map((k) => '"$k": this.$k'), ',');
  buffer.writeln('};');


  buffer.writeln('}');

  String formatted;
  try {
    formatted = _formatter.format(buffer.toString());
  } catch (e) {
    print('Trying this...');
    print(buffer.toString());
    rethrow;
  }

  _code.children.clear();
  _code.appendText(formatted);
}

const _sample = const {
  "id": 1930712,
  "slug": "dart-lang/coverage",
  "description": "Dart coverage data manipulation and formatting",
  "last_build_id": 66076182,
  "last_build_number": "178",
  "last_build_state": "passed",
  "last_build_duration": 89,
  "last_build_language": null,
  "last_build_started_at": "2015-06-09T16:26:26Z",
  "last_build_finished_at": "2015-06-09T16:29:41Z",
  "active": true,
  "github_language": "Dart"
};
