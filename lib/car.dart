import 'package:floor/floor.dart';

@Entity(tableName: 'cars')
class Car {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String brand;
  final String model;
  final int passengers;
  final double size;

  Car({this.id, required this.brand, required this.model, required this.passengers, required this.size});
}
