import 'package:flutter/material.dart';
import 'package:newsfeed/newsfeed.dart';

void main()=> runApp(Wolfcry());

class Wolfcry extends StatefulWidget {
  @override
  WolfcryState createState() {
    return new WolfcryState();
  }
}

class WolfcryState extends State<Wolfcry> {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Newsfeed());
  }
}


class SwitchButton extends StatefulWidget {
  final bool switchValue;
  final ValueChanged valueChanged;
  @override
  _SwitchButtonState createState() => _SwitchButtonState();
  SwitchButton({@required this.switchValue, @required this.valueChanged});
}

class _SwitchButtonState extends State<SwitchButton> {
  bool _switchValue;

  @override
    void initState() {
      _switchValue = widget.switchValue;
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Switch(
                      onChanged: (val){
                        setState(() {
                          _switchValue = val;
                          widget.valueChanged(val);
                        });
                      },
                      value: _switchValue,
                    ),
    );
  }
}





