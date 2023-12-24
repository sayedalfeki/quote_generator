
import '../database/quote_database.dart';
import '../helper/const.dart';
import '../model/quote_model.dart';

class QuoteOperation
{
  final _database=QuoteDatabase.instance.database;

  void insert({required QuoteModel model})async {
    final db= await _database;
    db.insert(tableName,model.toMap());
  }


  void delete({required String quoteContent})async {
    final db= await _database;
    db.delete(tableName,where: '$content=?',whereArgs: [quoteContent]);
  }
  Future<List<QuoteModel>> getAllQuotes() async{
    final db= await _database;
    List<QuoteModel> quotesList=[];
    List<Map> quotesMap=await db.query(tableName);
    if(quotesMap.isNotEmpty)
    {
      quotesList=List.generate(quotesMap.length, (index){
        return QuoteModel(content:quotesMap[index][content],
        quoteId: quotesMap[index][id],
          author: quotesMap[index][author]
        );
      });
    }
    return quotesList;
  }
  Future<bool> getQuoteByContent(String quoteContent) async{
    final db= await _database;
    //List<QuoteModel> quotesList=[];
    List<Map> quotesMap=await db.query(tableName,where:'$content=?',whereArgs: [quoteContent] );
    if(quotesMap.isNotEmpty)
    {

        return true;

    }
    else {
      return false;
    }
  }
  Future<List<QuoteModel>> getSearchedQuotes(String word) async
  {
    final db=await _database;
    List<QuoteModel> quotesList=[];
    List <Map> quotesMap=await db.query(tableName,
        where:"$content like'%$word%' or $author like '%$word%'");
    if(quotesMap.isNotEmpty) {
      quotesList= List.generate(quotesMap.length, (index) {
        return QuoteModel(content:quotesMap[index][content],
            quoteId: quotesMap[index][id],
            author: quotesMap[index][author]
        );
      });
    }
    return quotesList;
  }

}