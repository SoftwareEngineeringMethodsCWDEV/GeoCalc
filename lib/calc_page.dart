import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class calcPage extends StatefulWidget {
  const calcPage({Key? key}) : super(key: key);

  void main() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  State<calcPage> createState() => _CalcPageState();
}

class _CalcPageState extends State<calcPage> {
  static const bTSKey = 'BTsize';
  static const sTSKey = 'STsize';
  static const mTSKey = 'MTsize';
  static const colKey = 'Kolsize';
  static const deadKey = 'Deadsize';

  static const enableKey = 'enbaled';
  static const filledKey = 'filled';

  var finalValue = TextEditingController();

  bool isEnabled = true, isFilled = false;

  Color _containerColor = Colors.white;
  int BTCount = 0, STCount = 0, MTCount = 0;
  double BTSize = 0,
      STSize = 0,
      MTSize = 0,
      ColTubeSize = 0,
      DeadSize = 0,
      WorkSize = 0,
      res = 0,
      resFontSize = 20;

  String _bTSinitedField = '';
  String _sTSinitedField = '';
  String _mTSinitedField = '';
  String _colinitedField = '';
  String _deadinitedField = '';

  String resText = 'Введите все значения';
  TextEditingController BTCcontroller = TextEditingController(text: '');
  TextEditingController STCcontroller = TextEditingController(text: '');
  TextEditingController MTCcontroller = TextEditingController(text: '');
  TextEditingController BTScontroller = TextEditingController(text: '');
  TextEditingController STScontroller = TextEditingController(text: '');
  TextEditingController MTScontroller = TextEditingController(text: '');
  TextEditingController Colcontroller = TextEditingController(text: '');
  TextEditingController Deadcontroller = TextEditingController(text: '');
  TextEditingController Workcontroller = TextEditingController(text: '');

  String doCount() {
    BTCount = int.parse(BTCcontroller.text);
    BTSize = double.parse(BTScontroller.text);
    STCount = int.parse(STCcontroller.text);
    STSize = double.parse(STScontroller.text);
    MTCount = int.parse(MTCcontroller.text);
    MTSize = double.parse(MTScontroller.text);
    ColTubeSize = double.parse(Colcontroller.text);
    DeadSize = double.parse(Deadcontroller.text);
    WorkSize = double.parse(Workcontroller.text);

    if (ColTubeSize != 0 && DeadSize != 0 && WorkSize != 0) {
      res = ((BTCount * BTSize) +
              (STCount * STSize) +
              (MTCount * MTSize) +
              ColTubeSize) -
          DeadSize -
          WorkSize;
      resText = res.toString();
      resFontSize = 40;
    } else {
      resText = 'Введите все значения';
      resFontSize = 20;
    }
    return resText;
  }

  @override
  void initState() {
    _initField();
    super.initState();
  }

  Future _initField() async {
    _bTSinitedField = await _getField(bTSKey);
    _sTSinitedField = await _getField(sTSKey);
    _mTSinitedField = await _getField(mTSKey);
    _colinitedField = await _getField(colKey);
    _deadinitedField = await _getField(deadKey);
    isEnabled = await _getEnabled();
    isFilled = await _getFilled();
    BTScontroller = TextEditingController(text: _bTSinitedField);
    STScontroller = TextEditingController(text: _sTSinitedField);
    MTScontroller = TextEditingController(text: _mTSinitedField);
    Colcontroller = TextEditingController(text: _colinitedField);
    Deadcontroller = TextEditingController(text: _deadinitedField);
    buttonColor();
  }

  void lockValues() async {
    setState(() {
      isEnabled = !isEnabled;
      isFilled = !isFilled;
      if (isEnabled == true) {
        _containerColor = Colors.white;
        _clearField();
      } else {
        _containerColor = Colors.blue[900]!;
        setAllFields();
      }
      ;
    });
  }

