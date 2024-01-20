// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:weather_app/apis/get_cities_by_name.dart';
import 'package:weather_app/models/city.dart';

class LocationSearchBar extends StatefulWidget {
  const LocationSearchBar(
      {super.key, required this.setCity, required this.searchFocusNode});
  final void Function(City city) setCity;
  final FocusNode searchFocusNode;

  @override
  State<LocationSearchBar> createState() => _LocationSearchBarState();
}

class _LocationSearchBarState extends State<LocationSearchBar> {
  var resetKey = UniqueKey();
  TextEditingController? currentTextEditingController;
  FocusNode? currentFocusNode;

  String displayStringForOption(City city) => "${city.name} - ${city.country}";

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Autocomplete<City>(
        key: resetKey,
        displayStringForOption: displayStringForOption,
        fieldViewBuilder: (
          BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted,
        ) {
          currentTextEditingController = textEditingController;
          currentFocusNode = focusNode;

          widget.searchFocusNode.addListener(() {
            if (focusNode.hasFocus) {
              focusNode.unfocus();
            } else {
              focusNode.requestFocus();
            }
          });

          return TextFormField(
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              labelText: 'Search location',
              labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
            cursorColor: Colors.white,
            style: const TextStyle(
              color: Colors.white,
              decorationColor: Colors.white,
            ),
            controller: textEditingController,
            focusNode: focusNode,
            onFieldSubmitted: (String value) {
              onFieldSubmitted();
            },
          );
        },
        optionsBuilder: (TextEditingValue textEditingValue) async {
          if (textEditingValue.text == '') {
            return const Iterable<City>.empty();
          }

          try {
            final cities =
                await getCitiesByName(textEditingValue.text, limit: 5);
            return cities;
          } catch (error) {
            var snackBar = const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Failed to get cities, check your connection.'),
              duration: Duration(seconds: 5),
              // put at the top
              behavior: SnackBarBehavior.floating,
            );

            ScaffoldMessenger.of(context).clearSnackBars();
            Future.delayed(const Duration(seconds: 1)).then(((value) {
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              currentFocusNode!.unfocus();
            }));
            return [];
          }
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth,
                  ),
                  child: Container(
                    color: Colors.black,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final City option = options.elementAt(index);
                        return InkWell(
                          onTap: () {
                            onSelected(option);
                          },
                          child: Builder(
                            builder: (BuildContext context) {
                              final bool highlight =
                                  AutocompleteHighlightedOption.of(context) ==
                                      index;
                              if (highlight) {
                                SchedulerBinding.instance
                                    .addPostFrameCallback((Duration timeStamp) {
                                  Scrollable.ensureVisible(context,
                                      alignment: 0.5);
                                });
                              }
                              return Container(
                                color: highlight
                                    ? Theme.of(context).focusColor
                                    : null,
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Opacity(
                                      opacity: 0.3,
                                      child: Icon(Icons.location_city, color: Color.fromARGB(255, 92, 242, 235),),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      option.name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        option.region != null
                                            ? "${option.region}, ${option.country}"
                                            : option.country,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .fontSize,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .color!
                                              .withOpacity(0.4),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        onSelected: (City selectedCity) {
          widget.setCity(selectedCity);
          if (currentFocusNode != null) {
            currentFocusNode!.unfocus();
          }
          if (currentTextEditingController != null) {
            currentTextEditingController!.clear();
          }
        },
      ),
    );
  }
}
