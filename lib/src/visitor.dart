part of js2dart.converter;

class ToDartVisitor extends Visitor {

  IndentedStringBuffer buff = new IndentedStringBuffer();

  @override
  visitArray(ArrayExpression node) {
    if (node.expressions.length > 2) {
      buff.writeln("[");
      buff.increment();
      node.expressions.forEach((x) {
        visit(x);
        if (x != node.expressions.last) {
          buff.write(",");
          buff.writeln();
          buff.writeIndent();
        }
      });
    }
  }

  @override
  visitAssignment(AssignmentExpression node) {
    buff.write("var ");
    visit(node.left);
    buff.write(" = ");
    visit(node.right);
  }

  @override
  visitBinary(BinaryExpression node) {
    visit(node.left);
    buff.write(" ");
    buff.write(node.operator == "instanceof" ? "is" : node.operator);
    visit(node.right);
  }

  @override
  visitBlock(BlockStatement node) {
    buff.write("{");

    for (var x in node.body) {
      visit(x);

      if (!(
        x is ForStatement ||
        x is ForInStatement ||
        x is IfStatement ||
        x is FunctionDeclaration ||
        x is WhileStatement ||
        x is DoWhileStatement ||
        x is SwitchStatement)) {
        buff.write(";");
      }
    }

    buff.write("}");
  }

  @override
  visitBreak(BreakStatement node) {
    buff.write("break");
  }

  @override
  visitCall(CallExpression node) {
    visit(node.callee);
    buff.write("(");
    for (var x in node.arguments) {
      visit(x);
      if (x != node.arguments.last) {
        buff.write(", ");
      }
    }
    buff.write(")");
  }

  @override
  visitCatchClause(CatchClause node) {
    buff.write("catch (");
    visit(node.param);
    buff.write(")");
    visit(node.body);
  }

  @override
  visitConditional(ConditionalExpression node) {
    visit(node.condition);
    buff.write("?");
    visit(node.then);
    buff.write(":");
    visit(node.otherwise);
  }

  @override
  visitContinue(ContinueStatement node) {
    buff.write("continue");
  }

  @override
  visitDebugger(DebuggerStatement node) {
    throw new Exception("Debugger Statements are not available in Dart");
  }

  @override
  visitDoWhile(DoWhileStatement node) {
    buff.write("do");
    visit(node.body);
    buff.write("while(");
    visit(node.condition);
    buff.write(")");
  }

  @override
  visitEmptyStatement(EmptyStatement node) {
  }

  @override
  visitExpressionStatement(ExpressionStatement node) {
    visit(node.expression);
  }

  @override
  visitFor(ForStatement node) {
    buff.write("for (");
    visit(node.init);
    buff.write(";");
    visit(node.condition);
    buff.write(";");
    visit(node.update);
    buff.write(")");
    visit(node.body);
  }

  @override
  visitForIn(ForInStatement node) {

  }

  @override
  visitFunctionDeclaration(FunctionDeclaration node) {
    visitFunctionNode(node.function);
  }

  @override
  visitFunctionExpression(FunctionExpression node) {
    visitFunctionNode(node.function);
  }

  @override
  visitFunctionNode(FunctionNode node) {
    if (node.name != null) {
      visitName(node.name);
    }
    buff.write("(");
    buff.write(node.params.map((it) => it.value).join(", "));
    buff.write(") ");
    visit(node.body);
  }

  @override
  visitIf(IfStatement node) {
    buff.write("if(");
    visit(node.condition);
    buff.write(")");
    visit(node.then);

    if (node.otherwise != null) {
      buff.write("else");
      if (node.otherwise is IfStatement) {
        buff.write(" ");
      }
      visit(node.otherwise);
    }
  }

  @override
  visitIndex(IndexExpression node) {
    visit(node.object);
    buff.write("[");
    visit(node.property);
    buff.write("]");
  }

  @override
  visitLabeledStatement(LabeledStatement node) {
    buff.write("${node.label.value}: ");
    visit(node.body);
  }

