import 'package:gsheets/gsheets.dart';
import 'package:ieee_qr_code/api/sheets/sheets_api_credentials.dart';

class SheetsApi {
  // api key credentials
  static const _credentials = sheetsKey;

  static late Spreadsheet spreadsheet;
  static late List<Worksheet> workSheets;

  // Extracts id from the part of the url that is between d/ and /edit
  static String? getSheetIdFromUrl(String url) {
    var re = RegExp(r'(?<=d/)(.*)(?=/edit)');
    var match = re.firstMatch(url);

    if (match == null || match.group(0) == null) {
      return "ID not found";
    }
    else {
      return match.group(0);
    }
  }

  // Inits the sheet variables that as in selects which sheet is used basically
  static void init(String? ssID) async {
    // Handles empty sheet id
    if (ssID!.isEmpty){
      print("Error: SpreadSheet id is empty");
      return;
    }

    final gsheets = GSheets(_credentials);
    // Grabs sheet by it's ID
    spreadsheet = await gsheets.spreadsheet(ssID);
    // Grabs work sheets within the sheet
    workSheets = spreadsheet.sheets;

    Worksheet? test = spreadsheet.worksheetByTitle("test");
    int n = await getRowByValues(test, [3, 8], ["Seif Eldin Abd Elmoniem Shaheen", "01144784159"]);
    setCheckBoxCellTrue(test, 1, n);
  }

  // Gets a list of the titles from the worksheet objects
  static List<String>? getWorkSheetsTitles(List<Worksheet> ws) {
    List<String> workSheetsTitles = [];

    // Handles empty worksheet
    if (ws.isEmpty) {
      print("work sheets list is empty");
      return workSheetsTitles;
    }

    // Appends the titles to the worksheetTitle list
    for (Worksheet workSheet in ws) {
      print(workSheet.title);
      workSheetsTitles.add(workSheet.title);
    }

    return workSheetsTitles;
  }

  // Sets the checkbox as true
  static void setCheckBoxCellTrue(Worksheet? ws, int columnIndex, int rowIndex) async{
    // Handles worksheet not existing
    if (ws == null) {
      print("work sheet doesn;t exist");
      return;
    }

    // Check that the cell isnt out of bounds
    if (ws.columnCount < columnIndex || ws.rowCount < rowIndex || rowIndex < 1 || columnIndex < 1) {
      print("Coordinates of cell out of bounds");
      return;
    }

    // Makes sure the field is false already so it doesn't override non checkbox fields
    if (await ws.values.value(column: columnIndex, row: rowIndex) == 'false') {
      ws.values.insertValue("true", column: columnIndex, row: rowIndex);
    }
  }

  // This function takes a list of columns to search through with the list of values and returns the row that matches all values in the columns
  static Future<int> getRowByValues(Worksheet? ws, List<int> searchColumnIndex, List<String> searchColumnValue) async{
    // Handles worksheet not existing
    if (ws == null) {
      print("work sheet doesn't exist");
      return -1;
    }

    // Checks if the amount of columns and values are an exact match
    if (searchColumnIndex.length != searchColumnValue.length) {
      print("Values don't match the amount of columns");
      return -1;
    }

    // Checks if the columns arent out of bounds
    if (ws.columnCount < searchColumnIndex.length) {
      print("Coordinates of columns out of bounds");
      return -1;
    }

    int rowCount = ws.rowCount;
    int numberOfSearchParameters = searchColumnValue.length;

    List<List<String>> allRows = await ws.values.allRows();
    List<String> row;

    int foundCount = 0;
    // The count starts with 1 since the first row starts with 1 not 0
    for (int i = 1; i <= rowCount; i++) {
      row = allRows[i];

      // Checks if we reached a dummy or empty row
      if (row.length < numberOfSearchParameters) {
        print("Entry not found");
        return -1;
      }

      foundCount = 0;
      // Checks values in each row against the search parameters
      for (int j = 0; j < searchColumnIndex.length; j++) {
        // The reason i subtract one since the user enters the column index which starts with 1 but the array is indexed from 0
        if (row[searchColumnIndex[j]-1] == searchColumnValue[j]) {
          // This variable keeps count of how many values match
          foundCount++;
        }
      }

      if (foundCount == searchColumnIndex.length) {
        print("found!!");
        return i;
      }
    }
    print("Entry not found");
    return -1;
  }
}