  Future _setField(TubyKey, TubeController) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(TubyKey, TubeController.text);
    prefs.setBool(enableKey, isEnabled);
    prefs.setBool(filledKey, isFilled);
  }

  void setAllFields() {
    _setField(bTSKey, BTScontroller);
    _setField(sTSKey, STScontroller);
    _setField(mTSKey, MTScontroller);
    _setField(colKey, Colcontroller);
    _setField(deadKey, Deadcontroller);
  }

  Future _clearField() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<String> _getField(getKey) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(getKey) ?? '';
  }

  Future<bool> _getEnabled() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool(enableKey) ?? true;
  }

  Future<bool> _getFilled() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool(filledKey) ?? false;
  }

  void buttonColor() {
    if (isEnabled == true) {
      _containerColor = Colors.white;
    } else {
      _containerColor = Colors.blue[900]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              color: Colors.blue,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Row(children: const [
                    SizedBox(width: 60),
                    Text("Количество",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 17)),
                    Spacer(),
                    Text("Размеры (м.)",
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 17))
                  ]),
                ),
                Row(children: [
                  const Text("Б/Т:",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 30)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 9.0),
                    child: Row(children: [
                      const SizedBox(width: 20),
                      Container(
                        width: 100,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          minLines: 1,
                          controller: BTCcontroller,
                          onChanged: (BTCcontroller) {
                            setState(() {
                              resText = doCount();
                            });
                          },
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 17.5),
                        child: const SizedBox(width: 40),
                      ),
                      Container(
                        width: 100,
                        child: TextField(
                          enabled: isEnabled,
                          keyboardType: TextInputType.number,
                          minLines: 1,
                          controller: BTScontroller,
                          onChanged: (BTScontroller) {
                            setState(() {
                              resText = doCount();
                            });
                          },
                          decoration: InputDecoration(
                            filled: isFilled,
                            fillColor: Colors.blue[900],
                          ),
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ]),
                  )
                ]),
                Row(children: [
                  const Text("C/Т:",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 30)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 9.0),
                    child: Row(children: [
                      const SizedBox(width: 20),
                      Container(
                        width: 100,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          minLines: 1,
                          controller: STCcontroller,
                          onChanged: (STCcontroller) {
                            setState(() {
                              resText = doCount();
                            });
                          },
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 9),
                        child: const SizedBox(width: 40),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 100,
                          child: TextField(
                            enabled: isEnabled,
                            keyboardType: TextInputType.number,
                            minLines: 1,
                            controller: STScontroller,
                            onChanged: (STScontroller) {
                              setState(() {
                                resText = doCount();
                              });
                            },
                            decoration: InputDecoration(
                              filled: isFilled,
                              fillColor: Colors.blue[900],
                            ),
                            style: const TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ]),
                  )
                ]),
                Row(children: [
                  const Text("М/Т:",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 30)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 9.0),
                    child: Row(children: [
                      const SizedBox(width: 20),
                      Container(
                        width: 100,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          minLines: 1,
                          controller: MTCcontroller,
                          onChanged: (MTCcontroller) {
                            setState(() {
                              resText = doCount();
                            });
                          },
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 9),
                        child: const SizedBox(width: 40),
                      ),
                      Container(
                        width: 100,
                        child: TextField(
                          enabled: isEnabled,
                          keyboardType: TextInputType.number,
                          minLines: 1,
                          controller: MTScontroller,
                          onChanged: (MTScontroller) {
                            setState(() {
                              resText = doCount();
                            });
                          },
                          decoration: InputDecoration(
                            filled: isFilled,
                            fillColor: Colors.blue[900],
                          ),
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ]),
                  )
                ]),
                SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Row(children: const [
                    SizedBox(width: 60),
                    Text("Колонковая труба",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 17)),
                    Spacer(),
                    Text("Мертвый замер",
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 17))
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 9),
                  child: Row(children: [
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          lockValues();
                        });
                      },
                      child: Icon(
                        Icons.lock,
                        color: _containerColor,
                        size: 50,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 9),
                      child: Container(
                        width: 100,
                        child: TextField(
                          enabled: isEnabled,
                          keyboardType: TextInputType.number,
                          minLines: 1,
                          controller: Colcontroller,
                          onChanged: (Colcontroller) {
                            setState(() {
                              resText = doCount();
                            });
                          },
                          decoration: InputDecoration(
                            filled: isFilled,
                            fillColor: Colors.blue[900],
                          ),
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 9.0),
                      child: Container(
                        width: 100,
                        child: TextField(
                          enabled: isEnabled,
                          keyboardType: TextInputType.number,
                          minLines: 1,
                          controller: Deadcontroller,
                          onChanged: (Deadcontroller) {
                            setState(() {
                              resText = doCount();
                            });
                          },
                          decoration: InputDecoration(
                            filled: isFilled,
                            fillColor: Colors.blue[900],
                          ),
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ]),
                ),
                SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: const Center(
                    child: Text("Рабочий замер",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 20)),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      width: 140,
                      child: TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        minLines: 1,
                        controller: Workcontroller,
                        onChanged: (Workcontroller) {
                          setState(() {
                            resText = doCount();
                          });
                        },
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text("Глубина скважины",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Center(
                    child: TextField(
                        key: Key(res.toString()),
                        controller: finalValue,
                        onChanged: (res) {
                          setState(() {
                            resText = doCount();
                          });
                        },
                        textAlign: TextAlign.center,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: '$resText',
                          hintStyle: TextStyle(
                            fontSize: resFontSize,
                            color: Colors.white,
                          ),
                        )),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}
