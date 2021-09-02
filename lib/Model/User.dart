
class User {

  final String uid;
  final String name;
  final String email;
  final String  account;


  User({this.uid,this.name,this.email,this.account,});
  
   User.fromDS(String id, Map<String, dynamic> data)
      : uid = data['uid'],
        name = data['Name'],
        email = data ['Email'],
        account = data['Account'];

  Map<String, dynamic> toMap() => {

    'uid': uid,
    'name': name,
    'email': email,
    'account':account
  };
}
