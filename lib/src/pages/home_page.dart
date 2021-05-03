import 'package:flutter/material.dart';

import 'package:qrreaderapp/src/pages/address_page.dart';
import 'package:qrreaderapp/src/pages/maps_page.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Qr Scanner'),
        actions: [
          IconButton(icon: Icon(Icons.delete_forever), onPressed: () {})
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _bottomNavitagionBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _floatActionButtom(context),
    );
  }

  Widget _callPage(int pageActual) {
    switch (pageActual) {
      case 0:
        return MapsPage();
      case 1:
        return AddressPage();
      default:
        return MapsPage();
    }
  }

  Widget _bottomNavitagionBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
      ],
    );
  }

  Widget _floatActionButtom(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.filter_center_focus_outlined),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: _scanQR,
    );
  }

  _scanQR() async {
    //https://github.com/janper231
    //geo:4.3113515,-74.8105908,14
    String futureString = '';

/*     try {
      await Permission.camera.request();
      futureString = await scanner.scan();
    } catch (e) {
      futureString = e.toString();
    } */
  }
}
