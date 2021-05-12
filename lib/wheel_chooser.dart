import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WheelChooser<T> extends StatefulWidget {
  final TextStyle? selectTextStyle;
  final TextStyle? unSelectTextStyle;
  final Function(T) onValueChanged;
  final List<T>? options;
  final int startPosition;
  final double itemSize;
  final double squeeze;
  final double magnification;
  final double perspective;
  final double? listHeight;
  final double? listWidth;
  final bool horizontal;
  final bool isInfinite;
  final double? indent;
  final Color dividerColor;
  static const double _defaultItemSize = 48.0;
  final WheelBuilder<T> builder;

  WheelChooser({
    required this.onValueChanged,
    required this.options,
    required this.builder,
    this.selectTextStyle,
    this.unSelectTextStyle,
    this.startPosition = 0,
    this.squeeze = 1.0,
    this.itemSize = _defaultItemSize,
    this.magnification = 1,
    this.perspective = 0.0000000001,
    this.listWidth,
    this.listHeight,
    this.dividerColor = Colors.transparent,
    this.indent = 16.0,
    this.horizontal = false,
    this.isInfinite = false,
  }) : assert(perspective <= 0.01);

  @override
  _WheelChooserState<T> createState() => _WheelChooserState<T>();
}

class _WheelChooserState<T> extends State<WheelChooser<T>> {
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
    if (widget.options == null) {
      widget.onValueChanged(widget.options![currentPosition!]);
    } else {
      widget.onValueChanged(widget.options![currentPosition!]);
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

  Widget _getListWheelScrollView<T>() {
    return ListWheelScrollView.useDelegate(
      itemExtent: widget.itemSize,
      perspective: widget.perspective,
      squeeze: widget.squeeze,
      controller: fixedExtentScrollController,
      diameterRatio: 20,
      physics: FixedExtentScrollPhysics(),
      onSelectedItemChanged: _listener,
      childDelegate: ListWheelChildBuilderDelegate(
          childCount: widget.options!.length,
          builder: (BuildContext context, int i) {
            return _buildListItems(i); //_buildListItems(i);
          }),
    );
    // return widget.builder(widget.options![0]);
  }

  Widget _buildListItems<T>(int i) {
    return RotatedBox(
      quarterTurns: widget.horizontal ? 1 : 0,
      child: i == currentPosition
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Divider(
                    indent: widget.indent,
                    endIndent: widget.indent,
                    color: widget.dividerColor,
                    thickness: 1.0,
                    height: 0,
                  ),
                  SizedBox(height: widget.indent),
                  widget.builder(widget.options![i]),
                  // Text(i.toString()),
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
          : Center(child: widget.builder(widget.options![i])),
    );
  }
}

typedef WheelBuilder<T> = Widget Function(T option);
