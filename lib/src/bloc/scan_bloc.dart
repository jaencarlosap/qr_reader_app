import 'dart:async';

import 'package:qrreaderapp/src/bloc/validation.dart';

import 'package:qrreaderapp/src/providers/db_provider.dart';

class ScanBloc with Validators {
  static final ScanBloc _singleton = new ScanBloc._internal();

  factory ScanBloc() {
    return _singleton;
  }

  ScanBloc._internal() {
    getScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream =>
      _scansController.stream.transform(validateGeo);
  Stream<List<ScanModel>> get scansStreamHttp =>
      _scansController.stream.transform(validateHttp);

  dispose() {
    _scansController?.close();
  }

  addScan(ScanModel scan) async {
    await DBProvider.db.newScan(scan);
    getScans();
  }

  getScans() async {
    _scansController.sink.add(await DBProvider.db.getScans());
  }

  deleteScan(int id) async {
    await DBProvider.db.deleteScan(id);
    getScans();
  }

  deleteAllScan() async {
    await DBProvider.db.deleteAll();
    _scansController.sink.add([]);
  }
}
