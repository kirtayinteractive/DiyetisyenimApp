import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dapp/scene/Dytanasayfa.dart';
import 'package:dapp/scene/RandevuMus.dart';
import 'package:dapp/scene/anaSayfa.dart';
import 'package:dapp/scene/profilDyt.dart';
import 'package:dapp/scene/profilMus.dart';
import 'package:dapp/scene/randevuDyt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';




class MyHomePage extends StatefulWidget {
 final String dytF;
 MyHomePage({required this.dytF});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  void initState() {
    super.initState();
    onTabTapped(0);
    if(widget.dytF=="true"){
      dytS();
    }else{
      dytMusteri();
    }

   // getData();
  }
  dytS() async {
    final docUser=FirebaseFirestore.instance.collection('kullanici').doc(FirebaseAuth.instance.currentUser?.email.toString());
    final json={
      'dyt':widget.dytF
    };
    await docUser.set(json);

  }
  Future<void> dytMusteri() async {
    return FirebaseFirestore.instance.collection('kullanici').doc(FirebaseAuth.instance.currentUser?.email.toString()).update(
        {'dyt':widget.dytF});

  }
  int _currentIndex = 0;

  final List<Widget> _children = [

    Anasayfa(),
    RandevuMus(),
    ProfilMus(),
  ];

  void onTabTapped(int index) {
    setState(() {
      if(widget.dytF=="true"){
        _children[0]=DytAnasayfa();
        _children[1]=RandevuDyt();
        _children[2]=ProfilDyt();
      }
      else{
        _children[0]=Anasayfa();
        _children[1]=RandevuMus();
        _children[2]=ProfilMus();

      }
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Randevular',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          )
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Ana Sayfa'),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Randevular'),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profil'),
    );
  }
}
