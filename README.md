# wheel_chooser

WheelChooser is a widget allowing user to choose numbers/strings/widgets by scrolling spinners with wheel look.

## Getting Started
#### Install
```
dependencies:
  wheel_chooser: ^0.0.1
```
#### Creating WheelChooser Widget
use it to show Strings
```dart
WheelChooser(
    onValueChanged: (s) => print(s),
    datas: ["a", "b", "c"],
  );
```

use it to show Integers
```dart
WheelChooser.integer(
    onValueChanged: (i) => print(i),
    maxValue: 10,
    minValue: 1,
    step: 2,
  );
```

use it to show CustomWidgets

```dart
 WheelChooser.custom(
    onValueChanged: (a) => print(a),
    children: <Widget>[
      Text("data1"),
      Text("data2"),
      Text("data3"),
    ],
  );
```

### Usage examples

