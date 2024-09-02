import 'package:e_fecta/core/app_colors.dart';
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
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        width: 120,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 2,
              offset: Offset(3, 3), // Shadow position
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Row(
            children: [
              Radio<int>(
                value: number,
                groupValue: selected ? number : -1,
                toggleable: true,
                onChanged: (value) {
                  onSelect!();
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  number.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                width: 12,
                decoration: BoxDecoration(
                  color: getClothColorByNumber(number),
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4)),
                  border: Border.all(
                    color: getClothColorByNumber(number) == NumberColor.two
                        ? const Color(0xFFDBDBDB)
                        : Colors.transparent,
                  ),
                ),
                // color: getClothColorByNumber(number),
              ),
            ],
          ),
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
}

class NumberColor {
  static const Color one = Color(0xFFFF0000);
  static const Color two = Color(0xFFFFFFFF);
  static const Color three = Color(0xFF06007F);
  static const Color four = Color(0xFFFEFF00);
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
