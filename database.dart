import 'dart:async';
import 'dart:io' as io;

import 'package:franchisecare/models/country.dart';
import 'package:franchisecare/models/pets.dart';
import 'package:franchisecare/models/user.dart';
import 'package:franchisecare/models/news.dart';
import 'package:franchisecare/models/booking.dart';
import 'package:franchisecare/models/customer.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    // prefs.setInt('dataloadcount', 1);
    print("reached here");
    String userID = prefs.getString('userID');

    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path =
        join(documentsDirectory.path, "1firstfranchisectwo$userID.db");
    print('db location : ' + path);

    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE User(id INTEGER PRIMARY KEY AUTOINCREMENT, userID INTEGER UNIQUE, companyID TEXT,appID TEXT,userStateID TEXT,appCountryID TEXT,userName TEXT,firstName TEXT,lastName TEXT,address1 TEXT,suburb TEXT,userImage TEXT,userImageOrgURL TEXT,userActive TEXT,timeZone TEXT,autoExtend TEXT,apiToken TEXT)");

    await db.execute(
        "CREATE TABLE news (id INTEGER PRIMARY KEY AUTOINCREMENT, newsID TEXT,newsTitle TEXT,newsDescription TEXT,newsDate TEXT,newsPriority TEXT,newsCategoryID TEXT,newsCategoryName TEXT,newsImage TEXT,newsImageOrgURL TEXT,dataType TEXT DEFAULT 'live')");

    await db.execute(
        "CREATE TABLE booking (id INTEGER PRIMARY KEY AUTOINCREMENT, bookingID TEXT UNIQUE,bookingType TEXT,customerID TEXT,bookedDate TEXT,bookedTime TEXT,bookingComments TEXT,bookingAddress TEXT,bookingSuburb TEXT,bookingPostCode TEXT,bookingStateID TEXT,latitude TEXT,longitude TEXT,bookingRecurringID TEXT,bookingCreatedIn TEXT,bookingLastUpdatedDate TEXT,dataType TEXT DEFAULT 'live')");

    await db.execute(
        "CREATE TABLE bookingdetail (id INTEGER PRIMARY KEY AUTOINCREMENT, bookingID TEXT, itemID TEXT,serviceID TEXT,servicePrice TEXT,dataType TEXT DEFAULT 'live')");

    await db.execute(
        "CREATE TABLE pets (id INTEGER PRIMARY KEY AUTOINCREMENT, itemID TEXT UNIQUE,customerID TEXT,itemName TEXT,itemBirthYear TEXT,itemBirthMonth TEXT,itemBirthDay TEXT,itemBreed TEXT,itemColor TEXT,itemGenderID TEXT,itemGenderName TEXT,itemActive TEXT,itemNotes TEXT,itemImage TEXT,dataType TEXT DEFAULT 'live')");
    await db.execute(
        "CREATE TABLE states (id INTEGER PRIMARY KEY AUTOINCREMENT, stateID TEXT UNIQUE,stateName TEXT,stateShortName TEXT,countryID TEXT,dataType TEXT DEFAULT 'live')");
    await db.execute(
        "CREATE TABLE countries (id INTEGER PRIMARY KEY AUTOINCREMENT, countryID TEXT UNIQUE,countryName TEXT,countryShortName TEXT,dataType TEXT DEFAULT 'live')");
    await db.execute(
        "CREATE TABLE customers (id INTEGER PRIMARY KEY AUTOINCREMENT, customerID TEXT UNIQUE,firstName TEXT,lastName TEXT,customerImage TEXT,customerImageOrgURL TEXT,address TEXT,suburb TEXT,postCode TEXT,countryID TEXT,stateID TEXT,newsletterSubscribe TEXT,customerEmail TEXT,referredBy TEXT,customerActive TEXT,customerNotes TEXT,otherNumber TEXT,phoneMobile TEXT,otherEmail TEXT,imageText TEXT,favCustomer TEXT,dataType TEXT DEFAULT 'live')");

    await db.execute(
        "CREATE TABLE petservices (id INTEGER PRIMARY KEY AUTOINCREMENT, systemServiceID TEXT UNIQUE,ServiceName TEXT,systemServicePrice TEXT,systemServiceDuration TEXT,memberServiceColor TEXT,displayPosition TEXT,memberServicePrice TEXT,memberServiceDuration TEXT,dataType TEXT DEFAULT 'live')");

    await db.execute(
        "CREATE TABLE activity (id INTEGER PRIMARY KEY AUTOINCREMENT, activityID TEXT UNIQUE,activityDetail TEXT,activityType TEXT,activityFrom TEXT,dataType TEXT DEFAULT 'live')");

    await db.execute(
        "CREATE TABLE incomecategory (id INTEGER PRIMARY KEY AUTOINCREMENT, incomeCategoryID TEXT UNIQUE,incomeCategoryName TEXT,incomeCategoryDescription TEXT,incomeCategoryEntryCount TEXT,incomeCategoryActive TEXT,incomeCategoryAddedBy TEXT,dataType TEXT DEFAULT 'live')");

    await db.execute(
        "CREATE TABLE income (id INTEGER PRIMARY KEY AUTOINCREMENT, incomeEntryID TEXT UNIQUE,incomeCategoryName TEXT,incomeCategoryID TEXT,incomeTitle TEXT,incomeAmount TEXT,incomeDescription TEXT,incomeDate TEXT,incomeActive TEXT,isIncomeRecurring INTEGER,dataType TEXT DEFAULT 'live')");

    await db.execute(
        "CREATE TABLE expense (id INTEGER PRIMARY KEY AUTOINCREMENT, expenseEntryID TEXT UNIQUE,expenseSuperCategoryName TEXT,expenseSuperCategoryID TEXT,expenseCategoryName TEXT,expenseCategoryID TEXT,expenseTitle TEXT,expenseAmount TEXT,expenseDescription TEXT,expenseDate TEXT,expenseAttachmentURLThumbnail TEXT,expenseAttachmentURL TEXT,expenseActive TEXT,isExpenseRecurring TEXT,dataType TEXT DEFAULT 'live')");

    await db.execute(
        "CREATE TABLE expensecategory (id INTEGER PRIMARY KEY AUTOINCREMENT, expenseCategoryID TEXT UNIQUE,expenseSuperCategoryID TEXT,expenseCategoryName TEXT,expenseSuperCategoryName TEXT,expenseCategoryDescription TEXT,expenseCategoryEntryCount TEXT,dataType TEXT DEFAULT 'live')");

    await db.execute(
        "CREATE TABLE calendarentries (id INTEGER PRIMARY KEY AUTOINCREMENT, calendarEntryID TEXT UNIQUE,bookingID TEXT,customerID TEXT,blockID TEXT,entryType TEXT,startDate TEXT,startTime TEXT,endDate TEXT,endTime TEXT,calendarTitle TEXT,calendarDescription TEXT,customerName TEXT,customerAddress TEXT,recurringID TEXT,calendarBGcolor TEXT,bookingType TEXT,dataType TEXT DEFAULT 'live')");
  }

  Future<int> saveNews(News news) async {
    var dbClient = await db;
    int res = await dbClient.insert("news", news.toMap());
    return res;
  }

  Future<dynamic> getCustomer(String customerID) async {
    final dbClient = await db;
    // print('SELECT * FROM customers where customerID="$customerID"');
    List<Map> list = await dbClient
        .rawQuery('SELECT * FROM customers where customerID="$customerID"');
    // print(list);
    return list;
  }

  getSingleCustomer(String customerID) async {
    final dbClient = await db;
    //print('SELECT * FROM customers WHERE customerID="$customerID"');
    print("Customer Id : $customerID");
    List<Map> list = await dbClient
        .rawQuery('SELECT * FROM customers WHERE customerID="$customerID"');
    //  List<Customer> customer ;

    var data = list[0];

    var customer = new Customer(
        data['customerID'],
        data['firstName'],
        data['lastName'],
        data['customerImage'],
        data['customerImageOrgURL'],
        data['address'],
        data['suburb'],
        data['postCode'],
        data['countryID'],
        data['stateID'],
        data['newsletterSubscribe'],
        data['customerEmail'],
        data['referredBy'],
        data['customerActive'],
        data['customerNotes'],
        data['otherNumber'],
        data['phoneMobile'],
        data['otherEmail'],
        data['imageText'],
        data['favCustomer']);

    return data;
  }

  Future<List<Customer>> retrieveUsers(String id) async {
    final dbClient = await db;

    final List<Map<String, Object>> queryResult =
        await dbClient.query('customers');

    return queryResult.map((e) => Customer.fromMap(e)).toList();
  }

  Future<dynamic> getNews(String newsid) async {
    final dbClient = await db;
    List<Map> list =
        await dbClient.rawQuery('SELECT * FROM News where newsID="$newsid"');
    return list.length;
  }

  Future<int> saveData(String tablename, datatype) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tablename", datatype.toMap());
    return res;
  }

  Future getData(String tablename, String field, String id) async {
    final dbClient = await db;
    List<Map> list = await dbClient
        .rawQuery("SELECT * FROM $tablename where `$field`='$id'");
    return list.length;
  }

  Future<dynamic> getSingleRow(
      String tablename, String field, String id) async {
    final dbClient = await db;
    List<Map> list = await dbClient
        .rawQuery("SELECT * FROM $tablename where `$field`='$id'");
    return list;
  }

  Future<List<News>> getALlNews() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM news');
    List<News> news = [];
    for (int i = 0; i < list.length; i++) {
      // print(list[i]['newsCategoryID']);
      var newsdata = new News(
          list[i]["newsID"],
          list[i]['newsTitle'],
          list[i]['newsDescription'],
          list[i]['newsDate'],
          list[i]['newsPriority'],
          list[i]['newsCategoryID'],
          list[i]['newsCategoryName'],
          list[i]['newsImage'],
          list[i]['newsImageOrgURL']);

      news.add(newsdata);
    }
    //  print(news.length);
    return news;
  }

  Future<List<Customer>> getAllCustomers() async {
    var dbClient = await db;
    List<Map> list = await dbClient
        .rawQuery('SELECT * FROM customers where customerActive=1');
    List<Customer> customer = [];
    for (int i = 0; i < list.length; i++) {
      var newsdata = new Customer(
          list[i]['customerID'],
          list[i]['firstName'],
          list[i]['lastName'],
          list[i]['customerImage'],
          list[i]['customerImageOrgURL'],
          list[i]['address'],
          list[i]['suburb'],
          list[i]['postCode'],
          list[i]['countryID'],
          list[i]['stateID'],
          list[i]['newsletterSubscribe'],
          list[i]['customerEmail'],
          list[i]['referredBy'],
          list[i]['customerActive'],
          list[i]['customerNotes'],
          list[i]['otherNumber'],
          list[i]['phoneMobile'],
          list[i]['otherEmail'],
          list[i]['imageText'],
          list[i]['favCustomer']);

      customer.add(newsdata);
    }
    print(customer.length);
    return customer;
  }

  Future<List<Booking>> getAllBookings(type) async {
    //  print("RaghuType" + type);
    var dbClient = await db;
    List<Map> list = [];
    if (type == 'Today') {
      list = await dbClient.rawQuery('SELECT * FROM booking');
    } else if (type == 'Completed') {
      list = await dbClient
          .rawQuery("SELECT * FROM booking where bookingType='Completed'");
    } else if (type == 'Cancelled') {
      list = await dbClient
          .rawQuery("SELECT * FROM booking where bookingType='Cancelled'");
    } else if (type == 'Archived') {
      list = await dbClient
          .rawQuery("SELECT * FROM booking where bookingType='Archived'");
    } else {
      list = await dbClient.rawQuery('SELECT * FROM booking');
    }
    List<Booking> booking = [];
    for (int i = 0; i < list.length; i++) {
      var newsdata = new Booking(
          list[i]['bookingID'],
          list[i]['bookingType'],
          list[i]['customerID'],
          list[i]['bookedDate'],
          list[i]['bookedTime'],
          list[i]['bookingComments'],
          list[i]['bookingAddress'],
          list[i]['bookingSuburb'],
          list[i]['bookingPostCode'],
          list[i]['bookingStateID'],
          list[i]['latitude'],
          list[i]['longitude'],
          list[i]['bookingRecurringID'],
          list[i]['bookingCreatedIn'],
          list[i]['bookingLastUpdatedDate']);

      booking.add(newsdata);
    }
    print(booking.length);
    return booking;
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.insert("User", user.toMap());
    return res;
  }

  Future<int> deleteNews(String newsid) async {
    var dbClient = await db;

    await dbClient.rawQuery('DELETE FROM News where newsID="$newsid"');
  }

  Future<List<User>> getUser() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM User');
    List<User> employees = [];
    for (int i = 0; i < list.length; i++) {
      var user = new User(
          list[i]['userID'],
          list[i]['companyID'],
          list[i]['appID'],
          list[i]['userStateID'],
          list[i]['appCountryID'],
          list[i]['userName'],
          list[i]['firstName'],
          list[i]['lastName'],
          list[i]['address1'],
          list[i]['suburb'],
          list[i]['userImage'],
          list[i]['userImageOrgURL'],
          list[i]['userActive'],
          list[i]['timeZone'],
          list[i]['autoExtend'],
          list[i]['apiToken']);
      user.setUserId(list[i]["id"]);
      employees.add(user);
    }
    print(employees.length);
    return employees;
  }

  Future<Country> fetchCountry(String id) async {
    List<Map> results = await _db.query("countries",
        columns: Country.country_columns,
        where: "countryID = ?",
        whereArgs: [id]);
    Country country = Country.fromMap(results.first);

    return country;
  }

  Future<List<Pets>> fetchPets(String id) async {
    List<Map> results = await _db.query("pets",
        columns: Pets.pets_columns, where: "customerID = ?", whereArgs: [id]);

    List<Pets> pets = [];
    results.forEach((result) async {
      Pets pet = Pets.fromMap(result);

      pets.add(pet);
    });

    return pets;
  }

  Future<List<Customer>> fetchCustomers() async {
    var dbClient = await db;

    List<Map> results = await dbClient.rawQuery('SELECT * FROM customers');

    List<Customer> customers = new List();
    results.forEach((result) async {
      Customer customer = Customer.fromMap(result);
      Country countrys = await fetchCountry(customer.countryID);

      customer.country = countrys;
      customers.add(customer);
    });

    return customers;
  }

  Future<Customer> fetchCustomerCountry(int customerid) async {
    List<Map> results = await _db.query("customers",
        columns: Customer.custom_columns,
        where: "customerID = ?",
        whereArgs: [customerid]);

    Customer customer = Customer.fromMap(results[0]);
    // customer.country = await fetchCountry(customer.countryID);

    return customer;
  }

  Future<int> deleteUsers(User user) async {
    var dbClient = await db;

    int res =
        await dbClient.rawDelete('DELETE FROM User WHERE id = ?', [user.id]);
    return res;
  }

  Future<bool> update(User user) async {
    var dbClient = await db;

    int res = await dbClient.update("User", user.toMap(),
        where: "id = ?", whereArgs: <int>[user.id]);

    return res > 0 ? true : false;
  }
}
