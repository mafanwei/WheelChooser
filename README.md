# wheel_chooser

WheelChooser is a widget allowing user to choose numbers/strings/widgets by scrolling spinners with wheel look.

![vertical](https://raw.githubusercontent.com/mafanwei/WheelChooser/master/screenShot/demoInteger.gif)

## Getting Started
#### Install
```
dependencies:
  wheel_chooser: ^0.1.1
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
![vertical](https://raw.githubusercontent.com/mafanwei/WheelChooser/master/screenShot/demoInteger.gif)
```dart
WheelChooser.integer(
        onValueChanged: (s) => print(s.toString()),
        maxValue: 18,
        minValue: 1,
        initValue: 5,
        unSelectTextStyle: TextStyle(color: Colors.grey),
      )
```

![vertical](https://raw.githubusercontent.com/mafanwei/WheelChooser/master/screenShot/demoHorizon.jpg)
```dart
WheelChooser.integer(
        onValueChanged: (s) => print(s.toString()),
        maxValue: 20,
        minValue: 1,
        initValue: 9,
        horizontal: true,
        unSelectTextStyle: TextStyle(color: Colors.grey),
      )
```

From v0.1.1 support Infinite.
