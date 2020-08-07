import 'package:flutter/material.dart';

class HeroCard extends StatelessWidget {
  final String count;
  final String label;
  final IconData icon;
  final Color cardTheme;

  HeroCard(
      {@required this.count,
      @required this.label,
      @required this.icon,
      @required this.cardTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: cardTheme.withAlpha(100),
          ),
        ],
      ),
      child: Card(
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.greenAccent,
                      ),
                    ),
                    Text(
                      count,
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 40,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ],
                ),
                Icon(
                  icon,
                  size: 90,
                  color: cardTheme,
                ),
              ],
            ),
          )),
    );
  }
}
