


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:tulprueba/models/Product.dart';

class FirebaseBloc {

  final databaseRef = FirebaseDatabase.instance.reference();

  final _fireStore = Firestore.instance;

  Future<List<Product>> getProducts() async {

    List<Product> products;

    databaseRef.once().then((snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;

      print('Data : ${snapshot.value}');

      print('DataTest : ${snapshot.value['test']}');
      values.forEach((key, value) {
        products.add(Product.fromSnapshot(value));
      });

    });

    databaseRef.child('products').onChildAdded.listen((event) {
      products.add(Product.fromSnapshot(event.snapshot));
    });

    return products;
  }


  writeDataCart(String idCart) {
    databaseRef.child('cart').child(idCart).set({
//      'id', '12',
      'status', 'pending'
    });
  }

  writeDataProductsCart(String id) {
    databaseRef.child('cart').child(id).child('product_carts').set({
      'product_id', 'uyiu',
      //'cart_id', '12',
      'quantity', '2'
    });
  }

  updateProdsCart(String id){
    databaseRef.child('cart').child(id).child('product_carts').update({
      'product_id': 'uyiu',
      'quantity': '2'
    });
  }

  /*deleteProductsCart(String id, String productId){
    DatabaseReference myRef = databaseRef.child('cart').child(id).child('product_carts');
    Query query = myRef.orderByChild('product_id').equalTo(productId);

    query.once().then((snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;

      print('DataDelete : ${snapshot.value}');

      values.forEach((key, value) {
        databaseRef.child(value).remove();
      });

    });
  }*/

  //-----------

  makePurchase(String idCart){

    String status = 'completed';

    databaseRef.child('cart').child(idCart).update({
//      'id', '12',
      'status': status
    });

  }

  saveProdCart(String idCart, String idProduct, Map<String, dynamic> collections) {

    //_fireStore.collection('products_cars').add(collections);
    _fireStore.collection('carts').document(idCart).collection('products_cart').document(idProduct). setData(collections, merge: true);
  }

  //not use
  Future<QuerySnapshot> getProducts1() async {
    return await _fireStore.collection('products').getDocuments();
  }

  Stream<QuerySnapshot> getProductsStream() {
    return _fireStore.collection('products').snapshots();
  }

  Stream<QuerySnapshot> getProductsCartsStream(String idCart) {
    return _fireStore.collection('carts').document(idCart).collection('products_cart').snapshots();
  }

  Future<void> deleteProductCart(String idCart, String productId) async {
    return _fireStore.collection('carts').document(idCart).collection('products_cart').document(productId).delete();
  }

}

final bloc = FirebaseBloc();