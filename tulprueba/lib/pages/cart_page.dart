

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tulprueba/blocs/firebase_bloc.dart';

class CartPage extends StatefulWidget {

  @override
  _MyCartPage createState() => _MyCartPage();

}

class _MyCartPage extends State<CartPage> {

  String _idCart;
  //int _count = 1;

  @override
  Widget build(BuildContext context) {

    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if(arguments != null){
      print('info: ${arguments['cart']}');
      this._idCart = arguments['cart'];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito'),
      ),
      body: Container(
          child: StreamBuilder(
            stream: bloc.getProductsCartsStream(_idCart),
            builder: (context, snapshot){
              if (snapshot.hasData) {
                return buildList(snapshot, context);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return new Text("");
              }
            },
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          //_openCart();
        },
        child: Icon(Icons.payment),
      ),
    );

  }

  Widget buildList(AsyncSnapshot<dynamic> snapshot, BuildContext context) {
    print('data:  ${snapshot.data}');
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
    int _count = snapshot.data['quantity'];
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

                Row(
                  children: [
                    IconButton(
                      color: Colors.black,
                      onPressed: () {
                        setState(() {
                          _count--;
                          if(_count == 0){
                            bloc.deleteProductCart(_idCart, snapshot.data['product_id']);
                          }else {
                            saveOrUpdateProdCart(snapshot, _count);
                          }
                        });

                      },
                      icon: Icon(Icons.remove),
                    ),
                    Text(
                      //'$_count',
                        ' ${snapshot.data['quantity']} '
                    ),
                    IconButton(
                      color: Colors.black,
                      onPressed: () {
                        setState(() {
                          _count++;
                          saveOrUpdateProdCart(snapshot, _count);
                        });
                      },
                      icon: Icon(Icons.add),
                    ),

                  ],
                ),
                SizedBox(height: 10),
              ],
            )
          ],
        )
    );
  }

  saveOrUpdateProdCart(dynamic snapshot, int _count) {
    bloc.saveProdCart(_idCart, snapshot.data['product_id'], {
      'cart_id' : _idCart,
      'product_id' : snapshot.data['product_id'],
      'quantity' : _count,
    });
  }
}
