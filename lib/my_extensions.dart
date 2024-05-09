//my_extensions.dart
import 'dart:math';

import 'package:flutter/material.dart';

//Random
extension MyNum on num {
  num random(num max) {
    var number;
    try {
      if (this is int) {
        number = this + Random().nextInt((max - this).toInt());
        return number;
      } else if (this is double) {
        number = this + Random().nextDouble() * (max - this).toDouble();
        return number;
      } else {
        return throw ArgumentError(
            'Sadece int veya double tipinde sayılar desteklenir.');
      }
    } catch (e) {
      print(
          "Lütfen iki double veya iki int sayı arasında random sayı üretin.\n\nÖrneğin:\n3 ile 3.3 arasında sayı üretmek istediğinizde, 3.toRandom(3.3) yazmak yerine 3.0.toRandom(3.3) yazın.\n\nHata açıklaması: $e");
    }
    return number;
  }
}

extension MyStringExtensions on String {
  _MyElevatedButton get elevatedButton => _MyElevatedButton(this);

  int get toInt => int.parse(this);
  double get toDouble => double.parse(this);
  String toTurkishDate(String pattern) => _toDateTime(this, pattern);
}

extension MyListExtensions on List {
  _MyDropDownBottom get dropDownBottom => _MyDropDownBottom(this);
  _MyRadioListTile get radioListTile => _MyRadioListTile(this);
}

extension MyContextExtensions on BuildContext {
  //MyShowDialog get showDialog => MyShowDialog(this);
  void pop<T extends Object?>([T? result]) {
    Navigator.pop(this, result);
  }

  Future<T?> showDialoG<T>({
    String? title,
    String? titleFontFamily,
    Color? titleColor,
    double? titleSize,
    bool? titleBold,
    Widget? content,
    List<Widget>? actions,
    double? height,
    double? width,
    double? border,
    double? borderRadius,
    Color? borderColor,
    Color? backgroundColor,
  }) {
    return showDialog<T?>(
      context: this,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          shape: OutlineInputBorder(
            borderSide: BorderSide(
                color: borderColor ?? Colors.transparent, width: border ?? 1),
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius ?? 1),
            ),
          ),
          title: Text(
            title ?? "",
            style: TextStyle(
              color: titleColor,
              fontWeight:
                  titleBold == true ? FontWeight.bold : FontWeight.normal,
              fontSize: titleSize,
              fontFamily: titleFontFamily,
            ),
          ),
          content: SizedBox(
            height: height,
            width: width ?? MediaQuery.of(context).size.width,
            child: content,
          ),
          actions: actions,
        );
      },
    );
  }
}

String _toDateTime(String time, String pattern) {
  List<String> t = time.split(pattern);
  String y = t[2];
  String a = t[1];
  String g = t[0];
  return "$g ${_intToMonth(a.toInt)} $y";
}

String _intToMonth(int ay) {
  switch (ay) {
    case 1:
      return "Ocak";
    case 2:
      return "Şubat";
    case 3:
      return "Mart";
    case 4:
      return "Nisan";
    case 5:
      return "Mayıs";
    case 6:
      return "Haziran";
    case 7:
      return "Temmuz";
    case 8:
      return "Ağustos";
    case 9:
      return "Eylül";
    case 10:
      return "Ekim";
    case 11:
      return "Kasım";
    case 12:
      return "Aralık";

    default:
      return "";
  }
}

//my_elevatedbutton.dart
class _MyElevatedButton {
  String? _data;
  _MyElevatedButton(this._data);

  Color? _bgColor;
  Color? _textColor;
  VoidCallback? _onPressed;
  VoidCallback? _onLongPress;
  Function(bool)? _onHover;

  double? _left;
  double? _right;
  double? _top;
  double? _bottom;
  double? _leftMargin;
  double? _rightMargin;
  double? _topMargin;
  double? _bottomMargin;
  double? _elevation;

  double? _borderWidth;
  double? _strokeAlign;
  Color? _borderColor;
  double? _textSize;
  double? _width;
  double? _height;
  bool? _bold;
  TextDecoration? _textDecoration;
  bool _combine = false;
  List<TextDecoration>? _decorationsList;

