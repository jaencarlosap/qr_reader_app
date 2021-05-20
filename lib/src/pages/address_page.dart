import 'package:flutter/material.dart';

import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/bloc/scan_bloc.dart';

import 'package:qrreaderapp/src/utils/utils.dart';

class AddressPage extends StatelessWidget {
  final scansBloc = new ScanBloc();

  @override
  Widget build(BuildContext context) {
    scansBloc.getScans();

    return StreamBuilder<List<ScanModel>>(
      stream: scansBloc.scansStreamHttp,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final scans = snapshot.data;

        if (scans.length == 0) {
          return Center(child: Text('No hay información'));
        }

        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (context, i) => Dismissible(
            key: UniqueKey(),
            background: Container(color: Colors.red),
            onDismissed: (direction) => scansBloc.deleteScan(scans[i].id),
            child: ListTile(
              onTap: () => launchURL(context, scans[i]),
              leading: Icon(
                Icons.cloud_queue,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(scans[i].value),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.grey,
              ),
            ),
          ),
        );
      },
    );
  }
}
