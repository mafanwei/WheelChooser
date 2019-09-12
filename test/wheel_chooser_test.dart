import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wheel_chooser/wheel_chooser.dart';

Future<WheelChooser> _wheelChooserTester({WidgetTester tester}) async {
  WheelChooser chooser;
  chooser = WheelChooser(
    onValueChanged: (s) => print(s),
    datas: ["a", "b", "c"],
    startPosition: 2,
  );
  await tester.pumpWidget(StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return MaterialApp(
      home: Scaffold(
        body: chooser,
      ),
    );
  }));
  expect("c", equals(chooser.datas[2]));

  chooser = WheelChooser.integer(
    onValueChanged: (i) => print(i),
    maxValue: 10,
    minValue: 1,
    step: 2,
  );

  await tester.pumpWidget(StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return MaterialApp(
      home: Scaffold(
        body: chooser,
      ),
    );
  }));
  expect(9, equals(chooser.datas[chooser.datas.length - 1]));

  int index;
  chooser = WheelChooser.custom(
    onValueChanged: (a) => index = a,
    children: <Widget>[
      Text("data1"),
      Text("data2"),
      Text("data3"),
    ],
  );

  await tester.pumpWidget(StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return MaterialApp(
      home: Scaffold(
        body: chooser,
      ),
    );
  }));

  Offset pickerCenter = Offset(
    150,
    150,
  );

  await tester.pumpAndSettle();
  final TestGesture testGesture = await tester.startGesture(pickerCenter);
  await testGesture.moveBy(Offset(0, -2 * 48.0));
  expect(null, equals(index));
  await testGesture.moveBy(Offset(0, 48));
  expect(1, equals(index));

  return chooser;
}

void main() {
  testWidgets('Normal works', (WidgetTester tester) async {
    await _wheelChooserTester(
      tester: tester,
    );
  });
}
