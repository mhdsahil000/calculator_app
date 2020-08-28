import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "simple interest calculator",
    home: SIForm(),
    theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.indigo,
        accentColor: Colors.indigoAccent),
  ));
}

class SIForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SIFormState();
  }
}

class _SIFormState extends State<SIForm> {
  var _formKey = GlobalKey<FormState>();
  var _currencies = ['Rupees', 'Dollars', 'Pounds', 'Others'];
  var _currencySelected = 'Rupees';

  TextEditingController principalController = TextEditingController();
  TextEditingController roiController = TextEditingController();
  TextEditingController termController = TextEditingController();

  var _dispayResult = '';

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.subtitle1;
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('simple interest calculator'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            getImageAsset(),
            TextFormField(
              keyboardType: TextInputType.number,
              style: textStyle,
              controller: principalController,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              // ignore: missing_return
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please Enter the principal amount';
                }
              },
              decoration: InputDecoration(
                  labelText: 'principal',
                  hintText: 'Enter Principal Amount e.g 12000',
                  labelStyle: textStyle,
                  errorStyle: TextStyle(fontSize: 15.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                style: textStyle,
                controller: roiController,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                // ignore: missing_return
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please Enter the Interest rate';
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Rate of Interest',
                    hintText: 'Enter e.g 12%',
                    labelStyle: textStyle,
                    errorStyle: TextStyle(fontSize: 15.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    style: textStyle,
                    controller: termController,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    // ignore: missing_return
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please Enter the time paerid';
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Term',
                        hintText: 'Enter e.g 12 months',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Container(
                  width: 20.0,
                ),
                Expanded(
                  child: DropdownButton<String>(
                    items: _currencies.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: textStyle,
                        ),
                      );
                    }).toList(),
                    value: _currencySelected,
                    onChanged: (String newSelected) {
                      setState(() {
                        this._currencySelected = newSelected;
                      });
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).accentColor,
                      textColor: Theme.of(context).primaryColorDark,
                      child: Text(
                        "Calculate",
                        style: textStyle,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_formKey.currentState.validate()) {
                            this._dispayResult = _calculateTotalReturns();
                          }
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        "Reset",
                        style: textStyle,
                      ),
                      onPressed: () {
                        setState(() {
                          _reset();
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                this._dispayResult,
                style: textStyle,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/sbi logo.png');
    Image image = Image(image: assetImage);
    return Container(
      child: image,
      margin: EdgeInsets.only(left: 10.0, top: 20.0, bottom: 20.0),
      height: 150.0,
      width: 100.0,
    );
  }

  String _calculateTotalReturns() {
    double principal = double.parse(principalController.text);
    double roi = double.parse(roiController.text);
    double term = double.parse(termController.text);

    double totalAmountPayable = principal + (principal * roi * term) / 100;
    String result =
        'After $term year , your investment will be $totalAmountPayable $_currencySelected';
    return result;
  }

  void _reset() {
    principalController.text = '';
    roiController.text = '';
    termController.text = '';
    _dispayResult = '';
    _currencySelected = _currencies[0];
  }
}
