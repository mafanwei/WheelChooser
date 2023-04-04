library wheel_chooser;

import 'package:flutter/widgets.dart';

class WheelChoice<T> {
  final T value;
  final String title;

  WheelChoice({required this.value, required this.title});
}

class WheelChooser<T> extends StatefulWidget {
  final TextStyle? selectTextStyle;
  final TextStyle? unSelectTextStyle;
  final Function(dynamic)? onValueChanged;
  final Function(dynamic)? onChoiceChanged;
  final List<dynamic>? datas;
  final List<WheelChoice>? choices;
  final int? startPosition;
  final double itemSize;
  final double squeeze;
  final double magnification;
  final double perspective;
  final double? listHeight;
  final double? listWidth;
  final List<Widget>? children;
  final bool horizontal;
  final bool isInfinite;
  final FixedExtentScrollController? controller;
  final ScrollPhysics? physics;
  static const double _defaultItemSize = 48.0;

  WheelChooser({
    required this.onValueChanged,
    required this.datas,
    this.selectTextStyle,
    this.unSelectTextStyle,
    this.startPosition = 0,
    this.squeeze = 1.0,
    this.itemSize = _defaultItemSize,
    this.magnification = 1,
    this.perspective = 0.01,
    this.listWidth,
    this.listHeight,
    this.controller,
    this.horizontal = false,
    this.isInfinite = false,
    this.physics,
  })  : assert(perspective <= 0.01),
        assert(controller == null || startPosition == null),
        children = null, choices = null, onChoiceChanged = null;

  WheelChooser.choices({
    required this.onChoiceChanged,
    required this.choices,
    this.selectTextStyle,
    this.unSelectTextStyle,
    this.startPosition = 0,
    this.squeeze = 1.0,
    this.itemSize = _defaultItemSize,
    this.magnification = 1,
    this.perspective = 0.01,
    this.listWidth,
    this.listHeight,
    this.controller,
    this.horizontal = false,
    this.isInfinite = false,
    this.physics,
  })  : assert(perspective <= 0.01),
        assert(controller == null || startPosition == null),
        children = null, datas = null, onValueChanged = null;


  WheelChooser.custom({
    required this.onValueChanged,
    required this.children,
    this.onChoiceChanged,
    this.datas,
    this.startPosition = 0,
    this.squeeze = 1.0,
    this.itemSize = _defaultItemSize,
    this.magnification = 1,
    this.perspective = 0.01,
    this.listWidth,
    this.listHeight,
    this.controller,
    this.horizontal = false,
    this.isInfinite = false,
    this.physics,
  })  : assert(perspective <= 0.01),
        assert(datas == null || datas.length == children!.length),
        assert(controller == null || startPosition == null),
        selectTextStyle = null,
        unSelectTextStyle = null, choices = null;

  WheelChooser.integer({
    required this.onValueChanged,
    required int maxValue,
    required int minValue,
    int? initValue,
    int step = 1,
    this.selectTextStyle,
    this.unSelectTextStyle,
    this.squeeze = 1.0,
    this.itemSize = _defaultItemSize,
    this.magnification = 1,
    this.perspective = 0.01,
    this.listWidth,
    this.listHeight,
    this.controller,
    this.horizontal = false,
    this.isInfinite = false,
    this.physics,
    bool reverse = false,
  })  : assert(perspective <= 0.01),
        assert(minValue < maxValue),
        assert(initValue == null || initValue >= minValue),
        assert(initValue == null || maxValue >= initValue),
        assert(step > 0),
        assert(controller == null || initValue == null),
        children = null,
        choices = null, onChoiceChanged = null,
        datas = _createIntegerList(minValue, maxValue, step, reverse),
        startPosition = initValue == null
            ? (controller == null ? 0 : null)
            : reverse
                ? (maxValue - initValue) ~/ step
                : (initValue - minValue) ~/ step;

  WheelChooser.number({
    required this.onValueChanged,
    required num maxValue,
    required num minValue,
    num? initValue,
    num step = 1,
    this.selectTextStyle,
    this.unSelectTextStyle,
    this.squeeze = 1.0,
    this.itemSize = _defaultItemSize,
    this.magnification = 1,
    this.perspective = 0.01,
    this.listWidth,
    this.listHeight,
    this.controller,
    this.horizontal = false,
    this.isInfinite = false,
    this.physics,
    bool reverse = false,
  })  : assert(perspective <= 0.01),
        assert(minValue < maxValue),
        assert(initValue == null || initValue >= minValue),
        assert(initValue == null || maxValue >= initValue),
        assert(step > 0),
        assert(controller == null || initValue == null),
        children = null, choices = null,
        datas = _createNumbersList(minValue, maxValue, step, reverse),
        startPosition = initValue == null
            ? (controller == null ? 0 : null)
            : reverse
                ? (maxValue - initValue) ~/ step
                : (initValue - minValue) ~/ step;

  WheelChooser.byController({
    required FixedExtentScrollController this.controller,
    required this.onValueChanged,
    required this.datas,
    this.selectTextStyle,
    this.unSelectTextStyle,
    this.squeeze = 1.0,
    this.itemSize = _defaultItemSize,
    this.magnification = 1,
    this.perspective = 0.01,
    this.listWidth,
    this.listHeight,
    this.horizontal = false,
    this.isInfinite = false,
    this.physics,
  })  : assert(perspective <= 0.01),
        children = null,
        choices = null,
        onChoiceChanged = null,
        startPosition = null;

