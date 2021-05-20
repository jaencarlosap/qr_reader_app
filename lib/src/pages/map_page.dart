import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:qrreaderapp/src/providers/db_provider.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapController map = new MapController();
  String typeMap = 'streets-v11';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas'),
        actions: [
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              map.move(scan.getLatLng(), 15);
            },
          ),
        ],
      ),
      body: _createFlutterMap(scan),
      floatingActionButton: _createButton(context),
    );
  }

  Widget _createFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 18,
      ),
      layers: [
        _createMap(),
        _crateMarkers(scan),
      ],
    );
  }

  LayerOptions _createMap() {
    return TileLayerOptions(
      urlTemplate:
          'https://api.mapbox.com/styles/v1/{username}/{style_id}/tiles/{tilesize}/{z}/{x}/{y}@2x?access_token={access_token}',
      additionalOptions: {
        'access_token':
            'pk.eyJ1IjoiamFucGVyMjMxIiwiYSI6ImNrb3Q4MHlwdzA3bW0ydW83YmNmbHkxdjYifQ.Kux9hn5vvBHAmsuWuKNaXw',
        'style_id': '$typeMap',
        'username': 'mapbox',
        'tilesize': '512',
      },
    );
  }

  LayerOptions _crateMarkers(ScanModel scan) {
    return MarkerLayerOptions(
      markers: [
        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: (context) => Container(
            child: Icon(
              Icons.location_on,
              size: 50,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _createButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        switch (typeMap) {
          case 'streets-v11':
            typeMap = 'outdoors-v11';
            break;
          case 'outdoors-v11':
            typeMap = 'dark-v10';
            break;
          case 'dark-v10':
            typeMap = 'satellite-v9';
            break;
          default:
            typeMap = 'streets-v11';
        }

        setState(() {});
      },
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
