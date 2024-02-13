import 'package:gsheets/gsheets.dart';
import 'package:ieee_qr_code/api/sheets/sheets_api_credentials.dart';

class SheetsApi {
  // api key credentials
  static const _credentials = sheetsKey;

  static late Spreadsheet spreadsheet;
  static late List<Worksheet> workSheets;

  static Future<bool> scanQRtoSheet(String? ssID, String workSheet, String data, List<int> searchColumnIndex, int checkColumn) async {
    // Inits the connection with the sheet
    if (!await init(ssID)) {
      return false;
    }
    Worksheet? ws = spreadsheet.worksheetByTitle(workSheet);
    int rowIndex = await getRowByValues(ws, searchColumnIndex, data.split(","));
    if (rowIndex != -1){
      setCheckBoxCellTrue(spreadsheet.worksheetByTitle(workSheet), checkColumn, rowIndex+1);
      return true;
    }
    else {
      return false;
    }
  }

  static Future<bool> addQRtoSheet(String? ssID, String workSheet, List<int> qrParameterColumns) async {
    // Inits the connection with the sheet
    if (!await init(ssID)) {
    return false;
    }
    Worksheet? ws = spreadsheet.worksheetByTitle(workSheet);

    // Handles worksheet not existing
    if (ws == null) {
      print("work sheet doesn't exist");
      return false;
    }

    // Checks if the columns arent out of bounds
    if (ws.columnCount < qrParameterColumns.length) {
      print("Coordinates of columns out of bounds");
      return false;
    }

    bool insertCheck = false;
    // Grabs all the rows
    List<List<String>> allRows = await ws.values.allRows();
    List<String> row;
    int targetColumn = allRows[0].length+1;
    String qrImageData;
    String qrKey;

    for(int i = 1; i < allRows.length; i++) {
      qrImageData = ""; // This variable gets the to be encoded data added to it
      row = allRows[i];

      for (int j = 0; j < qrParameterColumns.length; j++) {
        qrImageData += '${row[qrParameterColumns[j]-1]},';
      }
      // Removes the comma at the end
      qrImageData = qrImageData.substring(0, qrImageData.length-1);
      qrKey = "=ENCODEURL(\"$qrImageData\")";
      insertCheck = await ws.values.insertValue(qrKey, column: targetColumn, row: i+1);
      if(!insertCheck) {return false;}
    }

    return true;
  }

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
  static Future<bool> init(String? ssID) async {
    // Handles empty sheet id
    if (ssID!.isEmpty){
      print("Error: SpreadSheet id is empty");
      return false;
    }

    final gsheets = GSheets(_credentials);
    // Grabs sheet by it's ID
    spreadsheet = await gsheets.spreadsheet(ssID);
    // Grabs work sheets within the sheet
    workSheets = spreadsheet.sheets;
    return true;
  }

  // Converts Header name to index
  static Future<int> headerNameToIndex(String? ssID, String workSheet,String name) async {
    if (ssID!.isEmpty){
      print("Error: SpreadSheet id is empty");
      return -1;
    }
    final gsheets = GSheets(_credentials);
    spreadsheet = await gsheets.spreadsheet(ssID);
    Worksheet? ws = spreadsheet.worksheetByTitle(workSheet);
    List<String>? headerRow = await ws?.values.row(1);
    return headerRow!.indexOf(name)+1;
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