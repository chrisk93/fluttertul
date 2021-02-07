

import 'package:flutter/material.dart';
import 'package:tulprueba/pages/cart_page.dart';
import 'package:tulprueba/pages/home_page.dart';

Map<String, WidgetBuilder> applicationRoutes() {

  return <String, WidgetBuilder>{
    '/' : (BuildContext context) => HomePage(title: 'Productos'),
    'items_cart' : (BuildContext context) => CartPage(),
  };

}