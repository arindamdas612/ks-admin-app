import 'package:flutter/material.dart';

class StatusCountIcon extends StatelessWidget {
  final int _count;

  StatusCountIcon(this._count);

  @override
  Widget build(BuildContext context) {
    IconData icon;
    switch (_count) {
      case 0:
        icon = Icons.not_interested;
        break;
      case 1:
        icon = Icons.filter_1;
        break;
      case 2:
        icon = Icons.filter_2;
        break;
      case 3:
        icon = Icons.filter_3;
        break;
      case 4:
        icon = Icons.filter_4;
        break;
      case 5:
        icon = Icons.filter_5;
        break;
      case 6:
        icon = Icons.filter_6;
        break;
      case 7:
        icon = Icons.filter_7;
        break;
      case 8:
        icon = Icons.filter_8;
        break;
      case 9:
        icon = Icons.filter_9;
        break;
      default:
        icon = Icons.filter_9_plus;
    }
    return Icon(icon);
  }
}
