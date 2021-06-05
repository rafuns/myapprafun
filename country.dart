class Country {
  String _countryID;
  String _countryName;
  String _countryShortName;

  Country(this._countryID, this._countryName, this._countryShortName);
  static final country_columns = [
    "countryID",
    "countryName",
    "countryShortName"
  ];

  Country.map(dynamic obj) {
    this._countryID = obj["countryID"];
    this._countryName = obj["countryName"];
    this._countryShortName = obj["countryShortName"];
  }
  String get countryID => _countryID;
  String get countryName => _countryName;
  String get countryShortName => _countryShortName;

  Map<String, dynamic> toMap() {
    var data = new Map<String, dynamic>();
    data['countryID'] = this._countryID;
    data['countryName'] = this._countryName;
    data['countryShortName'] = this._countryShortName;
    return data;
  }

  Country.fromMap(Map<String, dynamic> json) {
    _countryID = json['countryID'];
    _countryName = json['countryName'];
    _countryShortName = json['countryShortName'];
  }

  Country.fromJson(Map<String, dynamic> json) {
    _countryID = json['countryID'];
    _countryName = json['countryName'];
    _countryShortName = json['countryShortName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['countryID'] = this._countryID;
    data['countryName'] = this._countryName;
    data['countryShortName'] = this._countryShortName;
    return data;
  }
}
