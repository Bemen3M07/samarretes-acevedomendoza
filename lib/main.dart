import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

void main() {
  // Inicia la aplicación Flutter y establece MyApp como el widget principal.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define la estructura principal de la aplicación.
    return MaterialApp(
      title: 'Calculadora de Camisetas', // Título de la aplicación.
      theme: ThemeData(
        primarySwatch: Colors.blue, // Define el color principal de la aplicación.
      ),
      home: const TShirtCalculatorScreen(), // Establece la pantalla inicial.
    );
  }
}

class TShirtCalculatorScreen extends StatefulWidget {
  const TShirtCalculatorScreen({super.key});

  @override
  TShirtCalculatorScreenState createState() => TShirtCalculatorScreenState();
}

class TShirtCalculatorScreenState extends State<TShirtCalculatorScreen> {
  // Precios fijos para cada talla de camiseta.
  static const double smallPrice = TShirtCalculatorLogic.small;
  static const double mediumPrice = TShirtCalculatorLogic.medium;
  static const double largePrice = TShirtCalculatorLogic.large;

  // Variables de estado para almacenar la cantidad, talla, oferta y precio.
  int? _numTShirts;
  String? _size;
  String? _offer;
  double _price = 0.0;

  // Método para calcular el precio basado en la talla, cantidad y oferta.
  void _calculatePrice() {
    if (_numTShirts == null || _size == null) {
      // Si no se ha seleccionado una talla o cantidad, el precio es 0.
      setState(() {
        _price = 0.0;
      });
      return;
    }

    if (_offer == null) {
      // Si no hay oferta, calcula el precio sin descuento.
      setState(() {
        _price = TShirtCalculatorLogic.calculatePrice(_size!, _numTShirts!);
      });
    } else {
      // Si hay oferta, calcula el precio con descuento.
      setState(() {
        _price = TShirtCalculatorLogic.calculatePriceWithDiscount(
            _size!, _numTShirts!, _offer!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Construye la interfaz de usuario de la pantalla.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Camisetas'), // Título de la AppBar.
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            // Campo de entrada para el número de camisetas.
            MyTextInput(
              labelText: 'Samarretes',
              hintText: 'Número de samarretes',
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _numTShirts = int.tryParse(value); // Actualiza la cantidad.
                  _calculatePrice(); // Recalcula el precio.
                });
              },
            ),
            const Text('Talla'), // Texto para seleccionar la talla.
            // Opciones de talla (pequeña, mediana, grande).
            RadioListTile(
              title: const Text('Petita ($smallPrice €)'),
              value: 'small',
              groupValue: _size,
              onChanged: (value) {
                setState(() {
                  _size = value; // Actualiza la talla seleccionada.
                  _calculatePrice(); // Recalcula el precio.
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
            const Text('Oferta'), // Texto para seleccionar la oferta.
            // Menú desplegable para seleccionar una oferta.
            DropdownButton<String>(
              value: _offer,
              items: const [
                DropdownMenuItem(
                  value: null,
                  child: Text('Sense descompte'), // Opción sin descuento.
                ),
                DropdownMenuItem(
                  value: '10%',
                  child: Text('Descompte del 10%'), // Descuento del 10%.
                ),
                DropdownMenuItem(
                  value: '20€',
                  child: Text('Descompte per quantitat'), // Descuento por cantidad.
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _offer = value; // Actualiza la oferta seleccionada.
                  _calculatePrice(); // Recalcula el precio.
                });
              },
              hint: const Text('Selecciona una oferta'), // Texto de sugerencia.
            ),
            const SizedBox(height: 20),
            // Muestra el precio calculado.
            Row(
              children: [
                Text(
                  'Preu: $_price €',
                  style: const TextStyle(fontSize: 32), // Estilo del texto del precio.
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
  // Propiedades del widget.
  final String labelText; // Texto que aparece como etiqueta.
  final String hintText; // Texto de sugerencia dentro del campo.
  final TextInputType keyboardType; // Tipo de teclado que se muestra.
  final Function(String) onChanged; // Función que se ejecuta cuando el texto cambia.

  // Constructor del widget.
  const MyTextInput({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.keyboardType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Construye la interfaz de usuario del campo de texto.
    return Container(
      width: 200, // Ancho fijo del contenedor.
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey), // Borde gris alrededor del contenedor.
        borderRadius: BorderRadius.circular(8), // Bordes redondeados.
      ),
      child: TextField(
        decoration: InputDecoration(
          labelText: labelText, // Etiqueta del campo.
          hintText: hintText, // Texto de sugerencia.
          border: InputBorder.none, // Elimina el borde predeterminado del TextField.
          contentPadding: const EdgeInsets.all(8), // Espaciado interno.
        ),
        keyboardType: keyboardType, // Tipo de teclado (numérico, texto, etc.).
        onChanged: onChanged, // Función que se ejecuta cuando el texto cambia.
      ),
    );
  }
}

class TShirtCalculatorLogic {
  // Logger para registrar mensajes de depuración.
  static final Logger logger = Logger();

  // Precios fijos para cada talla de camiseta.
  static const double small = 10.0;
  static const double medium = 12.0;
  static const double large = 15.0;

  // Método para calcular el precio sin descuento.
  static double calculatePrice(String size, int numTShirts) {
    double price = 0.0;

    // Asigna el precio según la talla seleccionada.
    if (size == 'small') {
      price = small;
    } else if (size == 'medium') {
      price = medium;
    } else if (size == 'large') {
      price = large;
    }

    // Retorna el precio total multiplicado por la cantidad de camisetas.
    return price * numTShirts;
  }

  // Método para calcular el precio con descuento.
  static double calculatePriceWithDiscount(
      String size, int numTShirts, String offer) {
    // Calcula el precio base sin descuento.
    double price = calculatePrice(size, numTShirts);

    // Registra el precio base en el logger.
    logger.d('Precio base: $price');

    // Aplica descuentos según la oferta seleccionada.
    if (offer == '10%') {
      price *= 0.9; // Aplica un descuento del 10%.
      logger.d('Aplicado descuento 10%, nuevo precio: $price');
    } else if (offer == '20€') {
      if (price > 100) {
        price -= 20; // Aplica un descuento de 20€ si el precio es mayor a 100€.
        logger.d('Aplicado descuento de 20€, nuevo precio: $price');
      } else {
        logger.d(
            'No se aplica descuento de 20€ porque el precio es menor a 100€');
      }
    }

    // Retorna el precio final después de aplicar los descuentos.
    return price;
  }
}
