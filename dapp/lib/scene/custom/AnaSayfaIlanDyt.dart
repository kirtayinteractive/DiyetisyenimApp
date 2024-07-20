
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

import '../giris.dart';

class DytAnaSayfaIlan extends StatefulWidget{

  final String title;
  final String name;
  final String eposta;
  final String tel;
  final String adres;
  final String mc1;
  final String mc2;
  final String mc3;
  final String mc4;
  final String mc5;
  final String mc6;
  final String mc7;
  final String mc8;
  final String mc9;
  final String mc10;
  final String mc11;
  final String mc12;
  final String diyetisyenimD;
  final String iEposta;

  DytAnaSayfaIlan({required this.title,required this.name,required this.eposta,required this.tel,required this.adres,required this.mc1,required this.mc2,required this.mc3,required this.mc4,required this.mc5,required this.mc6,required this.mc7,required this.mc8,required this.mc9,required this.mc10,required this.mc11,required this.mc12,required this.diyetisyenimD,required this.iEposta});
  @override
  _DytAnaSayfaIlan createState()=> _DytAnaSayfaIlan();

}
String? indexSaat;
class _DytAnaSayfaIlan extends State<DytAnaSayfaIlan> {
  void initState(){
    super.initState();
    getImage();
  }
  String? imageUrl;
  void getImage() async{
    Reference ref=FirebaseStorage.instance.ref().child("${widget.diyetisyenimD}.jpg");
    ref.getDownloadURL().then((value) {
      print(value);
      setState(() {
        imageUrl=value;
      });
    } );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.lightGreen[100],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ExpansionTile(
        iconColor: Colors.green,
        textColor: Colors.green,
        title: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              child: imageUrl == null || imageUrl!.isEmpty ?Text(widget.title[0],
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ):null,
              backgroundImage:imageUrl != null && imageUrl!.isNotEmpty ? NetworkImage(imageUrl!) : null,
            ),
            SizedBox(width: 10.0),
            Text(widget.name),
          ],
        ),
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height*0.35,
            margin: EdgeInsets.all(MediaQuery.of(context).size.width*0.05),
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton.icon(onPressed: null, icon: Icon(Icons.mail,color: Colors.black,), label: Text(widget.eposta,style: TextStyle(color: Colors.black),)),
                      TextButton.icon(onPressed: null, icon: Icon(Icons.phone,color: Colors.black,), label: Text(widget.tel,style: TextStyle(color: Colors.black),)),
                      TextButton.icon(onPressed: null, icon: Icon(Icons.location_city,color: Colors.black,), label: Text(widget.adres,style: TextStyle(color: Colors.black),)),
                    ],),),
                Flexible(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      GroupButton(
                          buttonHeight:MediaQuery.of(context).size.height*0.03,
                          buttonWidth: MediaQuery.of(context).size.width*0.20,
                          selectedTextStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.028,color:Colors.white),
                          unselectedTextStyle: TextStyle(fontSize:  MediaQuery.of(context).size.width*0.028,color: Colors.black),
                          direction: Axis.horizontal,
                          borderRadius: BorderRadius.circular(25),
                          mainGroupAlignment: MainGroupAlignment.center,
                          crossGroupAlignment: CrossGroupAlignment.center,
                          groupRunAlignment: GroupRunAlignment.spaceEvenly,
                          buttons: [
                            widget.mc1,
                            widget.mc2,
                            widget.mc3,
                            widget.mc4,
                            widget.mc5,
                            widget.mc6,
                            widget.mc7,
                            widget.mc8,
                            widget.mc9,
                            widget.mc10,
                            widget.mc11,
                            widget.mc12
                          ],
                          isRadio: true,
                          onSelected:(index, bool isSelected)=>indexSaat=index.toString()//print("$index button is ${isSelected?'selected':'un selected'}"),
                      ),



                    ],),),
              ],

            ),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ],
      ),
    );
  }
  String? dytD;
  getData() async {
    final fUser=await FirebaseAuth.instance.currentUser!;
    if(fUser!=null){
      await FirebaseFirestore.instance.collection("dyt").doc(widget.diyetisyenimD).get().then((ds){dytD=ds.data()?['name'].toString();});
    }

  }
  String? dytM;
  getDataM() async {
    final fUser=await FirebaseAuth.instance.currentUser!;
    if(fUser!=null){
      await FirebaseFirestore.instance.collection("kullanici").doc(fUser.email.toString()).get().then((ds){dytM=ds.data()?['bilgi'].toString();});
    }

  }
  void RandevuAl() {
    getData();
    getDataM();
    final date =selectedDateA.toLocal().toString().split(' ')[0];
    final eposta=widget.eposta;
    final tel=widget.tel;
    final saat=indexSaat.toString();
    final diyetisyenim=widget.diyetisyenimD;
    final dname=widget.name;
    final mname=dytD.toString();
    final bilgi=dytM.toString();
    createDyt(diyetisyenim: diyetisyenim);
    createRandevu(date: date,eposta:eposta,tel:tel,saat:saat,Dname: dname,Mname: mname,bilgi:bilgi);
    createRandevuM(date: date, eposta: eposta, tel: tel, saat: saat, Dname: dname, Mname: mname, bilgi: bilgi);
  }
  Future createRandevuM({required String date, required String eposta, required String tel,required String saat,required String Dname,required String Mname,required String bilgi}) async {
    final docUser=FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.email.toString()).doc(widget.eposta);
    final json={
      'date':date,
      'eposta':eposta,
      'tel':tel,
      'saat':saat,
      'Dname':Dname,
      'Mname':Mname,
      'bilgi':bilgi
    };
    await docUser.set(json);
  }
  Future createRandevu({required String date, required String eposta, required String tel,required String saat,required String Dname,required String Mname,required String bilgi}) async {
    final docUser=FirebaseFirestore.instance.collection(widget.eposta).doc(FirebaseAuth.instance.currentUser?.email.toString());
    final json={
      'date':date,
      'eposta':eposta,
      'tel':tel,
      'saat':saat,
      'Dname':Dname,
      'Mname':Mname,
      'bilgi':bilgi
    };
    await docUser.set(json);
  }
  Future createDyt({required String diyetisyenim})async{
    final docUser=FirebaseFirestore.instance.collection("kullanici").doc(FirebaseAuth.instance.currentUser?.email.toString());
    final json={
      'diyetisyenim':diyetisyenim
    };
    await docUser.set(json);
  }
}
