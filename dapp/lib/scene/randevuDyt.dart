
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'custom/customRandevuDyt.dart';

class RandevuDyt extends StatefulWidget {
  @override
  _RandevuDytState createState() => _RandevuDytState();
}

class _RandevuDytState extends State<RandevuDyt> {
  bool isloaded=false;
  var collection =FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.email.toString());
  late List<Map<String,dynamic>> items;
  void initState(){
    super.initState();
    incrementCounter();
  }
  incrementCounter()async{
    List<Map<String,dynamic>> tempList=[];
    var data =await collection.get();

    data.docs.forEach((element) {
      tempList.add(element.data());
    });
    setState(() {
      items=tempList;
      isloaded=true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.green,
            automaticallyImplyLeading: false,
            expandedHeight: 50.0,
            floating: false,
            pinned: true,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 20.0, bottom: 20.0),
              title: Text(
                "Randevularınız",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                ),
              ),

            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
            isloaded?ListView.builder(
            shrinkWrap: true,
                physics: ScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context,index){
              String datetime=items[index]["date"].toString()+" 00:00:01";
              DateTime dt1=DateTime.parse(datetime);
              if(dt1.compareTo(DateTime.now())<-1){
              }else {
                return CustomExpansionTile(bilgi: items[index]["bilgi"],
                  title: items[index]["Mname"]
                      .toString()
                      .characters
                      .first,
                  date: items[index]["date"],
                  tel: items[index]["tel"],
                  eposta: items[index]["eposta"],
                  saat: items[index]["saat"],
                  diyetisyenim: items[index]["diyetisyenim"],
                  dname: items[index]["Dname"],
                  mname: items[index]["Mname"],
                  mustel: items[index]["iletisim"],
                  museposta: items[index]["musteriEposta"],
                  musteri: items[index]["musteri"],);
              }}):const Text("Veri Yok"),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
