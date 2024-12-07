/// Represents a customer with their basic information.
class Customer {
  /// Customer's ID in the database. Null for new customers.
  final int? id;

  /// Customer's first name
  final String firstName;

  /// Customer's last name
  final String lastName;

  /// Customer's address
  final String address;

  /// Customer's birthday
  final String birthday;

  /// Creates a new customer with the given information
  Customer({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.birthday,
  });

  /// Converts customer data to a map for saving to database
  Map<String, String> toMap() {
    return {
      if (id != null) 'id': id.toString(),
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'birthday': birthday,
    };
  }

  /// Creates a customer object from database data
  static Customer fromMap(Map<String, String> map) {
    return Customer(
      id: int.tryParse(map['id'] ?? ''),
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      address: map['address'] ?? '',
      birthday: map['birthday'] ?? '',
    );
  }
}