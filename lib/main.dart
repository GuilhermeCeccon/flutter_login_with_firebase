import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'signup.dart';
import 'homePage.dart';
import 'firebase_options.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          '/signup': (BuildContext context) => new SignupPage(),
          '/homePage' : (BuildContext context) => new HomePage()
        }
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

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  int _success = 1;
  String _userEmail = "";

  void _singIn() async {
    final user = (await _auth.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text)).user;
    Navigator.of(context).pushNamed('/homePage');
    setState(() {
      _success = 1;
      _userEmail = '';
    });

    if(user != null){
      setState(() {
        _success = 2;
        _userEmail = user.email!;
      });
    } else {
      setState(() {
        _success = 3;
      });
    }
    if(user == null){
      setState(() {
        _success = 4;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            child:Stack(
              children:<Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(15, 110, 0, 0),
                  child: Text("Seja Bem-Vindo",
                  style: TextStyle(
                    fontSize: 40, fontWeight: FontWeight.bold
                  ),
                  )
                )
              ]
            )
          ),
          Container(
            padding: EdgeInsets.only(top: 35, left: 20, right: 30),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'EMAIL',
                    labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    )
                  ),
                ),
                SizedBox(height: 20,),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                      labelText: 'SENHA',
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      )
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 5.0,),
                Container(
                  alignment: Alignment(1,0),
                  padding: EdgeInsets.only(top: 15, left: 20),
                  child: Text(
                    'Esqueci minha senha',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      decoration: TextDecoration.underline
                    ),
                  ),
                )
              ]
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _success == 1
                  ? ''
                  : (
              _success == 2
                  ? 'Sucesso'
                  : (
              _success == 3
                  ? 'Erro'
                  : 'Preencha os campos'
                    )
              ),
              style: TextStyle(color: Colors.red),
            ),
          ),
          SizedBox(height: 40,),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.only(left: 30, right: 30),
            height: 40,
            child: Material(
              borderRadius: BorderRadius.circular(20),
              shadowColor: Colors.greenAccent,
              color: Colors.black,
              elevation: 7,
              child: GestureDetector(
                  onTap: () async {
                    _singIn();
                },
                child: Center(
                  child: Text(
                    'Entrar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'
                    ),
                  ),
                )
              )
            ),
          ),
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed('/signup');
                },
                child: Text(
                  "Criar Conta",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
