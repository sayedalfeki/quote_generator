import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/quote_bloc.dart';
import '../bloc/app_states.dart';
import '../helper/const.dart';
import '../view/favorite_screen.dart';
import '../widget//helper_widget.dart';
import '../../model/quote_model.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>QuoteBloc()..getRandomQuote(context)..getFavQuotes(),
      child: BlocConsumer<QuoteBloc,AppStates>(
        listener: ( context, state) {  },
        builder:(context,state) {
          QuoteBloc model=QuoteBloc.instance(context);
          model.getFavQuotes();
          return Scaffold(
            body: Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Color.fromRGBO(93, 19, 231, 1),
                      Color.fromRGBO(130, 73, 181, 1)]),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HomeStack(favQuotes: model.favQuotes,),
                  AppSizedBox(),
                  QuoteWidget(quoteBloc: model,)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
class HomeStack extends StatelessWidget
{
  const HomeStack({super.key,required this.favQuotes});
  final List<QuoteModel> favQuotes;
  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Stack(
            alignment: Alignment.topRight,
            children: [
              WrapableContainer(
                  radius: 5,
                  color: Color.fromRGBO(251, 251, 251,.7),
                  child: TextButton(
                      onPressed: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>FavoriteScreen()));
                      },
                      child: const AppText('click here to view favorite quotes',fontWeight: FontWeight.normal))),

              Positioned(
                top: 0,
                right: 1,
                child: Transform.translate(
                  offset: const Offset(8, -20),
                  child: WrapableContainer
                    (
                      height: 30,
                      width: 30,
                      radius: 30,
                      color: const Color.fromRGBO(50, 50, 50, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText('${favQuotes.length}',color: Colors.white),
                        ],
                      )),
                ),
              )
            ]

        ),
      ],
    );
  }

}

class QuoteWidget extends StatelessWidget
{
  const QuoteWidget({super.key,required this.quoteBloc});
  final QuoteBloc quoteBloc;
  @override
  Widget build(BuildContext context) {
    if( quoteBloc.quoteMap.isNotEmpty) {
      quoteBloc.getQuoteByContent(quoteBloc.quoteMap[content]);
    }
    return quoteBloc.quoteMap.isEmpty||quoteBloc.quoteMap[content]==null?const Center(child: CircularProgressIndicator()):
    WrapableContainer(
      padding: 10,
      height: 200,
      radius: 5,
      child: Column(
          children: [
            Expanded(
              child: ListView(
                  children:[ AppText(quoteBloc.quoteMap['content']
                      ,fontWeight: FontWeight.normal
                  ),
                  ]
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppText(quoteBloc.quoteMap['author'],
                    fontSize: 15,
                    color: Colors.grey
                ),

              ],
            ),
            AppSizedBox(),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: WrapableContainer(
                      radius: 5,
                      color: const Color.fromRGBO(130, 73, 181, 1),
                      child: TextButton(onPressed:(){
                        quoteBloc.getRandomQuote(context);
                      }, child: const AppText('Generate Another Quote'
                          ,fontSize: 15,color: Colors.white
                      ))),
                ),
                AppSizedBox(width: 5),
                Expanded(
                  flex: 1,
                  child: WrapableContainer(
                      radius: 5,
                      color: Colors.white,
                      child: IconButton(onPressed:()async{
                        QuoteModel model=QuoteModel(quoteId:1,
                            author: quoteBloc.quoteMap[author],
                            content: quoteBloc.quoteMap[content]);
                        if(quoteBloc.addedToFavorite)
                        {
                          quoteBloc.deleteFromFavorite(quoteBloc.quoteMap[content]);
                        }
                        else {
                          quoteBloc.addQuoteToFavorite(model);
                        }
                        }, icon:Icon(quoteBloc.addedToFavorite?Icons.favorite:Icons.favorite_outline_sharp,color: Colors.purple,))),
                )
              ],
            )
          ]

      ),
    );
  }

}
