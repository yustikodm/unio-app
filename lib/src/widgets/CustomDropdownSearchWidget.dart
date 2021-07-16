import 'package:Unio/config/ui_icons.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDropdownWidget extends StatelessWidget {
  const CustomDropdownWidget({
    Key key,
    @required this.context,
    @required this.items,
    this.label,
    this.hint,
    @required this.onChanged,
    this.selectedItem,
  }) : super(key: key);

  final BuildContext context;
  final List<String> items;
  final String label;
  final String hint;
  final Function(String) onChanged;
  final String selectedItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 0.0),
        child: Container(
          height: 55.0,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).hintColor.withOpacity(0.10),
                  offset: Offset(0, 4),
                  blurRadius: 10)
            ],
          ),
          child: DropdownSearch<String>(
            mode: Mode.BOTTOM_SHEET,
            showSelectedItem: true,
            showSearchBox: true,
            showClearButton: true,
            items: items,
            label: label,
            hint: hint,
            onChanged: onChanged,
            selectedItem: selectedItem,
            dropdownSearchDecoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
            clearButtonBuilder: (context) {
              return Container(
                padding: EdgeInsets.only(right: 10.0),
                child: Icon(UiIcons.trash,
                    size: 20,
                    color: Theme.of(context).hintColor.withOpacity(0.5)),
              );
            },

            // TODOS: FIGURE OUT HOW TO RE BUILD THIS
            dropdownButtonBuilder: (context) {
              return Container(
                child: Icon(Icons.arrow_drop_down,
                    size: 20,
                    color: Theme.of(context).hintColor.withOpacity(0.5)),
              );

              // return SizedBox();
            },
            emptyBuilder: (context, text) {
              return Container(
                alignment: Alignment.center,
                child: Text(
                  'No data found',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              );
            },
            searchBoxDecoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue.shade100,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
