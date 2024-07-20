import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dapp/scene/services/googlesign.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'giris.dart';


class ProfilDyt extends StatefulWidget {
  @override
  _ProfiDytState createState() => _ProfiDytState();
}

class _ProfiDytState extends State<ProfilDyt> {


  var collection2=FirebaseFirestore.instance.collection('dyt').doc('${FirebaseAuth.instance.currentUser?.email.toString()}dyt');
  var collection =FirebaseFirestore.instance.collection(selectedDateA.toLocal().toString().split(' ')[0]).doc(FirebaseAuth.instance.currentUser?.email.toString());
  var  DytName=FirebaseAuth.instance.currentUser!.displayName;
  void initState(){
    super.initState();
    DytNameCheck();
    getImage();
  }
 Future<void> DytNameCheck()async{
    var data =await collection.get();
    var data2 =await collection2.get();
    if(data2.get('name')==null){
     DytName=FirebaseAuth.instance.currentUser!.displayName.toString();
    }else {
      setState(() {
        DytName = data2.get('name');
        Adkayit.text = data2.get("name");
        Adreskayit.text = data2.get("adres");
        Telkayit.text= data2.get("tel");
        Epostakayit.text = data2.get("eposta");
        mc1.text = data.get("m1");
        mc2.text = data.get("m2");
        mc3.text = data.get("m3");
        mc4.text = data.get("m4");
        mc5.text = data.get("m5");
        mc6.text = data.get("m6");
        mc7.text = data.get("m7");
        mc8.text = data.get("m8");
        mc9.text = data.get("m9");
        mc10.text = data.get("m10");
        mc11.text = data.get("m11");
        mc12.text = data.get("m12");
      });
    }// return items;
  }
  DateTime selectedDate = DateTime.now();
  final Adkayit =TextEditingController();
  final Epostakayit =TextEditingController();
  final Telkayit =TextEditingController();
  final Adreskayit =TextEditingController();
  final mc1=TextEditingController();
  final mc2=TextEditingController();
  final mc3=TextEditingController();
  final mc4=TextEditingController();
  final mc5=TextEditingController();
  final mc6=TextEditingController();
  final mc7=TextEditingController();
  final mc8=TextEditingController();
  final mc9=TextEditingController();
  final mc10=TextEditingController();
  final mc11=TextEditingController();
  final mc12=TextEditingController();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
    //Image? image1;
    String? imageUrl;
  void pickUpload() async{
    final image=await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 100
    );
    Reference ref=FirebaseStorage.instance.ref().child("${FirebaseAuth.instance.currentUser!.email.toString()}.jpg");
    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
     print(value);
     setState(() {
       imageUrl=value;
     });
    } );

  }
  void getImage() async{
    Reference ref=FirebaseStorage.instance.ref().child("${FirebaseAuth.instance.currentUser!.email.toString()}.jpg");
    ref.getDownloadURL().then((value) {
      print(value);
      setState(() {
        imageUrl=value;
      });
    } );
  }

  @override
  Widget build(BuildContext context) {
    var formKeyTakvim=GlobalKey<FormState>();
    var formKeyBilgi=GlobalKey<FormState>();
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.green,
            floating: false,
            pinned: true,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                children: <Widget>[
                  Stack(children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: imageUrl == null || imageUrl!.isEmpty ? Text(
                        DytName!=null&&DytName!.isNotEmpty ? DytName![0] : FirebaseAuth.instance.currentUser!.displayName.toString()[0],
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      ) : null,
                      backgroundImage: imageUrl != null && imageUrl!.isNotEmpty ? NetworkImage(imageUrl!) : null,
                    ),
                    Positioned(child: IconButton(onPressed: pickUpload,icon: Icon(Icons.add_a_photo,color: Colors.transparent,),),

                    )
                  ],
                  alignment: Alignment.center,),
                  
                  SizedBox(width: 10),
                  Text(
                    DytName!=null&&DytName!.isNotEmpty ? DytName!:FirebaseAuth.instance.currentUser!.displayName.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Form(
                  key:formKeyBilgi,
                  child: Container(
                  margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.lightGreen[100],
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: ExpansionTile(
                    iconColor: Colors.green,
                    textColor: Colors.green,
                    initiallyExpanded: true,
                    title: Text('Bilgilerini Düzenle'),
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.person),
                              title: TextFormField(
                                validator: (value){
                                  if(value!.isEmpty||!RegExp(r'^[a-z A-ZğĞüÜşŞiİöÖçÇıI]+$').hasMatch(value!)){
                                    return "Lütfen doğru giriniz";
                                  }else return null;
                                },
                                controller: Adkayit,
                                decoration: InputDecoration(
                                  hintText: 'Adınız',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.email),
                              title: TextFormField(
                                validator: (value){
                                  if(value!.isEmpty||!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value!)){
                                    return "Lütfen doğru giriniz";
                                  }else return null;
                                },
                                controller: Epostakayit,
                                decoration: InputDecoration(
                                  hintText: 'E-posta Adresiniz',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.phone),
                              title: TextFormField(
                                validator: (value){
                                  if(value!.isEmpty||!RegExp(r'^[+]*[(]{0,1}[0,-9]{1,4}[)]{0,1}[-\s./0-9]+$').hasMatch(value!)){
                                    return "Lütfen doğru giriniz";
                                  }else return null;
                                },
                                controller: Telkayit,
                                decoration: InputDecoration(
                                  hintText: 'Telefon Numaranız',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.location_city),
                              title: TextFormField(
                                validator: (value){
                                  if(value!.isEmpty||!RegExp(r'^[a-zA-ZğĞüÜşŞiİöÖçÇıI\s/:\.,\?!]+$').hasMatch(value!)){
                                    return "Lütfen doğru giriniz";
                                  }else return null;
                                },
                                controller: Adreskayit,
                                decoration: InputDecoration(
                                  hintText: 'Adresiniz',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                ElevatedButton(
                                  onPressed:() {
                                    if(formKeyBilgi.currentState!.validate()){
                                    profilDytKayit();}
                                  },
                                  child: Text('Kaydet',style: TextStyle(color: Colors.white),),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: DytNameCheck,
                                  child: Text('İptal Et',style: TextStyle(color: Colors.white),),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),),
                Form(
                  key: formKeyTakvim,
                  child: Container(
                  margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.lightGreen[100],
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: ExpansionTile(
                    iconColor: Colors.green,
                    textColor: Colors.green,
                    initiallyExpanded: true,
                    title: Text('Takvimi Düzenle'),
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child:Container(
                            margin: EdgeInsets.all(10),
                            child:Column(

                              children: <Widget>[
                                Text("Müsait olduğunuz tarihi seçerek randevu alınabilecek saatleri giriniz. Örnek:9.30,10.00",textAlign: TextAlign.center,style: TextStyle(color: Colors.black87),),
                                ListTile(
                                  title: TextField(
                                    onTap: () => _selectDate(context),
                                    decoration: InputDecoration(
                                        fillColor: Colors.black12,
                                        contentPadding: EdgeInsets.symmetric(vertical: 5),
                                        hintText: selectedDate.toLocal().toString().split(' ')[0]+" "+DateFormat.EEEE('tr_TR').format(selectedDate),
                                        filled: true,
                                        prefixIcon: Icon(Icons.calendar_today),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.green)
                                        )
                                    ),
                                    readOnly: true,),

                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: TextFormField(
                                        validator: (value){
                                          if(value!.isEmpty||!RegExp(r'^([0-1]?[0-9]|2[0-3]).[0-5][0-9]$').hasMatch(value!)){
                                            return "Lütfen doğru giriniz";
                                          }else return null;
                                        },
                                        controller: mc1,
                                        decoration: InputDecoration(
                                          hintText: '-',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        validator: (value){
                                          if(value!.isNotEmpty&&!RegExp(r'^([0-1]?[0-9]|2[0-3]).[0-5][0-9]$').hasMatch(value!)){
                                            return "Lütfen doğru giriniz";
                                          }else return null;
                                        },
                                        controller: mc2,
                                        decoration: InputDecoration(
                                          hintText: '-',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        validator: (value){
                                          if(value!.isNotEmpty&&!RegExp(r'^([0-1]?[0-9]|2[0-3]).[0-5][0-9]$').hasMatch(value!)){
                                            return "Lütfen doğru giriniz";
                                          }else return null;
                                        },
                                        controller: mc3,
                                        decoration: InputDecoration(
                                          hintText: '-',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        validator: (value){
                                          if(value!.isNotEmpty&&!RegExp(r'^([0-1]?[0-9]|2[0-3]).[0-5][0-9]$').hasMatch(value!)){
                                            return "Lütfen doğru giriniz";
                                          }else return null;
                                        },
                                        controller: mc4,
                                        decoration: InputDecoration(
                                          hintText: '-',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: TextFormField(
                                        validator: (value){
                                          if(value!.isNotEmpty&&!RegExp(r'^([0-1]?[0-9]|2[0-3]).[0-5][0-9]$').hasMatch(value!)){
                                            return "Lütfen doğru giriniz";
                                          }else return null;
                                        },
                                        controller: mc5,
                                        decoration: InputDecoration(
                                          hintText: '-',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        validator: (value){
                                          if(value!.isNotEmpty&&!RegExp(r'^([0-1]?[0-9]|2[0-3]).[0-5][0-9]$').hasMatch(value!)){
                                            return "Lütfen doğru giriniz";
                                          }else return null;
                                        },
                                        controller: mc6,
                                        decoration: InputDecoration(
                                          hintText: '-',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        validator: (value){
                                          if(value!.isNotEmpty&&!RegExp(r'^([0-1]?[0-9]|2[0-3]).[0-5][0-9]$').hasMatch(value!)){
                                            return "Lütfen doğru giriniz";
                                          }else return null;
                                        },
                                        controller: mc7,
                                        decoration: InputDecoration(
                                          hintText: '-',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        validator: (value){
                                          if(value!.isNotEmpty&&!RegExp(r'^([0-1]?[0-9]|2[0-3]).[0-5][0-9]$').hasMatch(value!)){
                                            return "Lütfen doğru giriniz";
                                          }else return null;
                                        },
                                        controller: mc8,
                                        decoration: InputDecoration(
                                          hintText: '-',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: TextFormField(
                                        validator: (value){
                                          if(value!.isNotEmpty&&!RegExp(r'^([0-1]?[0-9]|2[0-3]).[0-5][0-9]$').hasMatch(value!)){
                                            return "Lütfen doğru giriniz";
                                          }else return null;
                                        },
                                        controller: mc9,
                                        decoration: InputDecoration(
                                          hintText: '-',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        validator: (value){
                                          if(value!.isNotEmpty&&!RegExp(r'^([0-1]?[0-9]|2[0-3]).[0-5][0-9]$').hasMatch(value!)){
                                            return "Lütfen doğru giriniz";
                                          }else return null;
                                        },
                                        controller: mc10,
                                        decoration: InputDecoration(
                                          hintText: '-',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        validator: (value){
                                          if(value!.isNotEmpty&&!RegExp(r'^([0-1]?[0-9]|2[0-3]).[0-5][0-9]$').hasMatch(value!)){
                                            return "Lütfen doğru giriniz";
                                          }else return null;
                                        },
                                        controller: mc11,
                                        decoration: InputDecoration(
                                          hintText: '-',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        validator: (value){
                                          if(value!.isNotEmpty&&!RegExp(r'^([0-1]?[0-9]|2[0-3]).[0-5][0-9]$').hasMatch(value!)){
                                            return "Lütfen doğru giriniz";
                                          }else return null;
                                        },
                                        controller: mc12,
                                        decoration: InputDecoration(
                                          hintText: '-',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    ElevatedButton(
                                      onPressed:() {
                                        if(formKeyTakvim.currentState!.validate()&&formKeyBilgi.currentState!.validate()){
                                        dytTakvimKayit();}
                                      },
                                      child: Text('Kaydet',style: TextStyle(color: Colors.white),),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          )
                      ),
                    ],
                  ),
                ),),

      ElevatedButton(
        onPressed: Logout,
        child: Text('Çıkı Yap',style: TextStyle(color: Colors.white),),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            )))
    ],
            ),
          ),
        ],
      ),
    );
  }
  Future Logout() async {
    FirebaseAuth.instance.signOut();
    final provider =Provider.of<GoogleSignInProvider>(context,listen: false);
    provider.GoogleSignOut().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>GirisPage()),(route) => false));


  }
  dytTakvimKayit(){

     final m1=mc1.text;
     final m2=mc2.text;
     final m3=mc3.text;
     final m4=mc4.text;
     final m5=mc5.text;
     final m6=mc6.text;
     final m7=mc7.text;
     final m8=mc8.text;
     final m9=mc9.text;
     final m10=mc10.text;
     final m11=mc11.text;
     final m12=mc12.text;
     final name =Adkayit.text;
     final eposta=Epostakayit.text;
     final tel=Telkayit.text;
     final adres=Adreskayit.text;
     final geposta=FirebaseAuth.instance.currentUser!.email.toString();

     createDateD(m1:m1,m2:m2,m3:m3,m4:m4,m5:m5,m6:m6,m7:m7,m8:m8,m9:m9,m10:m10,m11:m11,m12:m12,name: name,eposta:eposta,tel:tel,adres:adres,geposta:geposta);
     DytNameCheck();
 }
  profilDytKayit() {

    final name =Adkayit.text;
    final eposta=Epostakayit.text;
    final tel=Telkayit.text;
    final adres=Adreskayit.text;
    final geposta=FirebaseAuth.instance.currentUser!.email.toString();

    createUserD(name: name,eposta:eposta,tel:tel,adres:adres,geposta:geposta );
    DytNameCheck();
 }
  Future createDateD({required String m1,required String m2,required String m3,required String m4,required String m5,required String m6,required String m7,required String m8,required String m9,required String m10,required String m11,required String m12,required String name, required String eposta, required String tel,required String adres,required String geposta}) async {
    final docUser=FirebaseFirestore.instance.collection(selectedDate.toLocal().toString().split(' ')[0]).doc("${FirebaseAuth.instance.currentUser?.email.toString()}dyt");
    final json={
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
      'name':name,
      'eposta':eposta,
      'tel':tel,
      'adres':adres,
      'geposta':geposta
    };
    await docUser.set(json);
  }
  Future createUserD({required String name, required String eposta, required String tel,required String adres,required String geposta}) async {
    final docUser=FirebaseFirestore.instance.collection('dyt').doc('${FirebaseAuth.instance.currentUser?.email.toString()}dyt');
    final json={
      'name':name,
      'eposta':eposta,
      'tel':tel,
      'adres':adres,
      'geposta':geposta
    };
    await docUser.set(json);
  }
}
