class QuoteModel
{
  final int quoteId;
  final String content;
  final String author;
  QuoteModel( {required this.quoteId,required this.author,required this.content});
  Map<String,Object> toMap()
  {
    Map<String,Object> quoteMap=
      {
        'id':quoteId,
       'content':content,
       'author':author
      };
    quoteMap.remove('id');
    return quoteMap;
  }
}