import 'package:flutter_test/flutter_test.dart';
import 'package:empty/main.dart';

void main() {
  group('TShirtCalculatorLogic', () {
    test('calculatePrice without discount', () {
      expect(TShirtCalculatorLogic.calculatePrice('small', 15), 150);
      expect(TShirtCalculatorLogic.calculatePrice('medium', 15), 180);
      expect(TShirtCalculatorLogic.calculatePrice('large', 15), 225);
    });

    test('calculatePrice with discount', () {
      // No discount
      expect(TShirtCalculatorLogic.calculatePriceWithDiscount('small', 15, ''),
          150);
      // 10% discount
      expect(
          TShirtCalculatorLogic.calculatePriceWithDiscount('small', 15, '10%'),
          135);
      // 20€ discount, total > 100€
      expect(
          TShirtCalculatorLogic.calculatePriceWithDiscount('large', 15, '20€'),
          205.0);
      // 20€ discount, total < 100€
      expect(
          TShirtCalculatorLogic.calculatePriceWithDiscount('small', 10, '20€'),
          100.0);
    });
      test('calculatePrice without discount for small size', () {
      expect(TShirtCalculatorLogic.calculatePrice('small', 5), 50);
    });

    test('calculatePrice without discount for medium size', () {
      expect(TShirtCalculatorLogic.calculatePrice('medium', 5), 60);
    });

    test('calculatePrice without discount for large size', () {
      expect(TShirtCalculatorLogic.calculatePrice('large', 5), 75);
    });

    // Prueba con descuento del 10%
    test('calculatePrice with 10% discount for small size', () {
      expect(TShirtCalculatorLogic.calculatePriceWithDiscount('small', 5, '10%'), 45);
    });

    test('calculatePrice with 10% discount for medium size', () {
      expect(TShirtCalculatorLogic.calculatePriceWithDiscount('medium', 5, '10%'), 54);
    });

    test('calculatePrice with 10% discount for large size', () {
      expect(TShirtCalculatorLogic.calculatePriceWithDiscount('large', 5, '10%'), 67.5);
    });

    // Prueba con descuento de 20€ (solo si el precio es mayor que 100€)
    test('calculatePrice with 20€ discount for large size, price > 100', () {
      expect(TShirtCalculatorLogic.calculatePriceWithDiscount('large', 15, '20€'), 205.0);
    });

    test('calculatePrice with 20€ discount for medium size, price > 100', () {
      expect(TShirtCalculatorLogic.calculatePriceWithDiscount('medium', 15, '20€'), 160.0);
    });

    test('calculatePrice with 20€ discount for small size, price > 100', () {
      expect(TShirtCalculatorLogic.calculatePriceWithDiscount('small', 15, '20€'), 130.0);
    });

    // Prueba sin descuento
    test('calculatePrice with no discount for small size, price < 100', () {
      expect(TShirtCalculatorLogic.calculatePriceWithDiscount('small', 5, ''), 50.0);
    });

    test('calculatePrice with no discount for medium size, price < 100', () {
      expect(TShirtCalculatorLogic.calculatePriceWithDiscount('medium', 5, ''), 60.0);
    });

    test('calculatePrice with no discount for large size, price < 100', () {
      expect(TShirtCalculatorLogic.calculatePriceWithDiscount('large', 5, ''), 75.0);
    });

    // Prueba con descuento del 20€ (solo si el precio es mayor que 100€)
    test('calculatePrice with 20€ discount for small size, price < 100', () {
      expect(TShirtCalculatorLogic.calculatePriceWithDiscount('small', 3, '20€'), 30.0);
    });

    test('calculatePrice with 20€ discount for medium size, price < 100', () {
      expect(TShirtCalculatorLogic.calculatePriceWithDiscount('medium', 3, '20€'), 36.0);
    });

    test('calculatePrice with 20€ discount for large size, price < 100', () {
      expect(TShirtCalculatorLogic.calculatePriceWithDiscount('large', 3, '20€'), 45.0);
    });

    // Prueba sin descuento para un número bajo de camisetas
    test('calculatePrice with no discount for small size, 1 t-shirt', () {
      expect(TShirtCalculatorLogic.calculatePrice('small', 1), 10.0);
    });

    test('calculatePrice with no discount for medium size, 1 t-shirt', () {
      expect(TShirtCalculatorLogic.calculatePrice('medium', 1), 12.0);
    });

    test('calculatePrice with no discount for large size, 1 t-shirt', () {
      expect(TShirtCalculatorLogic.calculatePrice('large', 1), 15.0);
    });

    // Prueba con descuento del 10% para 1 camiseta
    test('calculatePrice with 10% discount for small size, 1 t-shirt', () {
      expect(TShirtCalculatorLogic.calculatePriceWithDiscount('small', 1, '10%'), 9.0);
    });

    test('calculatePrice with 10% discount for medium size, 1 t-shirt', () {
      expect(TShirtCalculatorLogic.calculatePriceWithDiscount('medium', 1, '10%'), 10.8);
    });

    test('calculatePrice with 10% discount for large size, 1 t-shirt', () {
      expect(TShirtCalculatorLogic.calculatePriceWithDiscount('large', 1, '10%'), 13.5);
    });
  });
}
