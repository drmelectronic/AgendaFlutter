

import 'package:agenda/entity/empresa.dart';
import 'package:agenda/models/login.dart';
import 'package:agenda/screens/agenda_screen.dart';
import 'package:agenda/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.empresas}) : super(key: key);

  final List<Empresa> empresas;

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen>{
  List<String> empresas =  [];

  LoginRequestModel loginRequestModel = LoginRequestModel(password: '', username: '');
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String empresa = 'urbanito';
  String username = '';
  String password = '';
  bool hidePassword = true;
  var version = '1.0.9';

  double height = 50;

  final TextEditingController _usernameTextController = TextEditingController(text: '');
  final TextEditingController _passwordTextController = TextEditingController(text: '');

  List<DropdownMenuItem<String>> empresasItems = [];

  @override
  initState() {
    empresasItems = widget.empresas.map<DropdownMenuItem<String>>(
            (Empresa value) => DropdownMenuItem<String>(
            value: value.codigo, child: Text(value.nombre))
    ).toList(growable: false);
    empresas = widget.empresas.map<String>((Empresa value) => value.codigo).toList(growable: false);
    loadSharedPreferences();
    super.initState();
  }


  Future clearSharedPreferences() async {
    SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString('token', '');
      prefs.setString('empresa', 'urbanito');
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
      empresa = 'urbanito';
    });
  }

  Future loadSharedPreferences () async {
    SharedPreferences prefs = await _prefs;
    setState(() {
      empresa = prefs.getString('empresa') ?? '';
      if (!empresas.contains(empresa)) {
        empresa = 'urbanito';
      }
      username = prefs.getString('username') ?? '';
      password = prefs.getString('password') ?? '';
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
            MaterialPageRoute(builder: (context) => AgendaScreen(empresas: widget.empresas)));
      }).catchError((error) {
        final snackBar = SnackBar(content: Text(error.message));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    });
  }

  Widget buildEmpresa(List<Empresa> empresas) {
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
                  items: empresasItems,
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
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical:14)
              )
          ),
        ),
        const SizedBox(width: 10),
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
                  backgroundColor: Colors.red,
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
                    buildEmpresa(widget.empresas),
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