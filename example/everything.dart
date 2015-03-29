import "package:js2dart/converter.dart";

const String INPUT = """
function hello() {
  console.log("Hello World");
}

hello();

function bye() {
  return "Bye";
}

switch (5) {
  case 1:
    console.log("Hello");
    break;
  case 2:
    console.log("Bye");
    break;
}

try {
  console.log("Hello World");
} catch (e) {
  console.log("Goodbye World");
}

if (true) {
  console.log("TRUE");
}

if (true) {
  console.log("TRUE");
} else {
  console.log("NOT SANE");
}

if (true) {
  console.log("TRUE");
} else if (false) {
  console.log("Lol Wut");
} else {
  console.log("NOT SANE");
}

do {
  console.log("Hello World");
} while (true);

while (true) {
  console.log("Hello World");
}
""";

void main() {
  print(js2dart(INPUT));
}
