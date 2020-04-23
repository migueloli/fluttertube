import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/blocs/favorite_bloc.dart';
import 'package:fluttertube/blocs/videos_blocs.dart';
import 'package:fluttertube/delegates/data_search.dart';
import 'package:fluttertube/models/video.dart';
import 'package:fluttertube/screens/favorites.dart';
import 'package:fluttertube/widgets/video_tile.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.getBloc<VideosBloc>();

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Container(
          height: 25,
          child: Image.asset("images/youtube.png"),
          color: Colors.black87,
        ),
        elevation: 0,
        backgroundColor: Colors.black87,
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
              stream: BlocProvider.getBloc<FavoriteBloc>().outFav,
              initialData: {},
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return Text("${snapshot.data.length}");
                }else{
                  return Container();
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Favorites())
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              String result = await showSearch(
                context: context,
                delegate: DataSearch()
              );

              if(result != null){
                bloc.inSearch.add(result);
              }
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: bloc.outVideos,
        initialData: [],
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Container();
          }
          return ListView.builder(
            itemCount: snapshot.data.length+1,
            itemBuilder: (context, index) {
              if(index < snapshot.data.length) {
                return VideoTile(snapshot.data[index]);
              }else if(index > 1){
                bloc.inSearch.add(null);
                return Container(
                  height: 40,
                  width: 40,
                  margin: EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.red
                    ),
                  ),
                );
              }else{
                return Container();
              }
            },
          );
        },
      ),
    );
  }
}
