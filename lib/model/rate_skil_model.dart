// ignore_for_file: public_member_api_docs, sort_constructors_first
class RateSkilModel {
  double pace;
  double shooting;
  double passing;
  double dribbling;
  double defending;
  double physical;
  double overAll;

  RateSkilModel({
    required this.pace,
    required this.shooting,
    required this.passing,
    required this.dribbling,
    required this.defending,
    required this.physical,
    required this.overAll,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pace': pace,
      'shooting': shooting,
      'passing': passing,
      'dribbling': dribbling,
      'defending': defending,
      'physical': physical,
      'overAll': overAll,
    };
  }

  factory RateSkilModel.fromMap(Map<String, dynamic> map) {
    return RateSkilModel(
      pace: double.parse(map['pace'].toString()),
      shooting: double.parse(map['shooting'].toString()),
      passing: double.parse(map['passing'].toString()),
      dribbling: double.parse(map['dribbling'].toString()),
      defending: double.parse(map['defending'].toString()),
      physical: double.parse(map['physical'].toString()),
      overAll: double.parse(map['overAll'].toString()),
    );
  }
}

/* 

  Pace 
Shooting


Passing
Dribbling
Defending
Physical

 */
