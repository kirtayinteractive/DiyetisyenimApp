
class User{
  String id;
  final String name;
  final String adres;
  final String tel;
  final String eposta;

  final String m1;
  final String m2;
  final String m3;
  final String m4;
  final String m5;
  final String m6;
  final String m7;
  final String m8;
  final String m9;
  final String m10;
  final String m11;
  final String m12;
  User({
    this.id='',
    required this.name,
    required String this.eposta,
    required String this.tel,
    required String this.adres,

    required String this.m1,required String this.m2,required String this.m3,required String this.m4,required String this.m5,required String this.m6,required String this.m7,required String this.m8,required String this.m9,required String this.m10,required String this.m11,required String this.m12
});
Map<String,dynamic>toJson()=>{
  'id':id,
  'name':name,
  'eposta':eposta,
  'tel':tel,
  'adres':adres,

  'm1':m1,
  'm2':m2,
  'm3':m3,
  'm4':m4,
  'm5':m5,
  'm6':m6,
  'm7':m7,
  'm8':m8,
  'm9':m9,
  'm10':m10,
  'm11':m11,
  'm12':m12,
};
static User fromJson(Map<String,dynamic>json)=>User(
    id: json['id'],
    name: json['name'],
    eposta: json['eposta'],
    tel: json['tel'],
    adres: json['adres'],
    m1:json['m1'],
    m2: json['m2'],
    m3: json['m3'],
    m4: json['m4'],
    m5: json['m5'],
    m6: json['m6'],
    m7: json['m7'],
    m8: json['m8'],
    m9: json['m9'],
    m10: json['m10'],
    m11: json['m11'],
    m12: json['m12'],
 );
}