library js2dart.converter;

import "package:parsejs/parsejs.dart";
import "package:analyzer/analyzer.dart" as analyzer;
import "package:analyzer/src/services/formatter_impl.dart" as dartFormatter;

import "utils.dart";

part "src/visitor.dart";

String js2dart(String input, {bool format: true}) {
  var x = new ToDartVisitor();
  parsejs(input).visitBy(x);
  var out = x.buff.toString();
  out = "main() {${out}}";

  if (!format) {
    return out;
  }

  var cu = analyzer.parseCompilationUnit(out);
  var f = new dartFormatter.CodeFormatterImpl(new dartFormatter.FormatterOptions());
  return f.format(dartFormatter.CodeKind.COMPILATION_UNIT, cu.toSource()).source;
}
