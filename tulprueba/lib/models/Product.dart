

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Product {
  String _id;
  String _nombre;
  String _sku;
  String _descripcion;

  Product(result){
    _id = result['id'];
    _nombre = result['nombre'];
    _sku = result['sku'];
    _descripcion = result['descripcion'];

  }

  Product.fromSnapshot(DataSnapshot snapshot) :
        _id = snapshot.key,
        _nombre = snapshot.value["nombre"],
        _sku = snapshot.value["sku"],
        _descripcion = snapshot.value["descripcion"];

  toJson() {
    return {
      "id": _id,
      "nombre": _nombre,
      "sku": _sku,
      "descripcion": _descripcion
    };
  }

String get id => _id;
String get nombre => _nombre;
String get sku => _sku;
String get descripcion => _descripcion;
}