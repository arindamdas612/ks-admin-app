import 'package:flutter/material.dart';

class SpecForm extends StatefulWidget {
  final String sKey;
  final String sValue;
  final Function onDelete;

  final state = _SpecFormState();

  SpecForm({
    Key key,
    @required this.sKey,
    @required this.sValue,
    @required this.onDelete,
  }) : super(key: key);

  @override
  _SpecFormState createState() => state;

  bool isValid() => state.validate();
  Map<String, String> getData() => state.getSpecs();
}

class _SpecFormState extends State<SpecForm> {
  final _form = GlobalKey<FormState>();
  var spKey;
  var spValue;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
          child: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AppBar(
              leading: Icon(Icons.settings),
              title: const Text('Add a Specification'),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => widget.onDelete())
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: widget.sKey,
                onSaved: (value) => spKey = value,
                validator: (value) =>
                    value.length > 0 ? null : 'Key Value Cannot be empty!!',
                decoration: InputDecoration(
                  labelText: 'Specification Key',
                  hintText: 'Add a specification title for the product',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: widget.sValue,
                onSaved: (value) => spValue = value,
                validator: (value) =>
                    value.length > 0 ? null : 'Value Cannot be empty!!',
                decoration: InputDecoration(
                  labelText: 'Specification Value',
                  hintText: 'Add a specification value for the product',
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  bool validate() {
    var valid = _form.currentState.validate();
    if (valid) _form.currentState.save();
    return valid;
  }

  Map<String, String> getSpecs() {
    return {
      'key': spKey,
      'value': spValue,
    };
  }
}
