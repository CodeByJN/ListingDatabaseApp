import 'package:flutter/material.dart';
import 'app_database.dart';
import 'car.dart';
import 'car_dao.dart';
import 'encryption_helper.dart';

class CarListPage extends StatefulWidget {
  const CarListPage({Key? key}) : super(key: key);

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
    _database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _carDao = _database.carDao;
    _loadCars();
  }

  Future<void> _loadCars() async {
    final cars = await _carDao.findAllCars();
    setState(() {
      _cars = cars;
    });
  }

  Future<void> _loadEncryptedData() async {
    final encryptedBrand = await EncryptionHelper.getEncryptedString('last_brand');
    final encryptedModel = await EncryptionHelper.getEncryptedString('last_model');
    final encryptedPassengers = await EncryptionHelper.getEncryptedString('last_passengers');
    final encryptedSize = await EncryptionHelper.getEncryptedString('last_size');

    if (encryptedBrand != null && encryptedModel != null && encryptedPassengers != null && encryptedSize != null) {
      // Use decrypted data as needed
    }
  }

  void _showAddCarDialog() {
    showDialog(
      context: context,
      builder: (context) => _CarDialog(onSubmit: (car) {
        setState(() {
          _cars.add(car);
        });
        _carDao.insertCar(car);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Car "${car.brand} ${car.model}" added successfully!')),
        );
      }),
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Car "${car.brand} ${car.model}" updated successfully!')),
          );
        },
      ),
    );
  }

  void _deleteCar(Car car) {
    setState(() {
      _cars.remove(car);
    });
    _carDao.deleteCar(car);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Car "${car.brand} ${car.model}" deleted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInstructionsDialog,
          ),
        ],
      ),
      body: _cars.isEmpty
          ? const Center(
        child: Text(
          'No cars available. Tap the "+" button to add a new car.',
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: _cars.length,
        itemBuilder: (context, index) {
          final car = _cars[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: const Icon(Icons.directions_car, size: 36, color: Colors.blue),
              title: Text(
                '${car.brand} ${car.model}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Passengers: ${car.passengers}, Size: ${car.size}L'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteCar(car),
              ),
              onTap: () => _showUpdateCarDialog(car),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddCarDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Car'),
      ),
    );
  }

  void _showInstructionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Instructions'),
        content: const Text('Here is how to use the Car List Page...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(car == null ? 'Add Car' : 'Update Car'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(),
            TextField(
              controller: _brandController,
              decoration: const InputDecoration(
                labelText: 'Brand',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _modelController,
              decoration: const InputDecoration(
                labelText: 'Model',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passengersController,
              decoration: const InputDecoration(
                labelText: 'Passengers',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _sizeController,
              decoration: const InputDecoration(
                labelText: 'Size (litres/kWh)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_validateInputs(context)) {
              final newCar = Car(
                id: car?.id,
                brand: _brandController.text.trim(),
                model: _modelController.text.trim(),
                passengers: int.parse(_passengersController.text),
                size: double.parse(_sizeController.text),
              );
              onSubmit(newCar);
              _saveEncryptedData(newCar);
              Navigator.pop(context);
            }
          },
          child: Text(car == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }
  /// Validates input fields and shows a `SnackBar` for invalid entries.
  bool _validateInputs(BuildContext context) {
    if (_brandController.text.trim().isEmpty ||
        _modelController.text.trim().isEmpty ||
        _passengersController.text.trim().isEmpty ||
        _sizeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all the fields before submitting.'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    try {
      int.parse(_passengersController.text.trim());
      double.parse(_sizeController.text.trim());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid numeric values for Passengers and Size.'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _saveEncryptedData(Car car) async {
    await EncryptionHelper.setEncryptedString('last_brand', car.brand);
    await EncryptionHelper.setEncryptedString('last_model', car.model);
    await EncryptionHelper.setEncryptedString('last_passengers', car.passengers.toString());
    await EncryptionHelper.setEncryptedString('last_size', car.size.toString());
  }
}
