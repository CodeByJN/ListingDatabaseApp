import 'package:flutter/material.dart';
import 'app_database.dart';
import 'car.dart';
import 'car_dao.dart';
import 'encryption_helper.dart';

class CarListPage extends StatefulWidget {
  @override
  _CarListPageState createState() => _CarListPageState();
}

class _CarListPageState extends State<CarListPage> {
  List<Car> _cars = [];
  late CarDao _carDao;
  late AppDatabase _database;

  @override
  void initState() {
    super.initState();
    _initDatabase();
    _loadEncryptedData();
  }

  Future<void> _initDatabase() async {
    try {
      // Initialize the database and DAO
      _database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
      _carDao = _database.carDao;
      print('Database initialized successfully');
      _loadCars();
    } catch (e) {
      print('Error initializing database: $e');
    }
  }

  Future<void> _loadCars() async {
    try {
      final cars = await _carDao.findAllCars();
      print('Cars loaded: ${cars.length}');
      setState(() {
        _cars = cars;
      });
    } catch (e) {
      print('Error loading cars: $e');
    }
  }

  Future<void> _loadEncryptedData() async {
    try {
      final encryptedBrand = await EncryptionHelper.getEncryptedString('last_brand');
      final encryptedModel = await EncryptionHelper.getEncryptedString('last_model');
      final encryptedPassengers = await EncryptionHelper.getEncryptedString('last_passengers');
      final encryptedSize = await EncryptionHelper.getEncryptedString('last_size');

      print('Encrypted data loaded: $encryptedBrand, $encryptedModel, $encryptedPassengers, $encryptedSize');
    } catch (e) {
      print('Error loading encrypted data: $e');
    }
  }

  void _showAddCarDialog() {
    showDialog(
      context: context,
      builder: (context) => _CarDialog(
        onSubmit: (car) {
          setState(() {
            _cars.add(car);
          });
          _carDao.insertCar(car);
        },
      ),
    );
  }

  void _showUpdateCarDialog(Car car) {
    showDialog(
      context: context,
      builder: (context) => _CarDialog(
        car: car,
        onSubmit: (updatedCar) {
          setState(() {
            final index = _cars.indexWhere((c) => c.id == car.id);
            _cars[index] = updatedCar;
          });
          _carDao.updateCar(updatedCar);
        },
      ),
    );
  }

  void _deleteCar(Car car) {
    setState(() {
      _cars.remove(car);
    });
    _carDao.deleteCar(car);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: _showInstructionsDialog,
          ),
        ],
      ),
      body: _cars.isEmpty
          ? Center(
        child: Text(
          'No cars available. Tap + to add a car.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: _cars.length,
        itemBuilder: (context, index) {
          final car = _cars[index];
          return ListTile(
            title: Text('${car.brand} ${car.model}'),
            onTap: () {
              _showUpdateCarDialog(car);
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _deleteCar(car);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _showAddCarDialog,
      ),
    );
  }

  void _showInstructionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Instructions'),
        content: const Text('Instructions on how to use the car list page.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _CarDialog extends StatelessWidget {
  final Car? car;
  final Function(Car) onSubmit;

  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _passengersController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();

  _CarDialog({this.car, required this.onSubmit}) {
    if (car != null) {
      _brandController.text = car!.brand;
      _modelController.text = car!.model;
      _passengersController.text = car!.passengers.toString();
      _sizeController.text = car!.size.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(car == null ? 'Add Car' : 'Update Car'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _brandController,
              decoration: const InputDecoration(labelText: 'Brand'),
            ),
            TextField(
              controller: _modelController,
              decoration: const InputDecoration(labelText: 'Model'),
            ),
            TextField(
              controller: _passengersController,
              decoration: const InputDecoration(labelText: 'Passengers'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _sizeController,
              decoration: const InputDecoration(labelText: 'Size (litres/kWh)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final newCar = Car(
              id: car?.id,
              brand: _brandController.text,
              model: _modelController.text,
              passengers: int.parse(_passengersController.text),
              size: double.parse(_sizeController.text),
            );
            onSubmit(newCar);
            _saveEncryptedData(newCar);
            Navigator.of(context).pop();
          },
          child: Text(car == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }

  Future<void> _saveEncryptedData(Car car) async {
    try {
      await EncryptionHelper.setEncryptedString('last_brand', car.brand);
      await EncryptionHelper.setEncryptedString('last_model', car.model);
      await EncryptionHelper.setEncryptedString('last_passengers', car.passengers.toString());
      await EncryptionHelper.setEncryptedString('last_size', car.size.toString());
      print('Encrypted data saved successfully');
    } catch (e) {
      print('Error saving encrypted data: $e');
    }
  }
}
