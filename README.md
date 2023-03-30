# wheel_chooser

[![pub package](https://img.shields.io/pub/v/wheel_chooser)](https://pub.dev/packages/wheel_chooser)

WheelChooser is a widget allowing user to choose numbers/strings/widgets by scrolling spinners with wheel look.

![vertical](https://raw.githubusercontent.com/mafanwei/WheelChooser/master/screenShot/demoInteger.gif)

## Getting Started
#### Install
```
dependencies:
  wheel_chooser: ^1.1.0
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

use it to show display titles and return a value associated with the selected value

```dart

List<WheelChoice> aChoices = [
  WheelChoice(value: DateTime(2000,1,1,9,0), title: '9AM'),
  WheelChoice(value: DateTime(2000,1,1,9,30), title: '9:30AM'),
  WheelChoice(value: DateTime(2000,1,1,10,0), title: '10AM'),
  WheelChoice(value: DateTime(2000,1,1,10,30), title: '10:30AM'),
];

WheelChooser.choices(
    choices = aChoices,
    onChoiceChanged: (value) {
      // returns DateTime of selected title
      print('selected time is ${value.hour} hours and ${value.minutes} minutes')
    }
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
From v1.0.0 support null safe.
