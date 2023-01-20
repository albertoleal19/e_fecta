import 'package:flutter/material.dart';

class HorseOption extends StatelessWidget {
  final int number;
  final bool selected;
  final VoidCallback? onSelect;

  const HorseOption({
    Key? key,
    required this.number,
    this.selected = false,
    this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      color: const Color(0xFFFEFAFB),
      elevation: 2,
      child: SizedBox(
        width: 130,
        height: 32,
        child: Row(
          children: [
            Checkbox(value: false, onChanged: (bool? newValue) => {}),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                number.toString(),
              ),
            ),
            Container(
              width: 12,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
                color: getClothColorByNumber(number),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getClothColorByNumber(int? number) {
    switch (number) {
      case 1:
        return NumberColor.one;
      case 2:
        return NumberColor.two;
      case 3:
        return NumberColor.three;
      case 4:
        return NumberColor.four;
      case 5:
        return NumberColor.five;
      case 6:
        return NumberColor.six;
      case 7:
        return NumberColor.seven;
      case 8:
        return NumberColor.eigth;
      case 9:
        return NumberColor.nine;
      case 10:
        return NumberColor.ten;
      case 11:
        return NumberColor.eleven;
      case 12:
        return NumberColor.twelve;
      case 13:
        return NumberColor.thirdteen;
      case 14:
        return NumberColor.fourteen;
      default:
        return NumberColor.fourteen;
    }
  }

  Color getTextColorByNumber(int? number) {
    switch (number) {
      case 1:
      case 3:
      case 5:
      case 10:
      case 13:
        return Colors.white;
      case 2:
      case 4:
      case 7:
      case 8:
      case 9:
      case 12:
        return Colors.black;
      case 6:
      case 14:
        return const Color(0xFFFBDC50);
      case 11:
        return const Color(0xFFAD0000);
      default:
        return Colors.white;
    }
  }
}

class NumberColor {
  static const Color one = Color(0xFFDD0037);
  static const Color two = Color(0xFFFFFFFF);
  static const Color three = Color(0xFF06007F);
  static const Color four = Color(0xFFFBC640);
  static const Color five = Color(0xFF008001);
  static const Color six = Color(0xFF000000);
  static const Color seven = Color(0xFFFF6600);
  static const Color eigth = Color(0xFFFF3299);
  static const Color nine = Color(0xFF32CCCB);
  static const Color ten = Color(0xFF800180);
  static const Color eleven = Color(0xFFBFBFBF);
  static const Color twelve = Color(0xFF00FF00);
  static const Color thirdteen = Color(0xFF663300);
  static const Color fourteen = Color(0xFF800000);
}
