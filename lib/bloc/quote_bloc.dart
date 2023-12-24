import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/app_states.dart';
import '../database/quote_operation.dart';
import '../model/quote_model.dart';

class QuoteBloc extends Cubit<AppStates>
{
  QuoteBloc():super(InitState());
  static QuoteBloc instance(BuildContext context)=>BlocProvider.of(context);
  String baseURL='https://api.quotable.io';
  String favoriteQuotesKey='favorite_quotes';
  QuoteOperation quoteOperation=QuoteOperation();
  Dio dio=Dio();
  Map quoteMap={};
  Map favoriteQuoteMap={};
  List<QuoteModel> favQuotes=[];
  List<QuoteModel> searchedQuotes=[];
  bool addedToFavorite=false;
  bool search=false;
  addQuoteToFavorite(QuoteModel model)
  {
    quoteOperation.insert(model: model);
    addedToFavorite=true;
    emit(AddToFavorite());
  }
  deleteFromFavorite(String content)
  {
    quoteOperation.delete(quoteContent:content);
    addedToFavorite=false;
    emit(RemoveFromFavorite());
  }
  getFavQuotes()async
  {
    favQuotes=await quoteOperation.getAllQuotes();
    emit(FavoriteQuotes());
  }
  getQuoteByContent(String content)async
  {
    addedToFavorite=await quoteOperation.getQuoteByContent(content);
    emit(AddToFavorite());
  }

  getRandomQuote(BuildContext context)async
  {
    try {

      Response response = await dio.get('$baseURL/random');
      if (response.statusCode == 200) {
        quoteMap = response.data;
      }
      emit(RandomQuoteState());
    }
    catch(e)
    {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())));
    }
  }
  searchQuotes(String word)async
  {
    searchedQuotes=await quoteOperation.getSearchedQuotes(word);
    emit(SearchState());
  }
}