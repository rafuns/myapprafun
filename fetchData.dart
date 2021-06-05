import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:franchisecare/models/CalendarEntry.dart';
import 'package:franchisecare/models/activity.dart';
import 'package:http/http.dart' as http;

import 'package:franchisecare/common/constants.dart';
import 'package:localstorage/localstorage.dart';
import 'package:franchisecare/common/database.dart';
import 'package:franchisecare/models/news.dart';
import 'package:franchisecare/models/booking.dart';
import 'package:franchisecare/models/pets.dart';
import 'package:franchisecare/models/state.dart';
import 'package:franchisecare/models/country.dart';
import 'package:franchisecare/models/petservice.dart';
import 'package:franchisecare/models/customer.dart';
import 'package:franchisecare/models/income.dart';
import 'package:franchisecare/models/incomeCategory.dart';
import 'package:franchisecare/models/expense.dart';

import 'package:franchisecare/models/ExpenseCategory.dart';

import 'package:shared_preferences/shared_preferences.dart';

class DataAPi {
  // Login
  final LocalStorage storage = new LocalStorage('franchiseapp');
  var db = new DatabaseHelper();
  Future<int> checkifloaded() async {
    int dataloadcount = 0;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    dataloadcount = prefs.getInt('dataloadcount');
    print(dataloadcount);

    return dataloadcount;
  }

  fetchAllNews() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    // prefs.setInt('dataloadcount', 1);
    print("reached here");
    String columnUserId = prefs.getString('userID');
    String columncompanyID = prefs.getString('companyID');
    String columnApiToken = prefs.getString('apiToken');
    String columnAppId = prefs.getString('appID');
    String source = columnAppId + "_" + columncompanyID + "_" + columnUserId;
    // String apiurl = "$NEWS_URL"; //api url

    var news = await http.post(Uri.parse("$NEWS_URL"), body: {
      'action': 'latest_news',
      'api_token': "$columnApiToken",
      'source': "$source", //get password text
    });

    var newsdata = json.decode(news.body);
    //print(newsdata['data']);
    //storage.setItem('newsdata', "raghu");

    for (var newsi in newsdata["data"]) {
      // print(newsi["newsID"]);

      var newsdata = new News(
          newsi["newsID"],
          newsi['newsTitle'],
          newsi['newsDescription'],
          newsi['newsDate'],
          newsi['newsPriority'],
          newsi['newsCategoryID'],
          newsi['newsCategoryName'],
          newsi['newsImage'],
          newsi['newsImageOrgURL']);

      var counts = await db.getNews(newsi["newsID"]);
      if (counts < 1) {
        int id = await db.saveNews(newsdata);
        // final id = await dbHelper.insert(row);
        print('inserted row id: $id');
      } else {
        print("news exists");
      }
    }

