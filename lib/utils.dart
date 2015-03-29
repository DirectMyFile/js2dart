library js2dart.utils;

class IndentedStringBuffer extends StringBuffer {
  final String indent;
  int level = 0;

  String get lastChar => toString()[length - 1];

  IndentedStringBuffer({this.indent: "  "});

  @override
  void writeln([Object obj = ""]) {
    super.writeln(obj);
    if (autoIndent) {
      writeIndent();
    }
  }

  void writeIndent() {
    write(indent * level);
  }

  void increment() {
    level++;
  }

  void decrement() {
    level--;
  }

  bool autoIndent = false;
}