  @override
  visitLiteral(LiteralExpression node) {
    if (node.isString) {
      buff.write('"');
      buff.write(node.value);
      buff.write('"');
    } else if (node.isBool) {
      buff.write(node.boolValue.toString());
    } else if (node.isNull) {
      buff.write("null");
    } else if (node.isNumber) {
      buff.write(node.numberValue);
    } else {
      throw new Exception("Unknown Literal");
    }
  }

  @override
  visitMember(MemberExpression node) {
    if (node.object is NameExpression && (node.object as NameExpression).name.value == "console" && node.property.value == "log") {
      buff.write("print");
      return;
    }
    visit(node.object);
    buff.write(".");
    visitName(node.property);
  }

  @override
  visitName(Name node) {
    buff.write(node.value);
  }

  @override
  visitNameExpression(NameExpression node) {
    visitName(node.name);
  }

  @override
  visitObject(ObjectExpression node) {
    buff.write("{");
    var i = 0;
    for (var p in node.properties) {
      if (p.key is Name) {
        visit(new LiteralExpression('"${p.key.value}"'));
      } else {
        visit(p.key);
      }

      buff.write(":");
      visit(p.value);

      if (i != node.properties.length - 1) {
        buff.write(",");
      }
    }
  }

  @override
  visitProgram(Program node) {
    for (var x in node.body) {
      visit(x);
      if (!(
        x is ForStatement ||
        x is ForInStatement ||
        x is IfStatement ||
        x is FunctionDeclaration ||
        x is WhileStatement ||
        x is SwitchStatement ||
        x is TryStatement)) {
        buff.write(";");
      }
    }
  }

  @override
  visitPrograms(Programs node) {
    node.programs.forEach(visit);
  }

  @override
  visitProperty(Property node) {
    buff.write(node.nameString);
  }

  @override
  visitRegexp(RegexpExpression node) {
    buff.write('new RegExp(r"${node.regexp}"');
  }

  @override
  visitReturn(ReturnStatement node) {
    buff.write("return ");
    visit(node.argument);
  }

  @override
  visitSequence(SequenceExpression node) {
    var i = 0;
    for (var x in node.expressions) {
      visit(x);
      if (i != node.expressions.length - 1) {
        buff.write(",");
      }
      i++;
    }
  }

  @override
  visitSwitch(SwitchStatement node) {
    buff.write("switch (");
    visit(node.argument);
    buff.write("){");
    for (var c in node.cases) {
      visit(c);
    }
    buff.write("}");
  }

  @override
  visitSwitchCase(SwitchCase node) {
    buff.write("case ");
    visit(node.expression);
    buff.write(":");
    for (var x in node.body) {
      visit(x);
      buff.write(";");
    }
  }

  @override
  visitThis(ThisExpression node) {
    buff.write("this");
  }

  @override
  visitThrow(ThrowStatement node) {
    buff.write("throw ");
    visit(node.argument);
  }

  @override
  visitTry(TryStatement node) {
    buff.write("try");
    visit(node.block);
    visit(node.handler);
  }

  @override
  visitUnary(UnaryExpression node) {
    buff.write(node.operator);
    visit(node.argument);
  }

  @override
  visitUpdateExpression(UpdateExpression node) {
    if (node.isPrefix) {
      buff.write(node.operator);
      visit(node.argument);
    } else {
      visit(node.argument);
      buff.write(node.operator);
    }
  }

  @override
  visitVariableDeclaration(VariableDeclaration node) {
    var i = 0;
    for (var x in node.declarations) {
      visit(x);
      if (i != node.declarations.length - 1) {
        buff.write(";");
      }
      i++;
    }
  }

  @override
  visitVariableDeclarator(VariableDeclarator node) {
    buff.write("var ");
    visit(node.name);
    buff.write(" = ");
    visit(node.init);
  }

  @override
  visitWhile(WhileStatement node) {
    buff.write("while (");
    visit(node.condition);
    buff.write(")");
    visit(node.body);
  }

  @override
  visitWith(WithStatement node) {
    throw new Exception("With Statements are not able to be converted to Dart.");
  }
}
