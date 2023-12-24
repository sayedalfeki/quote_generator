import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/quote_bloc.dart';
import '../bloc/app_states.dart';
import '../model/quote_model.dart';
import '../widget/helper_widget.dart';
class FavoriteScreen extends StatelessWidget {
  FavoriteScreen({Key? key}) : super(key: key);
  bool search=false;
  @override
  Widget build(BuildContext context) {
    TextEditingController searchController=TextEditingController();
    return BlocProvider(
      create:(context)=> QuoteBloc()..getFavQuotes(),
      child: BlocConsumer<QuoteBloc,AppStates>(
        listener: (context,state){},
        builder:(context,state) {
          QuoteBloc model=QuoteBloc.instance(context);
          model.getFavQuotes();
          return Scaffold(
            body: SafeArea(
              child: Container(
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
                    WrapableContainer
                      (
                      color: const Color.fromRGBO(251, 251, 251,.7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.arrow_back_ios,color: Colors.black,),
                          AppSizedBox(width: 5),
                          TextButton(onPressed:(){
                            Navigator.pop(context);
                          }, child: const AppText('Back To Home Screen'
                              ,fontSize:20,color: Colors.black,fontWeight: FontWeight.normal
                          )),


                        ],
                      ),
                    ),
                    AppSizedBox(),
                    AppTextField(
                        onChanged: (value)
                        {
                          if(value.isEmpty) {
                            model.search = false;
                            model.getFavQuotes();
                          }
                          else {
                            model.search = true;
                            model.searchQuotes(value);
                          }
                        },
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        filledColor: Colors.white,
                        controller: searchController,hint:'',
                        label: 'type some thing here to search...'),
                    AppSizedBox(),
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount:model.search?model.searchedQuotes.length:model.favQuotes.length,
                          itemBuilder:(cont,index) {
                            //model.getFavQuotes();
                            //print(model.favQuotes.length);
                            // model.getQuoteById(cont,model.favQuotes[index]);
                            return Column(
                              children: [
                                QuoteWidget(quoteBloc: model,index: index,search: model.search,),
                                AppSizedBox()
                              ],
                            );
                          }),
                    ),

                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
//

class QuoteWidget extends StatelessWidget
{
  const QuoteWidget({super.key,required this.quoteBloc,required this.index,required this.search});
  final QuoteBloc quoteBloc;
  final int index;
  final bool search;
  @override
  Widget build(BuildContext context) {
    return WrapableContainer(
      padding: 10,
      height: 200,
      radius: 5,
      child: Column(
          children: [
            Expanded(
              child: ListView(
                  children: [AppText(search?quoteBloc.searchedQuotes[index].content:quoteBloc.favQuotes[index].content
                      ,fontWeight: FontWeight.normal
                  ),]
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppText(search?quoteBloc.searchedQuotes[index].author:quoteBloc.favQuotes[index].author,
                    fontSize: 15,
                    color: Colors.grey
                ),

              ],
            ),
            AppSizedBox(),
            WrapableContainer(
              borderColor: const Color.fromRGBO(130, 73, 181, 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_outline_sharp,color: Colors.purple,),
                  AppSizedBox(width: 5),
                  TextButton(onPressed:(){
                    quoteBloc.deleteFromFavorite(search?quoteBloc.searchedQuotes[index].content:quoteBloc.favQuotes[index].content);
                  }, child: const AppText('Remove From Favorite'
                      ,fontSize: 15,color: Colors.purple,
                      fontWeight: FontWeight.normal
                  )),


                ],
              ),
            )
          ]

      ),
    );
  }

}