import 'package:flutter/material.dart';

class Futured<T> extends StatelessWidget {
  final Future<T>? future;
  final AsyncWidgetBuilder<T>? waiting;
  final AsyncWidgetBuilder<T>? hasError;
  final AsyncWidgetBuilder<T> hasData;
  final AsyncWidgetBuilder<T>? hasNoData;
  final bool printStatus;

  const Futured({
    Key? key,
    required this.future,
    required this.hasData,
    this.waiting,
    this.hasError,
    this.hasNoData,
    this.printStatus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (printStatus) print(snapshot.connectionState);

        if (snapshot.connectionState == ConnectionState.waiting) {
          if (waiting != null) {
            return waiting!(context, snapshot);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            if (hasError != null) {
              return hasError!(context, snapshot);
            } else {
              print(snapshot.error);
              return const Center(child: Text('Error'));
            }
          } else if (snapshot.hasData) {
            T? data = snapshot.data;

            if (data is List && data.isEmpty) {
              return emptyData(context, snapshot);
            } else {
              return hasData(context, snapshot);
            }
          } else {
            return emptyData(context, snapshot);
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      },
    );
  }

  emptyData(BuildContext context, AsyncSnapshot<T> snapshot) {
    if (hasNoData != null) {
      return hasNoData!(context, snapshot);
    } else {
      return const Text('لا يوجد بيانات');
    }
  }
}
