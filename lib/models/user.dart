class User{

  final String uid;
  final String firstName;
  final String lastName;
  final String address;
  final String phoneNumber;
  final String disease;
  final String email;
  final int userType;
  final List requests;
  final List friends;
  final List sentRequests;
  User({this.uid, this.disease,this.address,this.phoneNumber,this.email,this.firstName,this.lastName, this.userType, this.requests,this.friends,this.sentRequests});

}