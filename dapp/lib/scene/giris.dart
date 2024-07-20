import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dapp/scene/navigator.dart';
import 'package:dapp/scene/services/googlesign.dart';
import 'package:dapp/scene/webView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class GirisPage extends StatefulWidget {
  @override
  _GirisPageState createState() => _GirisPageState();
}
String dyt="";
DateTime selectedDateA = DateTime.now();
class _GirisPageState extends State<GirisPage> {


  void initState(){
    super.initState();
    incrementCounter();

  }
  var collection =FirebaseFirestore.instance.collection("kullanici").doc(FirebaseAuth.instance.currentUser?.email.toString());
  var dytV;
  incrementCounter()async{
    var data =await collection.get();
    setState(() {
      dytV=data.get("dyt").toString();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){

          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);}
          else if(snapshot.hasData&&dytV.toString()=="true"){
            dyt="true";
            return MyHomePage(dytF: dyt,);
          }
          else if(snapshot.hasData&&dytV.toString()=="false"){
            dyt="false";
            return MyHomePage(dytF: dyt,);
          }
          else if(snapshot.hasError){
            return Center(child: Text("Bir şeyler yanlış gitti!"),);
          }
          else{
            print(dytV);
          return  CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.green,
                  expandedHeight: 85.0,
                  floating: false,
                  pinned: true,
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  centerTitle: true,
                  title: Text(
                    "DiyetisyenimApp",
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.white
                    ),
                  ),
                ),
                SliverFillRemaining(
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Column(children: [
                        SizedBox(height: 20,),
                        Image.asset('images/dappLogo.png',scale: 6,),
                        SizedBox(height: 15,),
                        Text(
                          "Sağlıklı Yaşamın Anahtarı, Bir Tıklama Uzağınızda!",
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],),

                      SizedBox(height: 60.0),
                      Container(
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: MusteriGiris,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                minimumSize: Size(200, 50),
                              ),
                              child: Text(
                                "Kullanıcı Girişi",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            ElevatedButton(
                              onPressed: DytGiris,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                minimumSize: Size(200, 50),
                              ),
                              child: Text(
                                "Diyetisyen Girişi",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            );
          }

        },
      )
    );
  }

  void MusteriGiris(){

    final provider =Provider.of<GoogleSignInProvider>(context,listen: false);
    dyt="false";
    provider.googleLogin().then((value) => Navigator.push(context, MaterialPageRoute(builder: (context)=> MyHomePage(dytF: dyt,))));

  }
  void DytGiris(){
    showDialog(
        context: context,builder: (context)=>AlertDialog(title:const Text("Doğrulama!"),content:const Text("E-devlet girişinizi yaptıktan sonra sorgula butonuna basarak doğrulamanızı gerçekleştiriniz!"),)).then((value) =>
        Navigator.push(context, MaterialPageRoute(builder: (context)=> MyStatefulWidget())));
  }

}
