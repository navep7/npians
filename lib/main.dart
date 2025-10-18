import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

void readFirebase() async {

  QuerySnapshot querySnapshot = await _firestore.collection('npians').get();
  for (var doc in querySnapshot.docs) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    // Process each document's data
    registeredNames.add(data["name"]);
    registeredNumbers.add(data["no"]);
  }
  _makeToast("Total R'd - ${registeredNumbers.length}");
}

void _makeToast(String s) {
  Fluttertoast.showToast(
      msg: s, // The message to display
      toastLength: Toast.LENGTH_SHORT, // Duration: LENGTH_SHORT or LENGTH_LONG
      gravity: ToastGravity.BOTTOM, // Position: TOP, BOTTOM, CENTER
      timeInSecForIosWeb: 1, // Duration for iOS and web
      backgroundColor: Colors.black54, // Background color
      textColor: Colors.white, // Text color
      fontSize: 16.0 // Font size
  );

}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 List registeredNumbers = [];
 List registeredNames = [];

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '.',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '...'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _nocontroller = TextEditingController();
  final TextEditingController _noLogincontroller = TextEditingController();
  String _enteredText = '';
  bool loginBool = true;
  bool signUpBool = false;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    readFirebase();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Container(
          margin: EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 10.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Visibility(
                  visible: loginBool,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextField(
                        controller: _noLogincontroller,
                        decoration: InputDecoration(
                          labelText: 'Mobile Number',
                          hintText: 'enter Valid No. to get an OTP ',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _enteredText = value;
                          });
                        },
                        onSubmitted: (value) {
                          print('Submitted: $value');
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(onPressed: () { setState(() {
                        _logIn(_noLogincontroller.text);
                      }); }, child: Text("LogIn")),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("New user ? "),
                          ElevatedButton(onPressed: () { setState(() {
                            _signUpUI();
                          }); }, child: Text("SignUp"))
                        ],
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: signUpBool,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      TextField(
                        controller: _namecontroller,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          hintText: 'enter Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _enteredText = value;
                          });
                        },
                      ),
                      TextField(
                        controller: _nocontroller,
                        decoration: InputDecoration(
                          labelText: 'Mob Number',
                          hintText: 'enter Valid number to get OTP',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _enteredText = value;
                          });
                        },
                      ),
                      SizedBox(height: 25.0),
                      ElevatedButton(onPressed: _signUp, child: Text("SignUp")),
                      SizedBox(height: 125.0),
                      ElevatedButton(onPressed: _logInUI, child: Text("Or.. back to LogIn")),
                    ],
                  ),
                )
              ]),
        )
        ,
      ),

    );
  }


  void _logInUI() {
    _makeToast("_logIn");
    setState(() {
      loginBool = true;
      signUpBool = false;
    });


  }

  void _signUpUI() {
    _makeToast("_signUp");
    setState(() {
      loginBool = false;
      signUpBool = true;
    });
  }

  void _logIn(String no) {
    if(registeredNumbers.contains(no)) {
      int index = registeredNumbers.indexOf(no);
      _makeToast("Index - $index");
      _makeToast("Exists - ${registeredNames[index]}");
    } else _makeToast("No Rd No, sign Up maybe!");
  }

  void _signUp() {
    _makeToast("A SignUP");
    CollectionReference collectionReference = _firestore.collection("npians");
    try {
      collectionReference.add({
        'name': _namecontroller.text,
        'no': _nocontroller.text,
        'pic': "picNP"
      });
      _makeToast("Successfully Signed UP, you can login now..");
      readFirebase();
      setState(() {
        loginBool = true;
        signUpBool = false;
      });
    } catch(ex) {
      _makeToast("Sign UP failed, try again later..");
    }
  }




}
