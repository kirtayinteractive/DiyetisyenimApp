import 'package:dapp/scene/giris.dart';
import 'package:dapp/scene/navigator.dart';
import 'package:dapp/scene/services/googlesign.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
class MyStatefulWidget extends StatefulWidget {
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  late WebViewController _controller;

  @override
  void initState(){
    super.initState();
    _controller=WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted)..loadRequest(Uri.parse("https://www.turkiye.gov.tr/yuksekogretim-mezun-belgesi-sorgulama"));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Doğrulama',style: TextStyle(color: Colors.white),),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: WebViewWidget(controller: _controller),
      floatingActionButton: FloatingActionButton.extended(onPressed:(){
        Dogrulama();
        DogrulamaAdmin();

      },label: Text("Sorgula",style: TextStyle(color: Colors.white),),backgroundColor: Colors.blue,),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.green,
    );
  }

  void Dogrulama() {
    _controller.runJavaScriptReturningResult(
        " document.querySelector('#resultTable > tbody > tr > td:nth-child(1)').innerHTML;"
    ).then((result) async {
      var sorgu = result;
      print(sorgu);
     await Future.delayed(Duration(seconds: 1));
      if(sorgu.toString().contains("DİYET")){

        print("Doğrulandı");

        final provider =Provider.of<GoogleSignInProvider>(context,listen: false);
        provider.googleLogin().then((value) =>Navigator.push(context, MaterialPageRoute(builder: (context)=> MyHomePage(dytF: dyt,))));
        dyt="true";
      }else {
        print("Doğrulanamadı");
      }

    });
  }
  void DogrulamaAdmin() {
    _controller.runJavaScriptReturningResult(
        " document.querySelector('#loginForm > fieldset > div.form-row.required > div > button').outerHTML;"
    ).then((result) async {
      var sorgu = result;
      print(sorgu);
      await Future.delayed(Duration(seconds: 1));
      if(sorgu.toString().contains("btn-action hide-tck view")){

        print("Doğrulandı");

        final provider =Provider.of<GoogleSignInProvider>(context,listen: false);
        provider.googleLogin().then((value) =>Navigator.push(context, MaterialPageRoute(builder: (context)=> MyHomePage(dytF: dyt,))));
        dyt="true";
      }else {
        print("Doğrulanamadı");
      }

    });
  }


}