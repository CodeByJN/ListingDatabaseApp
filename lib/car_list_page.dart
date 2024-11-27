import 'package:flutter/material.dart';
import 'app_database.dart';
import 'car.dart';
import 'car_dao.dart';
import 'encryption_helper.dart';
import 'database_factory.dart';

class CarListPage extends StatefulWidget {
  const CarListPage({Key? key}) : super(key: key);

  @override
  _CarListPageState createState() => _CarListPageState();
}

class _CarListPageState extends State<CarListPage> {
  List<Car> _cars = [];
  CarDao? _carDao;  // Make sure _carDao can be null initially
  late AppDatabase _database;
  bool _isLoading = true;
  bool _isDatabaseInitialized = false;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    try {
      _database = await getDatabase();  // Initialize the database
      _carDao = _database.carDao;  // Initialize the DAO
      _isDatabaseInitialized = true;
      await _loadCars();
    } catch (e) {
      print('Error initializing database: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadCars() async {
    if (!_isDatabaseInitialized || _carDao == null) return;

    try {
      final cars = await _carDao!.findAllCars(); // Make sure _carDao is not null
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

      if (encryptedBrand != null && encryptedModel != null && encryptedPassengers != null && encryptedSize != null) {
        // Use decrypted data as needed
      }
    } catch (e) {
      print('Error loading encrypted data: $e');
    }
  }

  void _showAddCarDialog() {
    showDialog(
      context: context,
      builder: (context) => _CarDialog(onSubmit: (car) async {
        setState(() {
          _cars.add(car);
        });
        if (_carDao != null) {
          await _carDao!.insertCar(car); // Check that _carDao is not null before use
        }
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
        onSubmit: (updatedCar) async {
          setState(() {
            final index = _cars.indexWhere((c) => c.id == car.id);
            _cars[index] = updatedCar;
          });
          if (_carDao != null) {
            await _carDao!.updateCar(updatedCar); // Check that _carDao is not null before use
          }
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
    if (_carDao != null) {
      _carDao!.deleteCar(car); // Check that _carDao is not null before use
    }
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cars.isEmpty
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
        content: const Text('Press on the "Add Car" button to start adding car.'),
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
              final car = Car(
                id: this.car?.id,
                brand: _brandController.text.trim(),
                model: _modelController.text.trim(),
                passengers: int.parse(_passengersController.text.trim()),
                size: double.parse(_sizeController.text.trim()),
              );
              onSubmit(car);
              Navigator.pop(context);
            }
          },
          child: Text(car == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }

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
    return true;
  }
}
