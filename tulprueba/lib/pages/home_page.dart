
import 'package:flutter/material.dart';
import 'package:tulprueba/blocs/firebase_bloc.dart';
import 'package:tulprueba/utils/utils.dart';

class HomePage extends StatefulWidget {
  HomePage({this.title});
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  String _idCart;

@override
  void initState() {
    super.initState();
    _getIdDevice();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: StreamBuilder(
          stream: bloc.getProductsStream(),
          builder: (context, snapshot){
            if (snapshot.hasData) {
              return buildList(snapshot, context);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return new Text("Hubo un error inesperado");
            }
          },
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _openCart();
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }

  Widget buildList(AsyncSnapshot<dynamic> snapshot, BuildContext context) {
    var products = snapshot.data.documents;
    List<Widget> prodWidget = [];
    for (var product in products) {
      prodWidget.add(_card(product, context));
    }

    return ListView(
      children: prodWidget,
    );
  }

  Widget _card(dynamic snapshot, BuildContext context) {

  //var prod = snapshot.data.documents;

    return Card(
        elevation: 10,
        margin: EdgeInsets.all(10),
        child:
      Row(
        children: [
          SizedBox(height: 20, width: 10),
          Container(
            height: 50.0,
            width: 50.0,
            margin: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0, bottom: 5.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage('https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg')
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              shape: BoxShape.rectangle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15.0,
                  offset: Offset(0.0, 7.0)
                )
              ]
            ),
          ),
          SizedBox(width: 20),
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                snapshot.data['nombre'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                snapshot.data['descripcion'],
              ),
              RaisedButton(
                color: Colors.yellow,
                onPressed: () {
                  bloc.saveProdCart(_idCart,snapshot.data['id'], { //snapshot.data['id']
                    'cart_id' : _idCart,
                    'product_id' : snapshot.data['id'],
                    'quantity' : 1,
                    'nombre' : snapshot.data['nombre'],
                    'descripcion' : snapshot.data['descripcion'],
                  });

                  Scaffold.of(context).showSnackBar(SnackBar(content: Text('Producto agregado al carrito')));
                },
                child: Text('Agregar'),
              ),
              SizedBox(height: 10),
            ],
          )
        ],
      )
      );
  }

  _openCart() {
    //final products = await bloc.getProducts1();
    //final products = bloc.getProductsStream();

    /*for(var product in products.documents){
      print('data:  ${product.data}');
    }*/

    /*await for (var  snapshot in bloc.getProductsStream()){
      for (var product in snapshot.documents){
        print(product.data);
      }
    }*/

    bloc.createCart(_idCart, {
      'id' : _idCart,
      'status' : 'pending'
    });

    Navigator.pushNamed(
        context,
        'items_cart',
        arguments: <String, String>{
          'cart': _idCart
        });

  }

  _getIdDevice() async {
    _idCart = await util.getId();
  }
}