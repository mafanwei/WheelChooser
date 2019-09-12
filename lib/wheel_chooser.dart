library wheel_chooser;

import 'package:flutter/widgets.dart';

class WheelChooser extends StatefulWidget {
  final TextStyle selectTextStyle;
  final TextStyle unSelectTextStyle;
  final Function(dynamic) onValueChanged;
  final List<dynamic> datas;
  final int startPosition;
  final double itemSize;
  final double squeeze;
  final double magnification;
  final double perspective;
  final double listHeight;
  final double listWidth;
  final List<Widget> children;
  static const double _defaultitemSize = 48.0;

  WheelChooser({
    @required this.onValueChanged,
    @required this.datas,
    this.selectTextStyle,
    this.unSelectTextStyle,
    this.startPosition = 0,
    this.squeeze = 1.0,
    this.itemSize = _defaultitemSize,
    this.magnification = 1,
    this.perspective = 0.01,
    this.listWidth,
    this.listHeight,
  })  : assert(perspective <= 0.01),
        children = null;

  WheelChooser.custom({
    @required this.onValueChanged,
    @required this.children,
    this.datas,
    this.startPosition = 0,
    this.squeeze = 1.0,
    this.itemSize = _defaultitemSize,
    this.magnification = 1,
    this.perspective = 0.01,
    this.listWidth,
    this.listHeight,
  })  : assert(perspective <= 0.01),
        assert(datas == null || datas.length == children.length),
        selectTextStyle = null,
        unSelectTextStyle = null;

  WheelChooser.integer({
    @required this.onValueChanged,
    @required int maxValue,
    @required int minValue,
    int initValue,
    int step = 1,
    this.selectTextStyle,
    this.unSelectTextStyle,
    this.squeeze = 1.0,
    this.itemSize = _defaultitemSize,
    this.magnification = 1,
    this.perspective = 0.01,
    this.listWidth,
    this.listHeight,
  })  : assert(perspective <= 0.01),
        assert(minValue < maxValue),
        assert(initValue == null || initValue >= minValue),
        assert(initValue == null || maxValue >= initValue),
        children = null,
        datas = _createIntegerList(minValue, maxValue, step),
        startPosition = initValue == null ? 0 : initValue - minValue;

  static List<int> _createIntegerList(int minValue, int maxValue, int step) {
    List<int> result = [];
    for (int i = minValue; i <= maxValue; i += step) {
      result.add(i);
    }
    return result;
  }

  @override
  _WheelChooserState createState() {
    return _WheelChooserState();
  }
}

class _WheelChooserState extends State<WheelChooser> {
  FixedExtentScrollController fixedExtentScrollController;
  int currentPosition;
  @override
  void initState() {
    super.initState();
    currentPosition = widget.startPosition;
    fixedExtentScrollController = FixedExtentScrollController(initialItem: currentPosition);
  }

  void _listener(int position) {
    setState(() {
      currentPosition = position;
    });
    if (widget.datas == null) {
      widget.onValueChanged(currentPosition);
    } else {
      widget.onValueChanged(widget.datas[currentPosition]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.listHeight ?? double.infinity,
        width: widget.listWidth ?? double.infinity,
        child: ListWheelScrollView(
          onSelectedItemChanged: _listener,
          perspective: widget.perspective,
          squeeze: widget.squeeze,
          controller: fixedExtentScrollController,
          physics: FixedExtentScrollPhysics(),
          children: widget.children ?? _buildListItems(),
          useMagnifier: true,
          magnification: widget.magnification,
          itemExtent: widget.itemSize,
        ));
  }

  List<Widget> _buildListItems() {
    List<Widget> result = [];
    for (int i = 0; i < widget.datas.length; i++) {
      result.add(
        Text(
          widget.datas[i].toString(),
          style: i == currentPosition ? widget.selectTextStyle ?? null : widget.unSelectTextStyle ?? null,
        ),
      );
    }
    return result;
  }
}
