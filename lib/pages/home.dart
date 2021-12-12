import 'dart:async';

import 'package:appreservations/models/businesssnippet.dart';
import 'package:appreservations/models/reservation.dart';
import 'package:appreservations/models/user.dart';
import 'package:appreservations/pages/splash.dart';
import 'package:appreservations/services/business_snp_bloc.dart';
import 'package:appreservations/services/get_business_snippets.dart';
import 'package:appreservations/services/get_user.dart';
import 'package:appreservations/services/home_bloc.dart';
import 'package:appreservations/services/reservations_bloc.dart';
import 'package:appreservations/utils/date_utils.dart';
import 'package:appreservations/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:shimmer_image/shimmer_image.dart';

class AppHome extends StatefulWidget {
  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  final storage = new FlutterSecureStorage();
  final snippetsBlock = BusinessSnpBloc();
  final reservationsBlock = ReservationsBloc();
  final dateUtils = DateUtilities();

  @override
  void initState() {
    super.initState();

    /* trigger data fetching */
    snippetsBlock.eventStreamSink.add(ApiAction.Fetch);
    reservationsBlock.eventStreamSink.add(ApiAction.Fetch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Main Feed'),
        centerTitle: false,
        backgroundColor: Colors.grey[850],
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person),
            label: Text('Log out'),
            onPressed: () => {
              storage.delete(key: "jwt"),
              Navigator.pushReplacementNamed(context, '/login')
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
              child: Text(
                "Rezervari",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20),
              ),
            ),
          ),
          SizedBox(
              height: 80,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                child: StreamBuilder<List<Reservation>>(
                  stream: reservationsBlock.snippetsStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          snapshot.error as String,
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            var reservation = snapshot.data![index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 5,
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      /*gradient: LinearGradient(
                                        colors: [Colors.greenAccent, Colors.green],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight
                                      )*/
                                      color: Color(0xD8000000)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text(
                                            reservation.businessName,
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            dateUtils.convertTimestamp(
                                                reservation.timestampDue),
                                            style: TextStyle(
                                                color: Colors.white70),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    } else {
                      return Text('loading');
                    }
                  },
                ),
              )),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
              child: Text(
                "Servicii",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20),
              ),
            ),
          ),
          Expanded(
            child: Padding(
                padding: EdgeInsets.all(16),
                child: StreamBuilder<List<BusinessSnippet>>(
                  stream: snippetsBlock.snippetsStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          snapshot.error as String,
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var article = snapshot.data![index];
                            return Container(
                              height: 100,
                              margin: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Card(
                                    clipBehavior: Clip.antiAlias,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    child: AspectRatio(
                                        aspectRatio: 1,
                                        child: /*Image.network(
                                          article.businessImgUrl,
                                          fit: BoxFit.cover,
                                        )*/
                                            ProgressiveImage(
                                          image: article.businessImgUrl,
                                          width: 100,
                                          height: 100,
                                        )),
                                    elevation: 2,
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Flexible(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Strada Pulii nr. 16",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        article.businessName,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SmoothStarRating(
                                              allowHalfRating: false,
                                              starCount: 5,
                                              rating: article.rating,
                                              color: Colors.amber,
                                              isReadOnly: true,
                                              borderColor: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ))
                                ],
                              ),
                            );
                          });
                    } else {
                      return /*ShimmerHome()*/
                          SizedBox(
                        height: MediaQuery.of(context).size.height / 1.3,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                )),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    snippetsBlock.dispose();
    super.dispose();
  }
}

Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Loading List'),
    ),
  );
}
