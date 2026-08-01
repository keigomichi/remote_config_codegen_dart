import 'dart:io';

import 'package:remote_config_codegen/remote_config_codegen_dart.dart';
import 'package:test/test.dart';

void main() {
  group('GeneratedFileWriter', () {
    test('writeAll writes changed files and skips identical content', () async {
      final directory = await Directory.systemTemp.createTemp(
        'rcc-writer-test-',
      );
      addTearDown(() => directory.delete(recursive: true));
      final writer = GeneratedFileWriter();

      final first = await writer.writeAll(
        outputDirectory: directory,
        files: <String, String>{'generated.dart': 'first'},
      );
      final second = await writer.writeAll(
        outputDirectory: directory,
        files: <String, String>{'generated.dart': 'first'},
      );
      final third = await writer.writeAll(
        outputDirectory: directory,
        files: <String, String>{'generated.dart': 'second'},
      );

      expect(first, hasLength(1));
      expect(second, isEmpty);
      expect(third, hasLength(1));
      expect(
        await File('${directory.path}/generated.dart').readAsString(),
        'second',
      );
    });
  });
}
