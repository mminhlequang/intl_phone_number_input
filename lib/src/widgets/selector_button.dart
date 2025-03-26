import 'package:flutter/material.dart';

import '../../intl_phone_number_input.dart';
import '../models/country_model.dart';
import 'item.dart';

/// [SelectorButton]
class SelectorButton extends StatelessWidget {
  final List<Country> countries;
  final Country? country;
  final SelectorConfig selectorConfig;
  final InputDecoration? searchBoxDecoration;
  final bool autoFocusSearchField;
  final String? locale;
  final bool isEnabled;
  final bool isScrollControlled;

  final ValueChanged<Country?> onCountryChanged;

  const SelectorButton({
    Key? key,
    required this.countries,
    required this.country,
    required this.selectorConfig,
    required this.searchBoxDecoration,
    required this.autoFocusSearchField,
    required this.locale,
    required this.onCountryChanged,
    required this.isEnabled,
    required this.isScrollControlled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return selectorConfig.selectorType == PhoneInputSelectorType.DROPDOWN
        ? countries.isNotEmpty && countries.length > 1
            ? DropdownButtonHideUnderline(
                child: DropdownButton<Country>(
                  elevation: 4,
                  icon: Container(
                    margin: const EdgeInsets.only(right: 6),
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: selectorConfig.selectorTextStyle!.color ??
                          Colors.grey,
                    ),
                  ),
                  hint: Item(
                    country: country,
                    flagbuilder: selectorConfig.flagbuilder,
                    leadingPadding: selectorConfig.leadingPadding,
                    trailingSpace: selectorConfig.trailingSpace,
                    textStyle: selectorConfig.selectorTextStyle,
                  ),
                  value: country,
                  items: mapCountryToDropdownItem(countries),
                  onChanged: isEnabled ? onCountryChanged : null,
                  dropdownColor: selectorConfig.bgColor,
                ),
              )
            : Item(
                country: country,
                flagbuilder: selectorConfig.flagbuilder,
                leadingPadding: selectorConfig.leadingPadding,
                trailingSpace: selectorConfig.trailingSpace,
                textStyle: selectorConfig.selectorTextStyle,
              )
        : MaterialButton(
            padding: EdgeInsets.zero,
            minWidth: 0,
            onPressed: countries.isNotEmpty && countries.length > 1 && isEnabled
                ? () async {
                    Country? selected;
                    if (selectorConfig.selectorType ==
                        PhoneInputSelectorType.BOTTOM_SHEET) {
                      selected = await showCountrySelectorBottomSheet(
                          context, countries);
                    } else {
                      selected =
                          await showCountrySelectorDialog(context, countries);
                    }

                    if (selected != null) {
                      onCountryChanged(selected);
                    }
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Item(
                country: country,
                flagbuilder: selectorConfig.flagbuilder,
                leadingPadding: selectorConfig.leadingPadding,
                trailingSpace: selectorConfig.trailingSpace,
                textStyle: selectorConfig.selectorTextStyle,
              ),
            ),
          );
  }

  /// Converts the list [countries] to `DropdownMenuItem`
  List<DropdownMenuItem<Country>> mapCountryToDropdownItem(
      List<Country> countries) {
    return countries.map((country) {
      return DropdownMenuItem<Country>(
        value: country,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.0),
          child: Item(
            country: country,
            flagbuilder: selectorConfig.flagbuilder,
            textStyle: selectorConfig.selectorTextStyle,
            trailingSpace: selectorConfig.trailingSpace,
          ),
        ),
      );
    }).toList();
  }

  /// shows a Dialog with list [countries] if the [PhoneInputSelectorType.DIALOG] is selected
  Future<Country?> showCountrySelectorDialog(
      BuildContext inheritedContext, List<Country> countries) {
    return showDialog(
      context: inheritedContext,
      barrierDismissible: true,
      builder: (BuildContext context) =>
          selectorConfig.dialogSearchBuilder!(countries),
    );
  }

  /// shows a Dialog with list [countries] if the [PhoneInputSelectorType.BOTTOM_SHEET] is selected
  Future<Country?> showCountrySelectorBottomSheet(
      BuildContext inheritedContext, List<Country> countries) {
    return showModalBottomSheet(
      context: inheritedContext,
      clipBehavior: Clip.hardEdge,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return selectorConfig.bottomSheetBuilder!(countries);
      },
    );
  }
}
