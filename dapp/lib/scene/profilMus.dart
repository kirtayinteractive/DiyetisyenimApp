import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dapp/scene/giris.dart';
import 'package:dapp/scene/services/googlesign.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class ProfilMus extends StatefulWidget {
  @override
  _ProfilMusState createState() => _ProfilMusState();
}

class _ProfilMusState extends State<ProfilMus> {
  var collection =FirebaseFirestore.instance.collection('kullanici').doc(FirebaseAuth.instance.currentUser?.email.toString());
  var  DytName= FirebaseAuth.instance.currentUser!.displayName;
  void initState(){
    super.initState();
    DytNameCheck();
    getImage();
  }
 Future<void> DytNameCheck()async{
    var data =await collection.get();
    if(data.get('name')==null){
      DytName=FirebaseAuth.instance.currentUser!.displayName.toString();
    }else {
      setState(() {
        DytName = data.get('name');
        mAdkayit.text = data.get("name");
        mBilgikayit.text = data.get("bilgi");
        mAdreskayit.text = data.get("adres");
        mTelkayit.text = data.get("tel");
        mEpostakayit.text = data.get("eposta");
      });

    }
  }
  DateTime selectedDate = DateTime.now();
  final mAdkayit =TextEditingController();
  final mEpostakayit =TextEditingController();
  final mTelkayit =TextEditingController();
  final mAdreskayit =TextEditingController();
  final mBilgikayit =TextEditingController();
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
    var formKey=GlobalKey<FormState>();
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.green, // AppBar arka planı yeşil olarak ayarlandı.
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

                Container(
                  margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.lightGreen[100],
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child:Form(
                    key:formKey,
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
                          shrinkWrap: true, // ListView'ın boyutunu içeriğine göre ayarlar.
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.person),
                              title: TextFormField(
                                validator: (value){
                                  if(value!.isEmpty||!RegExp(r'^[a-z A-ZğĞüÜşŞiİöÖçÇıI]+$').hasMatch(value!)){
                                      return "Lütfen doğru giriniz";
                                  }else return null;
                                },
                                controller: mAdkayit,
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
                                controller: mEpostakayit,
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
                                controller: mTelkayit,
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
                                controller: mAdreskayit,

                                decoration: InputDecoration(
                                  hintText: 'Adresiniz',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),//Boyunuz kilonuz ve hastalıklarınız gibi bilgileri but kutuya giriniz!
                            ListTile(
                              title: TextFormField(
                                controller: mBilgikayit,

                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 100),
                                  hintText: 'Boyunuz kilonuz ve hastalıklarınız gibi bilgileri but kutuya giriniz!',
                                  hintMaxLines: 5,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                ElevatedButton(
                                  onPressed: (){
                                    if(formKey.currentState!.validate()){
                                      profilMusKayit();
                                    }
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
                ElevatedButton(
                  onPressed: Logout,
                  child: Text('Çıkı Yap',style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  profilMusKayit() {

    final name =mAdkayit.text;
    final meposta=mEpostakayit.text;
    final mtel=mTelkayit.text;
    final madres=mAdreskayit.text;
    final mbilgi=mBilgikayit.text;
    createUser(name: name,meposta:meposta,mtel:mtel,madres:madres,mbilgi:mbilgi);
    DytNameCheck();
  }
 Future createUser({required String name, required String meposta, required String mtel,required String madres,required String mbilgi}) async {
    final docUser=FirebaseFirestore.instance.collection('kullanici').doc(FirebaseAuth.instance.currentUser?.email.toString());
    final json={
      'name':name,
      'eposta':meposta,
      'tel':mtel,
      'adres':madres,
      'bilgi':mbilgi,
      'dyt':false
    };
    await docUser.set(json);
  }
 Future Logout() async {
    dyt="";
   FirebaseAuth.instance.signOut();
   final provider =Provider.of<GoogleSignInProvider>(context,listen: false);
   provider.GoogleSignOut().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>GirisPage()),(route) => false));

  }
}
