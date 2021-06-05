import 'dart:ffi';

import 'country.dart';

class Customer {
  Country country;
  Double int;
  String _customerID;
  String _firstName;
  String _lastName;
  String _customerImage;
  String _customerImageOrgURL;
  String _address;
  String _suburb;
  String _postCode;
  String _countryID;
  String _stateID;
  String _newsletterSubscribe;
  String _customerEmail;
  String _referredBy;
  String _customerActive;
  String _customerNotes;
  String _otherNumber;
  String _phoneMobile;
  String _otherEmail;
  String _imageText;
  String _favCustomer;

  Customer(
      this._customerID,
      this._firstName,
      this._lastName,
      this._customerImage,
      this._customerImageOrgURL,
      this._address,
      this._suburb,
      this._postCode,
      this._countryID,
      this._stateID,
      this._newsletterSubscribe,
      this._customerEmail,
      this._referredBy,
      this._customerActive,
      this._customerNotes,
      this._otherNumber,
      this._phoneMobile,
      this._otherEmail,
      this._imageText,
      this._favCustomer);

  static final custom_columns = [
    "customerID",
    "firstName",
    "lastName",
    "customerImage",
    "customerImageOrgURL",
    "address",
    "suburb",
    "postCode",
    "countryID",
    "stateID",
    "newsletterSubscribe",
    "customerEmail",
    "referredBy",
    "customerActive",
    "otherNumber",
    "phoneMobile",
    "otherEmail",
    "imageText",
    "favCustomer"
  ];

  Customer.map(dynamic json) {
    _customerID = json['customerID'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _customerImage = json['customerImage'];
    _customerImageOrgURL = json['customerImageOrgURL'];
    _address = json['address'];
    _suburb = json['suburb'];
    _postCode = json['postCode'];
    _countryID = json['countryID'];
    _stateID = json['stateID'];
    _newsletterSubscribe = json['newsletterSubscribe'];
    _customerEmail = json['customerEmail'];
    _referredBy = json['referredBy'];
    _customerActive = json['customerActive'];
    _customerNotes = json['customerNotes'];
    _otherNumber = json['otherNumber'];
    _phoneMobile = json['phoneMobile'];
    _otherEmail = json['otherEmail'];
    _imageText = json['imageText'];
    _favCustomer = json['favCustomer'];
  }

  String get customerID => _customerID;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get customerImage => _customerImage;
  String get customerImageOrgURL => _customerImageOrgURL;
  String get address => _address;
  String get suburb => _suburb;
  String get postCode => _postCode;
  String get countryID => _countryID;
  String get stateID => _stateID;
  String get newsletterSubscribe => _newsletterSubscribe;
  String get customerEmail => _customerEmail;
  String get referredBy => _referredBy;
  String get customerActive => _customerActive;
  String get customerNotes => _customerNotes;
  String get otherNumber => _otherNumber;
  String get phoneMobile => _phoneMobile;
  String get otherEmail => _otherEmail;
  String get imageText => _imageText;
  String get favCustomer => _favCustomer;

  Map<String, dynamic> toMap() {
    var data = new Map<String, dynamic>();
    data['customerID'] = this._customerID;
    data['firstName'] = this._firstName;
    data['lastName'] = this._lastName;
    data['customerImage'] = this._customerImage;
    data['customerImageOrgURL'] = this._customerImageOrgURL;
    data['address'] = this._address;
    data['suburb'] = this._suburb;
    data['postCode'] = this._postCode;
    data['countryID'] = this._countryID;
    data['stateID'] = this._stateID;
    data['newsletterSubscribe'] = this._newsletterSubscribe;
    data['customerEmail'] = this._customerEmail;
    data['referredBy'] = this._referredBy;
    data['customerActive'] = this._customerActive;
    data['customerNotes'] = this._customerNotes;
    data['otherNumber'] = this._otherNumber;
    data['phoneMobile'] = this._phoneMobile;
    data['otherEmail'] = this._otherEmail;
    data['imageText'] = this._imageText;
    data['favCustomer'] = this._favCustomer;
    return data;
  }

  Customer.fromMap(Map<String, dynamic> json) {
    _customerID = json['customerID'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _customerImage = json['customerImage'];
    _customerImageOrgURL = json['customerImageOrgURL'];
    _address = json['address'];
    _suburb = json['suburb'];
    _postCode = json['postCode'];
    _countryID = json['countryID'];
    _stateID = json['stateID'];
    _newsletterSubscribe = json['newsletterSubscribe'];
    _customerEmail = json['customerEmail'];
    _referredBy = json['referredBy'];
    _customerActive = json['customerActive'];
    _customerNotes = json['customerNotes'];
    _otherNumber = json['otherNumber'];
    _phoneMobile = json['phoneMobile'];
    _otherEmail = json['otherEmail'];
    _imageText = json['imageText'];
    _favCustomer = json['favCustomer'];
  }

  Customer.fromJson(Map<String, dynamic> json) {
    _customerID = json['customerID'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _customerImage = json['customerImage'];
    _customerImageOrgURL = json['customerImageOrgURL'];
    _address = json['address'];
    _suburb = json['suburb'];
    _postCode = json['postCode'];
    _countryID = json['countryID'];
    _stateID = json['stateID'];
    _newsletterSubscribe = json['newsletterSubscribe'];
    _customerEmail = json['customerEmail'];
    _referredBy = json['referredBy'];
    _customerActive = json['customerActive'];
    _customerNotes = json['customerNotes'];
    _otherNumber = json['otherNumber'];
    _phoneMobile = json['phoneMobile'];
    _otherEmail = json['otherEmail'];
    _imageText = json['imageText'];
    _favCustomer = json['favCustomer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerID'] = this._customerID;
    data['firstName'] = this._firstName;
    data['lastName'] = this._lastName;
    data['customerImage'] = this._customerImage;
    data['customerImageOrgURL'] = this._customerImageOrgURL;
    data['address'] = this._address;
    data['suburb'] = this._suburb;
    data['postCode'] = this._postCode;
    data['countryID'] = this._countryID;
    data['stateID'] = this._stateID;
    data['newsletterSubscribe'] = this._newsletterSubscribe;
    data['customerEmail'] = this._customerEmail;
    data['referredBy'] = this._referredBy;
    data['customerActive'] = this._customerActive;
    data['customerNotes'] = this._customerNotes;
    data['otherNumber'] = this._otherNumber;
    data['phoneMobile'] = this._phoneMobile;
    data['otherEmail'] = this._otherEmail;
    data['imageText'] = this._imageText;
    data['favCustomer'] = this._favCustomer;
    return data;
  }
}
