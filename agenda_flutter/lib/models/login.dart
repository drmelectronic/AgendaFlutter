class LoginResponseModel {
  final String token;
  final String empresa;
  
  LoginResponseModel({required this.token, required this.empresa});
  
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(token: json["token"], empresa: json["empresa"]);
  }
}

class LoginRequestModel {
  String username;
  String password;

  LoginRequestModel({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'username': username.trim(),
      'password': password.trim()
    };

    return map;
  }

}