  static List<int> _createIntegerList(
    int minValue,
    int maxValue,
    int step,
    bool reverse,
  ) {
    List<int> result = [];
    if (reverse) {
      for (int i = maxValue; i >= minValue; i -= step) {
        result.add(i);
      }
    } else {
      for (int i = minValue; i <= maxValue; i += step) {
        result.add(i);
      }
    }
    return result;
  }

  static List<num> _createNumbersList(
    num minValue,
    num maxValue,
    num step,
    bool reverse,
  ) {
    List<num> result = [];
    num value = minValue;

    while (value <= maxValue) {
      result.add(value);
      value += step;
    }

    return reverse ? result.reversed.toList() : result;
  }

  @override
  _WheelChooserState createState() {
    return _WheelChooserState<T>();
  }
}

class _WheelChooserState<T> extends State<WheelChooser> {
  FixedExtentScrollController? fixedExtentScrollController;
  int? currentPosition;

  bool _hasDatas() {
    return (widget.datas != null);
  }

  bool _hasChildren() {
    return (widget.children != null);
  }

  bool _hasChoices() {
    return (widget.choices != null);
  }

  dynamic _findDatasByIndex(int anIndex) {
    return widget.datas![anIndex];
  }

  bool _isValidChoicePosition(int anIndex) {
    return (anIndex >=0) && (anIndex < widget.choices!.length);
  }

  @override
  void initState() {
    super.initState();
    currentPosition = widget.controller?.initialItem ?? widget.startPosition;
    fixedExtentScrollController = widget.controller ?? FixedExtentScrollController(initialItem: currentPosition ?? 0);
  }

  void _listener(int position) {
    setState(() {
      currentPosition = position;
    });
    if (_hasChildren()) {
       widget.onValueChanged!(currentPosition);
    } else {
       if (_hasDatas()) {
         widget.onValueChanged!(_findDatasByIndex(currentPosition!));
       } else {
         if ((_hasChoices()) && (_isValidChoicePosition(currentPosition!))) {
           final aChoices = widget.choices!;
           widget.onChoiceChanged!(aChoices[currentPosition!].value);
         }
       }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
        quarterTurns: widget.horizontal ? 3 : 0,
        child: Container(
            height: widget.listHeight ?? double.infinity,
            width: widget.listWidth ?? double.infinity,
            child: _getListWheelScrollView()));
  }

  List<Widget> _buildItems() {
    if (_hasDatas()) {
      return _buildListItems();
    } else {
      if (widget.children != null) {
        return _convertListItems();
      } else {
        if (_hasChoices()) {
          return _buildChoiceItems();
        } else {
          return [];
        }
      }
    }
  }

  Widget _getListWheelScrollView() {
    if (widget.isInfinite) {
      return ListWheelScrollView.useDelegate(
          onSelectedItemChanged: _listener,
          perspective: widget.perspective,
          squeeze: widget.squeeze,
          controller: fixedExtentScrollController,
          physics: FixedExtentScrollPhysics(parent: widget.physics),
          childDelegate: ListWheelChildLoopingListDelegate(children: _buildItems()),
          useMagnifier: true,
          magnification: widget.magnification,
          itemExtent: widget.itemSize);
    } else {
      return ListWheelScrollView(
        onSelectedItemChanged: _listener,
        perspective: widget.perspective,
        squeeze: widget.squeeze,
        controller: fixedExtentScrollController,
        physics: FixedExtentScrollPhysics(parent: widget.physics),
        children: _buildItems(),
        useMagnifier: true,
        magnification: widget.magnification,
        itemExtent: widget.itemSize,
      );
    }
  }

  List<Widget> _buildListItems() {
    final datas = widget.datas!;
    List<Widget> result = [];
    for (int i = 0; i < datas.length; i++) {
      result.add(
        RotatedBox(
          quarterTurns: widget.horizontal ? 1 : 0,
          child: Center(
            child: Text(
              datas[i].toString(),
              textAlign: TextAlign.center,
              textScaleFactor: 1.5,
              style: i == currentPosition
                  ? widget.selectTextStyle ?? null
                  : widget.unSelectTextStyle ?? null,
            ),
          ),
        ),
      );
    }
    return result;
  }

  List<Widget> _buildChoiceItems() {
    final aChoices = widget.choices!;
    List<Widget> result = [];
    for (int i = 0; i < aChoices.length; i++) {
      result.add(
        RotatedBox(
          quarterTurns: widget.horizontal ? 1 : 0,
          child: Center(
            child: Text(
              aChoices[i].title,
              textAlign: TextAlign.center,
              textScaleFactor: 1.5,
              style: i == currentPosition
                  ? widget.selectTextStyle ?? null
                  : widget.unSelectTextStyle ?? null,
            ),
          ),
        ),
      );
    }
    return result;
  }


  List<Widget> _convertListItems() {
    final children = widget.children;
    if (children == null) {
      return [];
    }
    if (widget.horizontal) {
      List<Widget> result = [];
      for (int i = 0; i < children.length; i++) {
        result.add(RotatedBox(
          quarterTurns: 1,
          child: children[i],
        ));
      }
      return result;
    } else {
      return children;
    }
  }
}
