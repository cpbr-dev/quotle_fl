import 'dart:async';
import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  late final StreamSubscription<void> _loadDataSubscription;

  Future<void> _loadData() async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacementNamed(context, '/categories');
  }

  @override
  void initState() {
    super.initState();
    _loadDataSubscription = _loadData().asStream().listen(null);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _loadDataSubscription.cancel();
        return true;
      },
      child: Scaffold(
        body: Center(
          child: Text('Loading...'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loadDataSubscription.cancel();
    super.dispose();
  }
}
