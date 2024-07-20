
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:intl/intl.dart';
import '../giris.dart';
import 'package:http/http.dart' as http;

class AnaSayfaIlan extends StatefulWidget{

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

  AnaSayfaIlan({required this.title,required this.name,required this.eposta,required this.tel,required this.adres,required this.mc1,required this.mc2,required this.mc3,required this.mc4,required this.mc5,required this.mc6,required this.mc7,required this.mc8,required this.mc9,required this.mc10,required this.mc11,required this.mc12,required this.diyetisyenimD,required this.iEposta});
  @override
  _AnaSayfaIlan createState()=> _AnaSayfaIlan();

}
var indexSaat;
class _AnaSayfaIlan extends State<AnaSayfaIlan> {

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
            //width: double.infinity,// Yüksekliği 300 olarak ayarladık
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
                       //TextButton.icon(onPressed: null, icon: Icon(Icons.phone,color: Colors.black,), label: Text("26326252625",style: TextStyle(color: Colors.black),)),
                     ],),),
                   Flexible(
                     flex: 4,
                     child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [

                      GroupButton(
                         buttonHeight:MediaQuery.of(context).size.height*0.03,
                         buttonWidth: MediaQuery.of(context).size.width*0.20,
                         selectedTextStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.028,color: Colors.white),
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
                         onSelected:(index, bool isSelected)=>indexSaat=index//print("$index button is ${isSelected?'selected':'un selected'}"),
                     ),

                      ElevatedButton(
                       onPressed: RandevuButtonClick,
                       child: Text("Randevu Al",style: TextStyle(fontSize: 15,color: Colors.white),),
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.green,
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(20),
                         ),
                       ),
                     ),

                   ],),),
                 ],

               ),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            // İçi boş
          ),
          // Diğer Container widget'ları buraya eklenebilir
        ],
      ),
    );
  }
  var dytD;

  var dytTel;

  var dytM;

  var musEposta;

  void initState(){
    super.initState();
    incrementCounter();
    incrementCounter2();
    getImage();
  }
  var collection =FirebaseFirestore.instance.collection("kullanici").doc(FirebaseAuth.instance.currentUser?.email.toString());
  var musTel;
  incrementCounter()async{
    var data =await collection.get();
    setState(() {
      musEposta=data.get("eposta").toString();
      musTel=data.get("tel");
      dytM=data.get("bilgi").toString();
      dytD=data.get("name").toString();

    });
  }
  incrementCounter2()async{
    var collection2 =FirebaseFirestore.instance.collection(selectedDateA.toLocal().toString().split(' ')[0]).doc(widget.diyetisyenimD.toString());
    var data =await collection2.get();
    setState(() {
      dytTel=data.get("tel").toString();

    });
  }
  Future<void> RandevuButtonClick() async{
    showDialog(
        context: context,builder: (context)=>AlertDialog(title:const Text("Uyarı!"),content:const Text("Randevu almadan önce profil bilgilerinizin tam olduğundan emin olun!"),
      actions: [
        TextButton(onPressed:(){ Navigator.of(context).pop();}, child: Text("İptal")),
        TextButton(onPressed:(){Navigator.of(context).pop(); RandevuAl();}, child: Text("Randevu Al"))
      ],));
  }
  Future<void> RandevuAl() async {

    List mc=[widget.mc1,
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
      widget.mc12];
    var indexSaat1=mc[indexSaat];
    var collectionrndv=FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.email.toString());
    var data=await collectionrndv.get();
    if(indexSaat1.toString()=="0.00"||indexSaat1.toString()=="00.00"||indexSaat1.toString()=="Dolu"||indexSaat1.toString().isEmpty){
      showDialog(
          context: context,builder: (context)=>AlertDialog(title:const Text("Uyarı!"),content:const Text("Seçtiğiniz saat randevu için uygun değil!"),)); //title:const Text("Uyarı!"),content:const Text("Randevu almadan önce bilgilerinizi doldurun!"),);
    }
    else if(data.docs.isNotEmpty){
      showDialog(
          context: context,builder: (context)=>AlertDialog(title:const Text("Uyarı!"),content:const Text("Mevcut bir randevunuz varken yeni bir randevu alamazsınız!"),)); //title:const Text("Uyarı!"),content:const Text("Randevu almadan önce bilgilerinizi doldurun!"),);
    } else{
    incrementCounter();
    incrementCounter2();
    if(dytD==null){
       showDialog(
           context: context,builder: (context)=>AlertDialog(title:const Text("Uyarı!"),content:const Text("Randevu almadan önce profil bilgilerinizi doldurun!"),)); //title:const Text("Uyarı!"),content:const Text("Randevu almadan önce bilgilerinizi doldurun!"),);
    }
    else{


    final date =selectedDateA.toLocal().toString().split(' ')[0];
    final eposta=widget.eposta;
    final tel=widget.tel;
    final saat=indexSaat1.toString();
    final diyetisyenim=widget.diyetisyenimD;
    final dname=widget.name;
    final mname=dytD.toString();
    final bilgi=dytM.toString();
    final iletisim=musTel.toString();
    final musteriEposta=musEposta.toString();
    final musteri1=FirebaseAuth.instance.currentUser!.email.toString();

    createDyt(diyetisyenim: diyetisyenim);
    createRandevu( date: date,eposta:eposta,tel:tel,saat:saat,Dname: dname,Mname: mname,bilgi:bilgi,iletisim: iletisim,musteriEposta: musteriEposta,musteri: musteri1,);
    createRandevuM(diyetisyenim: diyetisyenim, date: date, eposta: eposta, tel: tel, saat: saat, Dname: dname, Mname: mname, bilgi: bilgi,iletisim: iletisim,musteriEposta: musteriEposta);
    sendEmail(nameE: mname, gunE: DateFormat.EEEE('tr_TR').format(selectedDateA), saatE: saat, telE: musTel, bilgiE: bilgi, dateE: date , emailE: musteriEposta, subject: "Yeni Randevu");
    showDialog(
        context: context,builder: (context)=>AlertDialog(title:const Text("Başarılı"),content:const Text("Randevunuz başarılı bir şekilde alındı"),));
       rndvfree();
    }}
  }
  Future<void> rndvfree() async{
   return FirebaseFirestore.instance.collection(selectedDateA.toLocal().toString().split(' ')[0]).doc('${widget.diyetisyenimD}dyt').update(
        {'m${(indexSaat+1).toString()}':"Dolu"});
  }
  Future createRandevuM({required String diyetisyenim, required String date, required String eposta, required String tel,required String saat,required String Dname,required String Mname,required String bilgi,required String iletisim,required String musteriEposta}) async {

    final docUser=FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.email.toString()).doc(widget.diyetisyenimD);
    final json={
      'date':date,
      'eposta':eposta,
      'tel':tel,
      'saat':saat,
      'Dname':Dname,
      'Mname':Mname,
      'bilgi':bilgi,
      'iletisim':iletisim,
      'musteriEposta':musteriEposta,
      'diyetisyenim':diyetisyenim
    };
    await docUser.set(json);
  }
  Future createRandevu({ required String date, required String eposta, required String tel,required String saat,required String Dname,required String Mname,required String bilgi,required String iletisim,required String musteriEposta,required String musteri,}) async {
    final docUser=FirebaseFirestore.instance.collection(widget.diyetisyenimD).doc(FirebaseAuth.instance.currentUser?.email.toString());
    final json={
      'date':date,
      'eposta':eposta,
      'tel':tel,
      'saat':saat,
      'Dname':Dname,
      'Mname':Mname,
      'bilgi':bilgi,
      'iletisim':iletisim,
      'musteriEposta':musteriEposta,
      'musteri':musteri,

    };
    await docUser.set(json);
  }
  Future<void> createDyt({required String diyetisyenim})async{
    return FirebaseFirestore.instance.collection("kullanici").doc(FirebaseAuth.instance.currentUser?.email.toString()).update(
        {'diyetisyenim':diyetisyenim});

  }
  Future sendEmail({
    required String nameE,
    required String gunE,
    required String saatE,
    required String telE,
    required String bilgiE,
    required String dateE,
    required String emailE,
    required String subject,
  }) async{

    final serviceId='service_ifaoesi';
    final templateId='template_u95raw7';
    final userId='KXn98uXUfqeRUjjVu';

    final url=Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response=await http.post(
        url,
      headers: {
          'origin':'http://localhost',
        'Content-Type':'application/json',
      },
      body: json.encode({
        'service_id':serviceId,
        'user_id':userId,
        'template_id':templateId,
        'template_params':{
          'user_name':nameE,
          'user_date':dateE,
          'user_gun':gunE,
          'user_saat':saatE,
          'user_bilgi':bilgiE,
          'user_iletisim':telE,
          'user_email':emailE,
          'to_email':widget.eposta,
          'user_subject':subject,
        },
      })
    );
    print(response.body);

}
}
