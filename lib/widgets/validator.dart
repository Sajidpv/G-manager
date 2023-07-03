String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter an email address.';
  }
  if (!value.contains("@") && !value.contains('.com')) {
    return 'Not a valid mail';
  }

  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a password.';
  }
  if (value.length < 6) {
    return 'Minimum 6 Charecters required';
  }

  return null;
}

String? validaterMandatory(String? value) {
  if (value == null || value.isEmpty) {
    return 'Required Field';
  }

  return null;
}

String? validaterPurID(String? value) {
  if (value == null || value.isEmpty) {
    return 'Required Field';
  }
  if (!value.startsWith("PUR")) {
    return 'Id must start with PUR';
  }
  if (!RegExp(r'^PUR\d').hasMatch(value)) {
    return 'id must contain numbers';
  }
  return null;
}

String? validaterBatchCode(String? value) {
  if (value == null || value.isEmpty) {
    return 'Required Field';
  }
  if (!value.startsWith("BATCH")) {
    return 'Id must start with BATCH';
  }
  if (!RegExp(r'^BATCH\d').hasMatch(value)) {
    return 'id must contain numbers';
  }
  return null;
}

String? validaterMCode(String? value) {
  if (value == null || value.isEmpty) {
    return 'Required Field';
  }
  if (!value.startsWith("M")) {
    return 'Item Code must start with M';
  }
  if (!RegExp(r'^M\d').hasMatch(value)) {
    return 'Item Code must contain numbers';
  }
  return null;
}

String? validaterCodeP(String? value) {
  if (value == null || value.isEmpty) {
    return 'Required Field';
  }
  if (!value.startsWith("P")) {
    return 'Item Code must start with P';
  }
  if (!RegExp(r'^P\d').hasMatch(value)) {
    return 'Item Code must contain numbers';
  }
  return null;
}

String? validaterCodeC(String? value) {
  if (value == null || value.isEmpty) {
    return 'Required Field';
  }
  if (!value.startsWith("C")) {
    return 'Item Code must start with C';
  }
  if (!RegExp(r'^C\d').hasMatch(value)) {
    return 'Item Code must contain numbers';
  }
  return null;
}

String? validaterEmpID(String? value) {
  if (value == null || value.isEmpty) {
    return 'Required Field';
  }
  if (!value.startsWith("EMP")) {
    return 'Id must start with EMP';
  }
  if (!RegExp(r'^EMP\d').hasMatch(value)) {
    return 'Id must contain numbers';
  }
  return null;
}

String? validatorColorQuantity(String? value, double? availableQuantity) {
  final parsedvalue = double.tryParse(value!);
  if (value.isEmpty) {
    return 'Required Field';
  }
  if (availableQuantity! < 1) {
    return 'Quantity Exceeded';
  }
  if (parsedvalue! > availableQuantity) {
    return 'Invalid Quantity';
  }

  return null;
}

String? quandityValidator(String? value, String? quantity) {
  final parsedvalue = double.tryParse(value!);
  final quantit = double.tryParse(quantity!);
  if (parsedvalue == null || value.isEmpty) {
    return 'Required Field';
  }
  if (parsedvalue > quantit!) {
    return 'Quantity not\nexceeded than $quantit';
  }

  return null;
}

String? layerQuantityValidator(
    String? value, double? quantity, double? availableQuantity) {
  final parsedvalue = double.tryParse(value!);

  if (parsedvalue == null || value.isEmpty) {
    return 'Required Field';
  }
  if (availableQuantity! < quantity!) {
    return 'Invalid Quantity';
  }

  return null;
}

String? balanceQuantityValidator(String? value, double? totalQuantity,
    double? availableQuantity, double? balanceQuantity) {
  final balance = totalQuantity! + balanceQuantity!;
  if (availableQuantity! < balance) {
    return 'Invalid Balance';
  }

  return null;
}

String? balanceValidator(
    String? value, double? quantity, double? availableQuantity) {
  if (quantity! > availableQuantity!) {
    return 'Invalid Balance';
  }
  return null;
}

String? damageValidator(
    String? value, double? quantity, double? availableQuantity) {
  final parsedvalue = double.tryParse(value!);

  final quantityy = parsedvalue! + quantity!;
  if (quantityy > availableQuantity!) {
    return 'Invalid Balance';
  }
  return null;
}

String? validateDropdown(value) {
  if (value == null) {
    return 'Please select an option.';
  }
  return null;
}

String? validateConfirmPassword(String? value, String? password) {
  if (value == null || value.isEmpty) {
    return 'Please confirm your password.';
  }
  if (value != password) {
    return 'Passwords do not match.';
  }

  return null;
}
