
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final date;
  final eposta;
  final tel;
  final saat;
  final diyetisyenim;
  final dname;
  final mname;
  final bilgi;
  final mustel;
  final museposta;
  final musteri;

  CustomExpansionTile(
      {required this.musteri, required this.bilgi, required this.title, required this.date, required this.tel, required this.eposta, required this.saat, required this.diyetisyenim, required this.dname, required this.mname, required this.mustel, required this.museposta}); // @required'i required olarak değiştirdik
  @override
  _customExpansion createState()=>_customExpansion();
}
class _customExpansion extends State<CustomExpansionTile> {
  void initState(){
    super.initState();
    getImage();
  }
  String? imageUrl;
  void getImage() async{
    Reference ref=FirebaseStorage.instance.ref().child("${widget.musteri.toString()}.jpg");
    ref.getDownloadURL().then((value) {
      print(value);
      setState(() {
        imageUrl=value;
      });


    } );
  }
  @override
  Widget build(BuildContext context) {


    String datetime=widget.date.toString()+" 00:00:01";
    String now=DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.parse(datetime));
    var day=DateFormat.EEEE('tr_TR').format(DateTime.parse(now));
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.lightGreen[100],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ExpansionTile(
        iconColor: Colors.green,
        textColor: Colors.green,
        initiallyExpanded: true,
        title: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              child:imageUrl == null || imageUrl!.isEmpty ?Text(widget.title[0],
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ):null,
              backgroundImage: imageUrl != null &&imageUrl!.isNotEmpty ? NetworkImage(imageUrl!) : null,
            ),
            SizedBox(width: 10.0),
            Text(widget.mname),
          ],
        ),
        children: <Widget>[
          Container(
            height: 300.0, // Yüksekliği 300 olarak ayarladık
            margin: EdgeInsets.all(10.0),
            child: Column(
              children: [
            ExpansionTile(
            title: Row(
            children: <Widget>[
            SizedBox(width: 10.0),
            Text('Tarih'),
            ],
          ), children: [
            Text(widget.date),
              Text(day.toString()),
              Text("Saat:${widget.saat}"),
              SizedBox(width: 10.0),
            ],),
                ExpansionTile(
                  title: Row(
                    children: <Widget>[
                      SizedBox(width: 10.0),
                      Text('Bilgilendirme'),
                    ],
                  ), children: [
                  Text(widget.bilgi),
                  SizedBox(width: 10.0),
                ],),
                ExpansionTile(
                  title: Row(
                    children: <Widget>[
                      SizedBox(width: 10.0),
                      Text('İletişim'),
                    ],
                  ), children: [
                  Text(widget.mustel),
                  SizedBox(width: 10.0),
                  Text(widget.museposta),
                  SizedBox(width: 10.0),
                ],)
                
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
}