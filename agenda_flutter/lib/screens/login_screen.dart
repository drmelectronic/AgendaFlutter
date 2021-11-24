
import 'package:agenda_flutter/models/login.dart';
import 'package:agenda_flutter/screens/agenda_screen.dart';
import 'package:agenda_flutter/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen>{
  List<String> empresas =  ['ARCOIRIS', 'ET160', 'ET41', 'ETFVSA', 'ETMISPSA',
    'EVIFASA', 'LAS FLORES', 'LUBARSA', 'SAN GENARO', 'SAN GERMAN', 'SAN PEDRO',
    'SMP36', 'URBANITO'];

  LoginRequestModel loginRequestModel = LoginRequestModel(password: '', username: '');
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String empresa = 'URBANITO';
  String username = '';
  String password = '';
  bool hidePassword = true;
  var version = '1.0.2';

  double height = 50;

  final TextEditingController _usernameTextController = TextEditingController(text: '');
  final TextEditingController _passwordTextController = TextEditingController(text: '');

  @override
  initState() {
    super.initState();
    loadSharedPreferences();
  }

  Future clearSharedPreferences() async {
    SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString('token', '');
      prefs.setString('empresa', 'URBANITO');
      prefs.setString('username', '');
      prefs.setString('password', '');
      _usernameTextController.value = const TextEditingValue(
          text: ''
      );
      _passwordTextController.value = const TextEditingValue(
          text: ''
      );
      loginRequestModel.username = '';
      loginRequestModel.password = '';
      empresa = 'URBANITO';
    });
  }

  Future loadSharedPreferences () async {
    SharedPreferences prefs = await _prefs;
    setState(() {
      empresa = prefs.getString('empresa')!;
      if (!empresas.contains(empresa)) {
        empresa = 'URBANITO';
      }
      username = prefs.getString('username')!;
      password = prefs.getString('password')!;
      _usernameTextController.value = TextEditingValue(
        text: username
      );
      _passwordTextController.value = TextEditingValue(
          text: password
      );
      loginRequestModel.username = username;
      loginRequestModel.password = password;
    });
  }

  onLogin() {
    var apiService = APIService();
    apiService.setEmpresa(empresa).then((success) {
      apiService.login(loginRequestModel).then( (value) {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AgendaScreen()));
      }).catchError((error) {
        final snackBar = SnackBar(content: Text(error.message));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    });    
  }

  Widget buildEmpresa() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
            'Empresa',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold
            )
        ),
        const SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2)
                )
              ]
          ),
          height: height,
          child: Stack(
            children: [
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
                  child: const Icon(
                    Icons.domain,
                    color: Color(0x990066a9),
                    size: 20.0,
                  )
              ),
              Padding(
                padding: const EdgeInsets.only(top: 14.0, left: 48.0, right: 14, bottom: 14.0),
                child: DropdownButton(
                  isExpanded: true,
                  items: empresas.map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                              value: value, child: Text(value))
                  ).toList(),
                  onChanged: (String? newValue) => {
                    setState(() {
                      empresa = newValue!;
                    })
                  },
                  underline: const SizedBox(),
                  value: empresa,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
            'Usuario',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold
            )
        ),
        const SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2)
                )
              ]
          ),
          height: height,
          child: TextFormField(
            onChanged: (input) => loginRequestModel.username = input,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
              color: Colors.black87,
            ),
            decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                    Icons.person,
                    color: Color(0x990066a9)
                ),
                hintText: 'Usuario',
                hintStyle: TextStyle(
                    color: Colors.black38
                )
            ),
            // initialValue: username,
            controller: _usernameTextController,
          ),
        )
      ],
    );
  }

  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
            'Contraseña',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold
            )
        ),
        const SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2)
                )
              ]
          ),
          height: height,
          child: TextFormField(
            onChanged: (input) => loginRequestModel.password = input,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
              color: Colors.black87,
            ),
            // initialValue: password,
            controller: _passwordTextController,
            obscureText: true,
            obscuringCharacter: '*',
            decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                    Icons.lock,
                    color: Color(0x990066a9)
                ),
                hintText: 'Password',
                hintStyle: TextStyle(
                    color: Colors.black38
                ),
            ),
          ),
        )
      ],
    );
  }


  Widget buildLoginBtn() {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: TextButton(
              onPressed: () => onLogin(),
              child: const Text(
                  'Ingresar',
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  )
              ),
              style: ElevatedButton.styleFrom(
                  elevation: 8,
                  primary: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical:14)
              )
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          flex: 1,
          child: TextButton(
              onPressed: () => clearSharedPreferences(),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
                size: 18
              ),
              style: ElevatedButton.styleFrom(
                  elevation: 8,
                  primary: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical:16)
              )
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value:SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget> [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x660066a9),
                        Color(0x990066a9),
                        Color(0xcc0066a9),
                        Color(0xff0066a9),
                        ]
                  )
                ),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 120
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo.png', width: 560),
                    const SizedBox(height: 20),
                    buildEmpresa(),
                    const SizedBox(height: 10),
                    buildEmail(),
                    const SizedBox(height: 10),
                    buildPassword(),
                    const SizedBox(height: 20),
                    buildLoginBtn(),
                    const SizedBox(height: 20),
                    Text('Versión $version',
                      style: const TextStyle(
                        color: Colors.white
                      )
                    )
                  ]
                )
              )
              )
            ]
          )
        ),
      ),
    );
  }


}