  Widget make(BuildContext context) {
    return SizedBox(
      width: _width,
      height: _height,
      child: Padding(
        padding: EdgeInsets.only(
            left: _leftMargin ?? 0,
            right: _rightMargin ?? 0,
            top: _topMargin ?? 0,
            bottom: _bottomMargin ?? 0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: _elevation,
            padding: EdgeInsets.only(
                left: _left ?? 24,
                right: _right ?? 24,
                top: _top ?? 0,
                bottom: _bottom ?? 0),
            backgroundColor: _bgColor ?? Theme.of(context).colorScheme.primary,
            side: BorderSide(
              color: _borderColor ?? Colors.transparent,
              width: _borderWidth ?? 1,
              strokeAlign: _strokeAlign ?? 0,
            ),
            textStyle: TextStyle(
              color: _textColor,
              fontSize: _textSize,
              fontWeight: _bold == true ? FontWeight.bold : FontWeight.normal,
              decoration: _combine
                  ? TextDecoration.combine(_decorationsList!)
                  : _textDecoration,
            ),
          ),
          onPressed: _onPressed ?? () {},
          onLongPress: _onLongPress ?? () {},
          onHover: _onHover,
          child: Text(
            _data!,
            style: TextStyle(color: _textColor ?? Colors.white),
          ),
        ),
      ),
    );
  }

  _MyElevatedButton combineTextDecoration(
      List<TextDecoration> decorationsList) {
    _combine = true;
    _decorationsList = decorationsList;
    return this;
  }

  _MyElevatedButton get overline {
    _textDecoration = TextDecoration.overline;
    return this;
  }

  _MyElevatedButton get underline {
    _textDecoration = TextDecoration.underline;
    return this;
  }

  _MyElevatedButton get lineThrough {
    _textDecoration = TextDecoration.lineThrough;
    return this;
  }

  _MyElevatedButton get bold {
    _bold = true;
    return this;
  }

  _MyElevatedButton size(double size) {
    _textSize = size;
    return this;
  }

  _MyElevatedButton width(double size) {
    _width = size;
    return this;
  }

  _MyElevatedButton height(double size) {
    _height = size;
    return this;
  }

  _MyElevatedButton elevation(double elevation) {
    _elevation = elevation;
    return this;
  }

  _MyElevatedButton border({
    Color? color = Colors.black,
    double? width,
    double? strokeAlign,
  }) {
    _borderColor = color;
    _borderWidth = width;
    _strokeAlign = strokeAlign;
    return this;
  }

  _MyElevatedButton mOnly(
      {double left = 0, double right = 0, double top = 0, double bottom = 0}) {
    _leftMargin = left;
    _rightMargin = right;
    _topMargin = top;
    _bottomMargin = bottom;
    return this;
  }

  _MyElevatedButton pOnly(
      {double left = 0, double right = 0, double top = 0, double bottom = 0}) {
    _left = left;
    _right = right;
    _top = top;
    _bottom = bottom;
    return this;
  }

  _MyElevatedButton p(double value) {
    _left = value;
    _right = value;
    _top = value;
    _bottom = value;
    return this;
  }

  _MyElevatedButton pX(double value) {
    _left = value;
    _right = value;
    _top = 10;
    _bottom = 10;
    return this;
  }

  _MyElevatedButton pY(double value) {
    _left = 10;
    _right = 10;
    _top = value;
    _bottom = value;
    return this;
  }

  _MyElevatedButton onPressed(void Function() onPressed) {
    _onPressed = onPressed;
    return this;
  }

  _MyElevatedButton onLongPress(void Function() onLongPress) {
    _onLongPress = onLongPress;
    return this;
  }

  _MyElevatedButton onHover(void Function(bool value) onHover) {
    _onHover = onHover;
    return this;
  }

  _MyElevatedButton backgroundColor(Color Colors) {
    _bgColor = Colors;
    return this;
  }

  _MyElevatedButton color(Color Colors) {
    _textColor = Colors;
    return this;
  }

  _MyElevatedButton get textColorRed {
    _textColor = Colors.red;
    return this;
  }
}

class _MyDropDownBottom {
  List _list;
  _MyDropDownBottom(
    this._list,
  );

