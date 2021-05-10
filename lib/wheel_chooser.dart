library wheel_chooser;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WheelChooser extends StatefulWidget {
  final TextStyle? selectTextStyle;
  final TextStyle? unSelectTextStyle;
  final Function(dynamic) onValueChanged;
  final List<dynamic>? datas;
  final int startPosition;
  final double itemSize;
  final double squeeze;
  final double magnification;
  final double perspective;
  final double? listHeight;
  final double? listWidth;
  final List<Widget>? children;
  final bool horizontal;
  final bool isInfinite;
  final double? indent;
  final Color dividerColor;
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
    this.perspective = 0.0000001,
    this.listWidth,
    this.listHeight,
    this.dividerColor = Colors.transparent,
    this.indent = 16.0,
    this.horizontal = false,
    this.isInfinite = false,
  })  : assert(perspective <= 0.01),
        assert(isInfinite != null),
        children = null;

  WheelChooser.custom({
    required this.onValueChanged,
    required this.children,
    this.datas,
    this.startPosition = 0,
    this.squeeze = 1.0,
    this.itemSize = _defaultItemSize,
    this.magnification = 1,
    this.perspective = 0.01,
    this.listWidth,
    this.listHeight,
    this.dividerColor = Colors.transparent,
    this.indent = 16.0,
    this.horizontal = false,
    this.isInfinite = false,
  })  : assert(perspective <= 0.01),
        assert(datas == null || datas.length == children!.length),
        assert(isInfinite != null),
        selectTextStyle = null,
        unSelectTextStyle = null;

  WheelChooser.integer({
    required this.onValueChanged,
    required int maxValue,
    required int minValue,
    int? initValue,
    int step = 1,
    this.selectTextStyle,
    this.unSelectTextStyle,
    this.squeeze = 1.0,
    this.dividerColor = Colors.transparent,
    this.indent = 16.0,
    this.itemSize = _defaultItemSize,
    this.magnification = 1,
    this.perspective = 0.01,
    this.listWidth,
    this.listHeight,
    this.horizontal = false,
    this.isInfinite = false,
    bool reverse = false,
  })  : assert(perspective <= 0.01),
        assert(minValue < maxValue),
        assert(initValue == null || initValue >= minValue),
        assert(initValue == null || maxValue >= initValue),
        assert(step > 0),
        assert(isInfinite != null),
        children = null,
        datas = _createIntegerList(minValue, maxValue, step, reverse),
        startPosition = initValue == null
            ? 0
            : reverse
                ? (maxValue - initValue) ~/ step
                : (initValue - minValue) ~/ step;

  static List<int> _createIntegerList(
      int minValue, int maxValue, int step, bool reverse) {
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

  @override
  _WheelChooserState createState() {
    return _WheelChooserState();
  }
}

class _WheelChooserState extends State<WheelChooser> {
  FixedExtentScrollController? fixedExtentScrollController;
  int? currentPosition;

  @override
  void initState() {
    super.initState();
    currentPosition = widget.startPosition;
    fixedExtentScrollController =
        FixedExtentScrollController(initialItem: currentPosition!);
  }

  void _listener(int position) {
    setState(() {
      currentPosition = position;
    });
    if (widget.datas == null) {
      widget.onValueChanged(currentPosition);
    } else {
      widget.onValueChanged(widget.datas![currentPosition!]);
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

  Widget _getListWheelScrollView() {
    if (widget.isInfinite) {
      return ListWheelScrollView.useDelegate(
          onSelectedItemChanged: _listener,
          perspective: widget.perspective,
          squeeze: widget.squeeze,
          controller: fixedExtentScrollController,
          physics: FixedExtentScrollPhysics(),
          childDelegate: ListWheelChildLoopingListDelegate(
              children: _convertListItems() ?? _buildListItems()),
          useMagnifier: true,
          magnification: widget.magnification,
          itemExtent: widget.itemSize);
    } else {
      return ListWheelScrollView(
          onSelectedItemChanged: _listener,
          perspective: widget.perspective,
          squeeze: widget.squeeze,
          controller: fixedExtentScrollController,
          physics: FixedExtentScrollPhysics(),
          children: _convertListItems() ?? _buildListItems(),
          useMagnifier: true,
          magnification: widget.magnification,
          itemExtent: 72 //widget.itemSize,
          );
    }
  }

  List<Widget> _buildListItems() {
    List<Widget> result = [];
    for (int i = 0; i < widget.datas!.length; i++) {
      result.add(
        RotatedBox(
          quarterTurns: widget.horizontal ? 1 : 0,
          child: i == currentPosition
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Divider(
                        indent: widget.indent,
                        endIndent: widget.indent,
                        color: widget.dividerColor,
                        thickness: 1.0,
                        height: 0,
                      ),
                      SizedBox(height: widget.indent),
                      Text(
                        widget.datas![i].toString(),
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.5,
                        style: i == currentPosition
                            ? widget.selectTextStyle ?? null
                            : widget.unSelectTextStyle ?? null,
                      ),
                      SizedBox(height: widget.indent),
                      Divider(
                        indent: widget.indent,
                        endIndent: widget.indent,
                        color: widget.dividerColor,
                        height: 0,
                        thickness: 1.0,
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Text(
                    widget.datas![i].toString(),
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

  List<Widget>? _convertListItems() {
    if (widget.children == null) {
      return null;
    }
    if (widget.horizontal) {
      List<Widget> result = [];
      for (int i = 0; i < widget.children!.length; i++) {
        result.add(RotatedBox(
          quarterTurns: 1,
          child: widget.children![i],
        ));
      }
      return result;
    } else {
      return widget.children;
    }
  }
}
