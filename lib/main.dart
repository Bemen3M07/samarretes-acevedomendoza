import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Camisetas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TShirtCalculatorScreen(),
    );
  }
}

class TShirtCalculatorScreen extends StatefulWidget {
  const TShirtCalculatorScreen({super.key});

  @override
  TShirtCalculatorScreenState createState() => TShirtCalculatorScreenState();
}

class TShirtCalculatorScreenState extends State<TShirtCalculatorScreen> {
  static const double smallPrice = TShirtCalculatorLogic.small;
  static const double mediumPrice = TShirtCalculatorLogic.medium;
  static const double largePrice = TShirtCalculatorLogic.large;

  int? _numTShirts;
  String? _size;
  String? _offer;
  double _price = 0.0;

  void _calculatePrice() {
    if (_numTShirts == null || _size == null) {
      setState(() {
        _price = 0.0;
      });
      return;
    }

    if (_offer == null) {
      setState(() {
        _price = TShirtCalculatorLogic.calculatePrice(_size!, _numTShirts!);
      });
    } else {
      setState(() {
        _price = TShirtCalculatorLogic.calculatePriceWithDiscount(
            _size!, _numTShirts!, _offer!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Camisetas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            MyTextInput(
              labelText: 'Samarretes',
              hintText: 'Número de samarretes',
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _numTShirts = int.tryParse(value);
                  _calculatePrice();
                });
              },
            ),
            const Text('Talla'),
            RadioListTile(
              title: const Text('Petita ($smallPrice €)'),
              value: 'small',
              groupValue: _size,
              onChanged: (value) {
                setState(() {
                  _size = value;
                  _calculatePrice();
                });
              },
            ),
            RadioListTile(
              title: const Text('Mitjana ($mediumPrice €)'),
              value: 'medium',
              groupValue: _size,
              onChanged: (value) {
                setState(() {
                  _size = value;
                  _calculatePrice();
                });
              },
            ),
            RadioListTile(
              title: const Text('Gran ($largePrice €)'),
              value: 'large',
              groupValue: _size,
              onChanged: (value) {
                setState(() {
                  _size = value;
                  _calculatePrice();
                });
              },
            ),
            const SizedBox(height: 20),
            const Text('Oferta'),
            DropdownButton<String>(
              value: _offer,
              items: const [
                DropdownMenuItem(
                  value: null,
                  child: Text('Sense desompte'),
                ),
                DropdownMenuItem(
                  value: '10%',
                  child: Text('Descompte del 10%'),
                ),
                DropdownMenuItem(
                  value: '20€',
                  child: Text('Descompte per quantitat'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _offer = value;
                  _calculatePrice();
                });
              },
              hint: const Text('Selecciona una oferta'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Preu: $_price €',
                  style: const TextStyle(fontSize: 32),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyTextInput extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final Function(String) onChanged;

  const MyTextInput({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.keyboardType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200, // Set the desired width
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey), // Add border
        borderRadius: BorderRadius.circular(8), // Optional: Add border radius
      ),
      child: TextField(
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: InputBorder.none, // Remove default border
          contentPadding:
              const EdgeInsets.all(8), // Add padding inside the border
        ),
        keyboardType: keyboardType,
        onChanged: onChanged,
      ),
    );
  }
}

class TShirtCalculatorLogic {
  static final Logger logger = Logger();

  static const double small = 10.0;
  static const double medium = 12.0;
  static const double large = 15.0;

  static double calculatePrice(String size, int numTShirts) {
    double price = 0.0;
    if (size == 'small') {
      price = small;
    } else if (size == 'medium') {
      price = medium;
    } else if (size == 'large') {
      price = large;
    }
    return price * numTShirts;
  }

  static double calculatePriceWithDiscount(
      String size, int numTShirts, String offer) {
    double price = calculatePrice(size, numTShirts);

    logger.d('Precio base: $price'); // Usamos el nivel de log 'debug'

    if (offer == '10%') {
      price *= 0.9; // Descuento del 10%
      logger.d('Aplicado descuento 10%, nuevo precio: $price');
    } else if (offer == '20€') {
      if (price > 100) {
        price -= 20; // Descuento de 20€ solo si el precio es mayor que 100€
        logger.d('Aplicado descuento de 20€, nuevo precio: $price');
      } else {
        logger.d(
            'No se aplica descuento de 20€ porque el precio es menor a 100€');
      }
    }

    return price;
  }
}
