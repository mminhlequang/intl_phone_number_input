import 'package:flutter/material.dart';
import 'package:dash_flags/dash_flags.dart' as dash_flags;

import '../models/country_model.dart';

/// [Item]
class Item extends StatelessWidget {
  final Widget Function(String)? flagbuilder;
  final Country? country;
  final TextStyle? textStyle;
  final double? leadingPadding;
  final bool trailingSpace;

  const Item({
    Key? key,
    this.flagbuilder,
    this.country,
    this.textStyle,
    this.leadingPadding = 12,
    this.trailingSpace = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dialCode = (country?.dialCode ?? '');
    if (trailingSpace) {
      dialCode = dialCode.padRight(5, "   ");
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(width: leadingPadding),
        if (country != null)
          flagbuilder != null
              ? flagbuilder!(country!.alpha2Code!)
              : dash_flags.CountryFlag(
                  country: dash_flags.Country.fromCode(
                      country!.alpha2Code!.toLowerCase()),
                  height: 20,
                ),
        SizedBox(width: leadingPadding),
        Text(
          dialCode,
          textDirection: TextDirection.ltr,
          style: textStyle,
        ),
      ],
    );
  }
}
