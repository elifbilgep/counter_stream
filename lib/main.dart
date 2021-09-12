import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stream Ile Counter',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  // Statefull widget kullanmamızdaki tek amaç kullanımı tamamlandıktan sonra stream'i kapatmak dispose metodunu çağırabilmek
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;
  final StreamController<int> _streamController = StreamController<
      int>(); // akışı kontrol edebileceğimiz bir controller tanımlıyoruz ve akıştaki veri türünün integer olduğunu söylüyoruz

  @override
  void dispose() {
    _streamController.close(); //kapatmayı unutmmamalıyız
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stream Ile Counter')),
      body: Center(
        child: StreamBuilder<int>(
            //Stream'i dinleyerek akıştan çıkan her yeni veriyi Text wigetını güncelleyerek yansıtıyoruz.
            stream: _streamController
                .stream, //StreamController ile stream'e ulaşıyoruz
            initialData: _counter,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              //builder içerisindeki snapshot parametresiyle akışımızdan çıka son verinin değerini Text widgetında yansıtıyoruz.
              return Text('Sayaç: ${snapshot.data}');
            }),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _streamController.sink.add(
              ++_counter); //FloatingActionButton'a bastığımızda counter değerinin bir artmış olarak sink sayesinde akışa yoluyoruz. 
              //Stram'e yeni bir veri girişi akışı dinleyen StreamBuilder'ın widgetı yeni değeriyle beraber tekrar build etmesini sağlıyor.
        },
      ),
    );
  }
}