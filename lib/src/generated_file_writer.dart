import 'dart:io';

/// Persists generated source files without rewriting unchanged content.
///
/// Each changed file is first written to a sibling temporary file and renamed
/// into place. This avoids exposing a partially written generated file to IDEs
/// and makes repeated generation leave unchanged files untouched.
class GeneratedFileWriter {
  /// Writes [files] under [outputDirectory] and returns only changed files.
  ///
  /// Parent directories are created as needed. Returned files are intended for
  /// subsequent formatting, so callers do not need to format unchanged files.
  Future<List<File>> writeAll({
    required Directory outputDirectory,
    required Map<String, String> files,
  }) async {
    await outputDirectory.create(recursive: true);
    final written = <File>[];
    for (final entry in files.entries) {
      final output = File(
        '${outputDirectory.path}${Platform.pathSeparator}${entry.key}',
      );
      if (await output.exists() && await output.readAsString() == entry.value) {
        continue;
      }
      final temporary = File('${output.path}.tmp');
      await temporary.writeAsString(entry.value);
      await temporary.rename(output.path);
      written.add(output);
    }
    return written;
  }
}