    //await prefs.setString('newsdata', json.decode(newsdata['data']));
  }

  fetchAllBookings() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    // prefs.setInt('dataloadcount', 1);

    String columnUserId = prefs.getString('userID');
    String columncompanyID = prefs.getString('companyID');
    String columnApiToken = prefs.getString('apiToken');
    String columnAppId = prefs.getString('appID');
    String source = columnAppId + "_" + columncompanyID + "_" + columnUserId;
    // String apiurl = "$NEWS_URL"; //api url

    var news = await http.post(Uri.parse("$ALL_BOOKING_URL"), body: {
      'action': 'booking_all',
      'api_token': "$columnApiToken",
      'source': "$source", //get password text
    });

    var data = json.decode(news.body);
    //print(newsdata['data']);
    //storage.setItem('newsdata', "raghu");

    for (var map in data["data"]) {
      // print(newsi["newsID"]);

      var pushdata = new Booking(
        map['bookingID'],
        map['bookingType'],
        map['customerID'],
        map['bookedDate'],
        map['bookedTime'],
        map['bookingComments'],
        map['bookingAddress'],
        map['bookingSuburb'],
        map['bookingPostCode'],
        map['bookingStateID'],
        map['latitude'],
        map['longitude'],
        map['bookingRecurringID'],
        map['bookingCreatedIn'],
        map['bookingLastUpdatedDate'],
      );

      var counts = await db.getData("booking", "bookingID", map["bookingID"]);

      if (counts < 1) {
        int id = await db.saveData("booking", pushdata);
        print('inserted row id: Booking $id');
        for (var map1 in map['bookingDetail']) {
          var bookingdetail = new BookingDetail(map['bookingID'],
              map1["itemID"], map1["serviceID"], map1["servicePrice"]);
          int idbkd = await db.saveData("bookingdetail", bookingdetail);
          print('inserted row id: BookingDetail $idbkd');
        }

        // final id = await dbHelper.insert(row);

      } else {
        print("booking exists");
      }
    }
    //await prefs.setString('newsdata', json.decode(newsdata['data']));
  }

  fetchAllPets() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    // prefs.setInt('dataloadcount', 1);

    String columnUserId = prefs.getString('userID');
    String columncompanyID = prefs.getString('companyID');
    String columnApiToken = prefs.getString('apiToken');
    String columnAppId = prefs.getString('appID');
    String source = columnAppId + "_" + columncompanyID + "_" + columnUserId;
    // String apiurl = "$NEWS_URL"; //api url

    var news = await http.post(Uri.parse("$PETS_URl"), body: {
      'action': 'all_pets',
      'api_token': "$columnApiToken",
      'source': "$source", //get password text
    });

    var jsondata = json.decode(news.body);
    //print(newsdata['data']);
    //storage.setItem('newsdata', "raghu");

    for (var data in jsondata["data"]) {
      // print(newsi["newsID"]);

      var pushdata = new Pets(
          data['itemID'],
          data['customerID'],
          data['itemName'],
          data['itemBirthYear'],
          data['itemBirthMonth'],
          data['itemBirthDay'],
          data['itemBreed'],
          data['itemColor'],
          data['itemGenderID'],
          data['itemGenderName'],
          data['itemActive'],
          data['itemNotes'],
          data['itemImage']);

      var counts = await db.getData("pets", "itemID", data["itemID"]);

      if (counts < 1) {
        int id = await db.saveData("pets", pushdata);
        print('inserted row id: Pet: $id');

        // final id = await dbHelper.insert(row);

      } else {
        print("Pet exists");
      }
    }
    //await prefs.setString('newsdata', json.decode(newsdata['data']));
  }

  fetchAllStates() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    // prefs.setInt('dataloadcount', 1);

    String columnUserId = prefs.getString('userID');
    String columncompanyID = prefs.getString('companyID');
    String columnApiToken = prefs.getString('apiToken');
    String columnAppId = prefs.getString('appID');
    String source = columnAppId + "_" + columncompanyID + "_" + columnUserId;
    // String apiurl = "$NEWS_URL"; //api url

    var news = await http.post(Uri.parse("$STATES_URL"), body: {
      'action': 'all_states',
      'api_token': "$columnApiToken",
      'source': "$source", //get password text
    });

    var jsondata = json.decode(news.body);
    //print(newsdata['data']);
    //storage.setItem('newsdata', "raghu");

    for (var data in jsondata["data"]) {
      var pushdata = new State(
        data['stateID'],
        data['stateName'],
        data['stateShortName'],
        data['countryID'],
      );

      var counts = await db.getData("states", "stateID", data["stateID"]);

      if (counts < 1) {
        int id = await db.saveData("states", pushdata);
        print('inserted row id: State: $id');

        // final id = await dbHelper.insert(row);

      } else {
        print("State exists");
      }
    }
    //await prefs.setString('newsdata', json.decode(newsdata['data']));
  }

  fetchAllCountries() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    // prefs.setInt('dataloadcount', 1);

    String columnUserId = prefs.getString('userID');
    String columncompanyID = prefs.getString('companyID');
    String columnApiToken = prefs.getString('apiToken');
    String columnAppId = prefs.getString('appID');
    String source = columnAppId + "_" + columncompanyID + "_" + columnUserId;
    // String apiurl = "$NEWS_URL"; //api url

    var news = await http.post(Uri.parse("$COUNTRY_URL"), body: {
      'action': 'all_countries',
      'api_token': "$columnApiToken",
      'source': "$source", //get password text
    });

    var jsondata = json.decode(news.body);
    //print(newsdata['data']);
    //storage.setItem('newsdata', "raghu");

    for (var data in jsondata["data"]) {
      var pushdata = new Country(
        data['countryID'],
        data['countryName'],
        data['countryShortName'],
      );

      var counts =
          await db.getData("countries", "countryID", data["countryID"]);

      if (counts < 1) {
        int id = await db.saveData("countries", pushdata);
        print('inserted row id: Country: $id');

        // final id = await dbHelper.insert(row);

      } else {
        print("Country exists");
      }
    }
    //await prefs.setString('newsdata', json.decode(newsdata['data']));
  }

  fetchAllCustomers() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    // prefs.setInt('dataloadcount', 1);

    String columnUserId = prefs.getString('userID');
    String columncompanyID = prefs.getString('companyID');
    String columnApiToken = prefs.getString('apiToken');
    String columnAppId = prefs.getString('appID');
    String source = columnAppId + "_" + columncompanyID + "_" + columnUserId;
    // String apiurl = "$NEWS_URL"; //api url

    var news = await http.post(Uri.parse("$CUSTOMERS_URL"), body: {
      'action': 'all_customers',
      'api_token': "$columnApiToken",
      'source': "$source", //get password text
    });

    var jsondata = json.decode(news.body);
    //print(newsdata['data']);
    //storage.setItem('newsdata', "raghu");

    for (var data in jsondata["data"]) {
      var pushdata = new Customer(
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

      var counts =
          await db.getData("customers", "customerID", data["customerID"]);

      if (counts < 1) {
        int id = await db.saveData("customers", pushdata);
        print('inserted row id: Customer: $id');

        // final id = await dbHelper.insert(row);

      } else {
        print("Customer exists");
      }
    }
    //await prefs.setString('newsdata', json.decode(newsdata['data']));
  }

  fetchAllCalendarEntries() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    String columnUserId = prefs.getString('userID');
    String columncompanyID = prefs.getString('companyID');
    String columnApiToken = prefs.getString('apiToken');
    String columnAppId = prefs.getString('appID');
    String source = columnAppId + "_" + columncompanyID + "_" + columnUserId;
    // String apiurl = "$NEWS_URL"; //api url

    var news = await http.post(Uri.parse("$CALENDAR_URL"), body: {
      'action': 'calendar_entries',
      'api_token': "$columnApiToken",
      'source': "$source", //get password text
    });

    var jsondata = json.decode(news.body);
    //print(newsdata['data']);
    //storage.setItem('newsdata', "raghu");

    for (var data in jsondata["data"]) {
      var pushdata = new CalendarEntry(
          data['calendarEntryID'],
          data['bookingID'],
          data['customerID'],
          data['blockID'],
          data['entryType'],
          data['startDate'],
          data['startTime'],
          data['endDate'],
          data['endTime'],
          data['calendarTitle'],
          data['calendarDescription'],
          data['customerName'],
          data['customerAddress'],
          data['recurringID'],
          data['calendarBGcolor'],
          data['bookingType']);

      var counts = await db.getData(
          "calendarentries", "calendarEntryID", data["calendarEntryID"]);

      if (counts < 1) {
        int id = await db.saveData("calendarentries", pushdata);
        print('inserted row id: calendarentries: $id');

        // final id = await dbHelper.insert(row);

      } else {
        print("calendarentries exists");
      }
    }
    //await prefs.setString('newsdata', json.decode(newsdata['data']));
  }

  fetchAllPetServices() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    // prefs.setInt('dataloadcount', 1);

    String columnUserId = prefs.getString('userID');
    String columncompanyID = prefs.getString('companyID');
    String columnApiToken = prefs.getString('apiToken');
    String columnAppId = prefs.getString('appID');
    String source = columnAppId + "_" + columncompanyID + "_" + columnUserId;
    // String apiurl = "$NEWS_URL"; //api url

    var news = await http.post(Uri.parse("$SERVICE_URL"), body: {
      'action': 'pet_services',
      'api_token': "$columnApiToken",
      'source': "$source", //get password text
    });

    var jsondata = json.decode(news.body);
    //print(newsdata['data']);
    //storage.setItem('newsdata', "raghu");

    for (var data in jsondata["data"]) {
      var pushdata = new PetsService(
          data['systemServiceID'],
          data['ServiceName'],
          data['systemServicePrice'],
          data['systemServiceDuration'],
          data['memberServiceColor'],
          data['displayPosition'],
          data['memberServicePrice'],
          data['memberServiceDuration']);

      var counts = await db.getData(
          "petservices", "systemServiceID", data["systemServiceID"]);

      if (counts < 1) {
        int id = await db.saveData("petservices", pushdata);
        print('inserted row id: Petservice: $id');

        // final id = await dbHelper.insert(row);

      } else {
        print("Petservice exists");
      }
    }
    //await prefs.setString('newsdata', json.decode(newsdata['data']));
  }

  fetchAllIncomes() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    // prefs.setInt('dataloadcount', 1);

    String columnUserId = prefs.getString('userID');
    String columncompanyID = prefs.getString('companyID');
    String columnApiToken = prefs.getString('apiToken');
    String columnAppId = prefs.getString('appID');
    String source = columnAppId + "_" + columncompanyID + "_" + columnUserId;
    // String apiurl = "$NEWS_URL"; //api url

    var news = await http.post(Uri.parse("$INCOME_URL"), body: {
      'action': 'get_income',
      'api_token': "$columnApiToken",
      'source': "$source", //get password text
    });

    var jsondata = json.decode(news.body);
    //print(newsdata['data']);
    //storage.setItem('newsdata', "raghu");

    for (var data in jsondata["data"]) {
      var pushdata = new Income(
          data['incomeEntryID'],
          data['incomeCategoryName'],
          data['incomeCategoryID'],
          data['incomeTitle'],
          data['incomeAmount'],
          data['incomeDescription'],
          data['incomeDate'],
          data['incomeActive'],
          data['isIncomeRecurring']);

      var counts =
          await db.getData("income", "incomeEntryID", data["incomeEntryID"]);

      if (counts < 1) {
        int id = await db.saveData("income", pushdata);
        print('inserted row id: Income: $id');

        // final id = await dbHelper.insert(row);

      } else {
        print("Income exists");
      }
    }
    //await prefs.setString('newsdata', json.decode(newsdata['data']));
  }

  fetchAllIncomeCategory() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    // prefs.setInt('dataloadcount', 1);

    String columnUserId = prefs.getString('userID');
    String columncompanyID = prefs.getString('companyID');
    String columnApiToken = prefs.getString('apiToken');
    String columnAppId = prefs.getString('appID');
    String source = columnAppId + "_" + columncompanyID + "_" + columnUserId;
    // String apiurl = "$NEWS_URL"; //api url

    var news = await http.post(Uri.parse("$INCOME_CAT_URL"), body: {
      'action': 'income_categories',
      'api_token': "$columnApiToken",
      'source': "$source", //get password text
    });

    var jsondata = json.decode(news.body);
    //print(newsdata['data']);
    //storage.setItem('newsdata', "raghu");

    for (var data in jsondata["data"]) {
      var pushdata = new IncomeCategory(
          data['incomeCategoryID'],
          data['incomeCategoryName'],
          data['incomeCategoryDescription'],
          data['incomeCategoryEntryCount'],
          data['incomeCategoryActive'],
          data['incomeCategoryAddedBy']);

      var counts = await db.getData(
          "incomecategory", "incomeCategoryID", data["incomeCategoryID"]);

      if (counts < 1) {
        int id = await db.saveData("incomecategory", pushdata);
        print('inserted row id: Income Category: $id');

        // final id = await dbHelper.insert(row);

      } else {
        print("Income Category exists");
      }
    }
    //await prefs.setString('newsdata', json.decode(newsdata['data']));
  }

  fetchAllExpenseCategory() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    // prefs.setInt('dataloadcount', 1);

    String columnUserId = prefs.getString('userID');
    String columncompanyID = prefs.getString('companyID');
    String columnApiToken = prefs.getString('apiToken');
    String columnAppId = prefs.getString('appID');
    String source = columnAppId + "_" + columncompanyID + "_" + columnUserId;
    // String apiurl = "$NEWS_URL"; //api url

    var news = await http.post(Uri.parse("$EXPENSE_CAT_URL"), body: {
      'action': 'expense_categories',
      'api_token': "$columnApiToken",
      'source': "$source", //get password text
    });

    var jsondata = json.decode(news.body);
    //print(newsdata['data']);
    //storage.setItem('newsdata', "raghu");

    for (var data in jsondata["data"]) {
      var pushdata = new ExpenseCategory(
          data['expenseSuperCategoryID'],
          data['expenseSuperCategoryName'],
          data['expenseCategoryID'],
          data['expenseCategoryName'],
          data['expenseCategoryDescription'],
          data['expenseCategoryEntryCount']);

      var counts = await db.getData(
          "expensecategory", "expenseCategoryID", data["expenseCategoryID"]);

      if (counts < 1) {
        int id = await db.saveData("expensecategory", pushdata);
        print('inserted row id: Expense Category: $id');

        // final id = await dbHelper.insert(row);

      } else {
        print("Income Expense exists");
      }
    }
    //await prefs.setString('newsdata', json.decode(newsdata['data']));
  }

  fetchAllExpenses() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    // prefs.setInt('dataloadcount', 1);

    String columnUserId = prefs.getString('userID');
    String columncompanyID = prefs.getString('companyID');
    String columnApiToken = prefs.getString('apiToken');
    String columnAppId = prefs.getString('appID');
    String source = columnAppId + "_" + columncompanyID + "_" + columnUserId;
    // String apiurl = "$NEWS_URL"; //api url

    var news = await http.post(Uri.parse("$EXPENSES_URL"), body: {
      'action': 'get_expenses',
      'api_token': "$columnApiToken",
      'source': "$source", //get password text
    });

    var jsondata = json.decode(news.body);
    //print(newsdata['data']);
    //storage.setItem('newsdata', "raghu");

    for (var data in jsondata["data"]) {
      var pushdata = new Expenses(
        data['expenseEntryID'],
        data['expenseSuperCategoryName'],
        data['expenseSuperCategoryID'],
        data['expenseCategoryName'],
        data['expenseCategoryID'],
        data['expenseTitle'],
        data['expenseAmount'],
        data['expenseDescription'],
        data['expenseDate'],
        data['expenseAttachmentURLThumbnail'],
        data['expenseAttachmentURL'],
        data['expenseActive'],
        data['isExpenseRecurring'],
      );

      var counts =
          await db.getData("expense", "expenseEntryID", data["expenseEntryID"]);

      if (counts < 1) {
        int id = await db.saveData("expense", pushdata);
        print('inserted row id: Expense: $id');

        // final id = await dbHelper.insert(row);

      } else {
        print("Expense exists");
      }
    }
    //await prefs.setString('newsdata', json.decode(newsdata['data']));
  }

  fetchAllActivity() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    // prefs.setInt('dataloadcount', 1);

    String columnUserId = prefs.getString('userID');
    String columncompanyID = prefs.getString('companyID');
    String columnApiToken = prefs.getString('apiToken');
    String columnAppId = prefs.getString('appID');
    String source = columnAppId + "_" + columncompanyID + "_" + columnUserId;
    // String apiurl = "$NEWS_URL"; //api url

    var news = await http.post(Uri.parse("$ACTIVITY_URL"), body: {
      'action': 'activities',
      'api_token': "$columnApiToken",
      'source': "$source", //get password text
    });

    var jsondata = json.decode(news.body);
    //print(newsdata['data']);
    //storage.setItem('newsdata', "raghu");

    for (var data in jsondata["data"]) {
      var pushdata = new Activity(data['activityID'], data['activityDetail'],
          data['activityType'], data['activityFrom']);

      var counts =
          await db.getData("activity", "activityID", data["activityID"]);

      if (counts < 1) {
        int id = await db.saveData("activity", pushdata);
        print('inserted row id: Activity: $id');

        // final id = await dbHelper.insert(row);

      } else {
        print("Income Activity exists");
      }
    }
    //await prefs.setString('newsdata', json.decode(newsdata['data']));
  }
}
