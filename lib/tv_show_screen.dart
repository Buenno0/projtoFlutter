import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:projeto_final/api_config.dart'; // Supondo que você tenha uma configuração de API semelhante para imagens
import 'package:projeto_final/tv_show_detail_screen.dart';
import 'package:projeto_final/tv_show_service.dart';
import 'models/tv_show.dart';
 // Crie uma tela de detalhes de séries se necessário

class PopularTVShowsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FutureBuilder<List<TVShow>>(
            future: TVShowService.fetchTopRatedTVShows(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erro: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Nenhuma série encontrada'));
              } else {
                final tvShows = snapshot.data!;
                return ListView.builder(
                  itemCount: tvShows.length,
                  itemBuilder: (context, index) {
                    final tvShow = tvShows[index];
                    return TVShowCard(
                      tvShow: tvShow,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TVShowDetailScreen(tvShow: tvShow),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class TVShowCard extends StatelessWidget {
  final TVShow tvShow;
  final VoidCallback onTap;

  const TVShowCard({required this.tvShow, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                imageUrl: '${ApiConfig.imageBaseUrl}${tvShow.posterPath}',
                width: 100,
                height: 150,
                fit: BoxFit.cover,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'tvShowTitle-${tvShow.id}',
                    child: Text(
                      tvShow.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    tvShow.overview,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16.0,
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        '${tvShow.voteAverage}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                    size: 18.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