  Widget make({
    String? hintText,
    Color? hintTextColor,
    Color? dropdownColor,
    Color? textColor,
    Color? focusColor,
    Color? iconDisabledColor,
    Color? iconEnabledColor,
    double? hinTextSize,
    AlignmentGeometry? alignmentGeometry,
    AlignmentGeometry? textAlignmentGeometry,
    double? textSize,
    bool? textBold,
    bool? hintTextBold,
    double? borderRadius,
    double? iconSize,
    double? menuMaxHeight,
    double? itemHeight,
    bool? autofouc,
    bool? isExpanded,
    bool? enableFeedback,
    bool? isDense,
    Widget? icon,
    Widget? disabledHint,
    Widget? underline,
    Widget? textIcon,
    int? elevation,
    EdgeInsets? padding,
    TextStyle? style,
    FocusNode? focusNode,
    MainAxisAlignment? textIconMainAxisAlignment,
    Key? itemKey,
    Key? key,
    required dynamic value,
    required void Function(dynamic selectedValue) onChange,
    void Function()? onTap,
    List<Widget> Function(BuildContext context)? selectedItemBuilder,
  }) {
    return DropdownButton(
      key: key,
      autofocus: autofouc ?? false,
      icon: icon,
      iconSize: iconSize ?? 24.0,
      isExpanded: isExpanded ?? false,
      menuMaxHeight: menuMaxHeight,
      elevation: elevation ?? 0,
      onTap: onTap,
      itemHeight: itemHeight == null
          ? kMinInteractiveDimension
          : itemHeight <= kMinInteractiveDimension
              ? kMinInteractiveDimension
              : itemHeight,
      borderRadius: BorderRadius.circular(borderRadius ?? 0),
      padding: padding,
      disabledHint: disabledHint,
      style: style,
      focusColor: focusColor,
      focusNode: focusNode,
      enableFeedback: enableFeedback,
      iconDisabledColor: iconDisabledColor,
      iconEnabledColor: iconEnabledColor,
      isDense: isDense ?? false,
      selectedItemBuilder: selectedItemBuilder,
      underline: underline,
      dropdownColor: dropdownColor,
      value: value,
      alignment: alignmentGeometry ?? const Alignment(0, 0),
      hint: Text(
        hintText ?? "",
        style: TextStyle(
            color: hintTextColor,
            fontSize: hinTextSize,
            fontWeight:
                hintTextBold ?? false ? FontWeight.bold : FontWeight.normal),
      ),
      items: _list.map((item) {
        return DropdownMenuItem(
            alignment: textAlignmentGeometry ?? const Alignment(0, 0),
            value: item,
            key: itemKey,
            child: textIcon == null
                ? Text(
                    item.toString(),
                    style: TextStyle(
                      color: textColor,
                      fontSize: textSize,
                      fontWeight: textBold ?? false
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  )
                : Row(
                    mainAxisAlignment:
                        textIconMainAxisAlignment ?? MainAxisAlignment.center,
                    children: [
                      textIcon,
                      Text(
                        item.toString(),
                        style: TextStyle(
                          color: textColor,
                          fontSize: textSize,
                          fontWeight: textBold ?? false
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ));
      }).toList(),
      onChanged: (value) {
        value = value;
        onChange(value);
      },
    );
  }
}

class _MyRadioListTile {
  _MyRadioListTile(this.data);
  List data;

  List<Widget> make({
    void Function(bool value)? onFocusChange,
    required void Function(dynamic selectedValue, int index) onChange,
    required dynamic value,
    Key? key,
    Color? activeColor,
    Color? fillColor,
    Color? hoverColor,
    Color? selectedTileColor,
    Color? overlayColor,
    Color? tileColor,
    bool? autofocus,
    bool? dense,
    bool? enableFeedback,
    bool? isThreeLine,
    bool? selected,
    bool? showSubTitle,
    double? splashRadius,
    bool? toggleable,
    EdgeInsets? contentPadding,
    ShapeBorder? shape,
    FocusNode? focusNode,
    Widget? secondary,
    List<String>? subtitle,
    VisualDensity? visualDensity,
    MouseCursor? mouseCursor,
    MaterialTapTargetSize? materialTapTargetSize,
    ListTileControlAffinity? controlAffinity,
  }) {
    subtitle == null ? subtitle = [] : null;
    return List.generate(
      data.length,
      (index) => RadioListTile(
        key: key,
        title: Text(data[index]),
        value: data[index],
        groupValue: value,
        onChanged: (selectedValue) {
          onChange(selectedValue, index);
        },
        activeColor: activeColor,
        autofocus: autofocus ?? false,
        contentPadding: contentPadding,
        controlAffinity: controlAffinity ?? ListTileControlAffinity.platform,
        fillColor: MaterialStatePropertyAll(fillColor),
        focusNode: focusNode,
        hoverColor: hoverColor,
        dense: dense,
        enableFeedback: enableFeedback,
        isThreeLine: isThreeLine ?? false,
        secondary: secondary,
        onFocusChange: onFocusChange,
        selected: selected ?? false,
        selectedTileColor: selectedTileColor,
        shape: shape,
        splashRadius: splashRadius,
        subtitle: showSubTitle == true
            ? subtitle!.length >= data.length
                ? Text(subtitle[index])
                : Container(
                    child: const Text(
                        "Range error for subtitle list. Please make the number of items of the subtitle list equal to the number of items of the other list"),
                  )
            : const SizedBox(),
        overlayColor: MaterialStatePropertyAll(overlayColor),
        tileColor: tileColor,
        toggleable: toggleable ?? false,
        visualDensity: visualDensity,
        mouseCursor: mouseCursor,
        materialTapTargetSize: materialTapTargetSize,
      ),
    );
  }
}
