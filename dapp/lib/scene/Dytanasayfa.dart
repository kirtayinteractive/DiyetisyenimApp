import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dapp/scene/custom/AnaSayfaIlanDyt.dart';
import 'giris.dart';
import 'navigator.dart';

class DytAnasayfa extends StatefulWidget {
  @override
  _DytAnasayfaState createState() => _DytAnasayfaState();
}



class _DytAnasayfaState extends State<DytAnasayfa> {
  String searchN="";

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateA,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDateA)
      setState(()  {
        selectedDateA = picked;
        incrementCounter();
      });
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context)=> MyHomePage(dytF: dyt,)));

  }
  var collection =FirebaseFirestore.instance.collection(selectedDateA.toLocal().toString().split(' ')[0]);
  late List<Map<String,dynamic>> items;
  bool isloaded=false;
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
      if(selectedDateA.compareTo(DateTime.now())<-1){
        isloaded=false;
      }else{
        items=tempList;
        isloaded=true;}
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.green,
            expandedHeight: 50.0,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text("DiyetisyenimApp", style: TextStyle(fontSize: 20.0)),
            ),
          ),
          SliverToBoxAdapter(
            child:Container(child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (val){
                      setState(() {
                        searchN=val;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Ara...',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                  child:
                  ListTile(
                    title: TextField(
                      onTap: () => _selectDate(context),
                      decoration: InputDecoration(
                          fillColor: Colors.black12,
                          contentPadding: EdgeInsets.symmetric(vertical: 5),
                          hintText: selectedDateA.toLocal().toString().split(' ')[0]+" "+DateFormat.EEEE('tr_TR').format(selectedDateA),
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
                ),
                Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection(selectedDateA.toLocal().toString().split(' ')[0]).snapshots(),
                      builder: (context,snapshots){
                        return (snapshots.connectionState==ConnectionState.waiting)?Center(
                          child: CircularProgressIndicator(),
                        ):isloaded?ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: items.length,
                            itemBuilder: (context,index){
                              if(items[index]["name"].toString().toLowerCase().startsWith(searchN.toLowerCase())){
                                return DytAnaSayfaIlan(
                                  title:items[index]["name"]!=null&&items[index]["name"]!.isNotEmpty ? items[index]["name"]![0]:" ",
                                  name: items[index]["name"] ?? "Not given",
                                  eposta: items[index]["eposta"] ?? "Not given",
                                  tel: items[index]["tel"] ?? "Not given",
                                  adres: items[index]["adres"] ?? "Not given",
                                  mc1: items[index]["m1"] ?? "Not given",
                                  mc2: items[index]["m2"] ?? "Not given",
                                  mc3: items[index]["m3"] ?? "Not given",
                                  mc4: items[index]["m4"] ?? "Not given",
                                  mc5: items[index]["m5"] ?? "Not given",
                                  mc6: items[index]["m6"] ?? "Not given",
                                  mc7: items[index]["m7"] ?? "Not given",
                                  mc8: items[index]["m8"] ?? "Not given",
                                  mc9: items[index]["m9"] ?? "Not given",
                                  mc10: items[index]["m10"] ?? "Not given",
                                  mc11: items[index]["m11"] ?? "Not given",
                                  mc12: items[index]["m12"] ?? "Not given",
                                  diyetisyenimD: items[index]["geposta"] ?? "Not given",
                                  iEposta:items[index]["eposta"]??"Not given",
                                );
                              }


                            }

                        ):const Text("Veri Yok");

                      },

                    )
                  ],
                ),

              ],
            ),),
          ),
        ],
      ),
    );

  }

}
