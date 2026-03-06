class userModel{
  String id ; 
  String name ; 
  String email ; 
  String role ; 

  userModel({required this.id, required this.name, required this.email, required this.role});
  factory userModel.fromJson(Map<String, dynamic> json){
    return userModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
    );
  }
}