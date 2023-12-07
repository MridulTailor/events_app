import 'package:events_app/constants.dart';
import 'package:events_app/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _isInit = false;

      // Use a Future to perform the async operation
      Future.delayed(Duration.zero, () {
        Provider.of<EventProvider>(context, listen: false).fetchEvents();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);

    // Fetch events only once when the screen is initialized
    if (_isInit) {
      _isInit = false;
      eventProvider.fetchEvents();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Events',
            style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w500)),
        actions: [
          //asset image
          GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/event_search');
              },
              child: SvgPicture.asset('assets/icon/search.svg',
                  semanticsLabel: 'Acme Logo')),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<EventProvider>(
        builder: (context, eventProvider, child) {
          if (eventProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (eventProvider.hasError) {
            return Center(child: Text('Error: ${eventProvider.errorMessage}'));
          } else {
            return Container(
              margin: const EdgeInsets.only(top: 20),
              child: ListView.separated(
                itemCount: eventProvider.events.length,
                separatorBuilder: (context, index) => const SizedBox(
                  height: 12,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/event_detail',
                        arguments: eventProvider.events[index].id,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x0F575C8A),
                              blurRadius: 35,
                              offset: Offset(0, 10),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 107,
                              height: 107,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(16),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    eventProvider.events[index].bannerImage,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            SizedBox(
                              height: 107,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    DateFormat('E, MMM d • h:mm a').format(
                                        DateTime.parse(eventProvider
                                            .events[index].dateTime)),
                                    style: const TextStyle(
                                        color: Constants.blueTextColor,
                                        fontSize: 15),
                                  ),
                                  SizedBox(
                                    width: 193,
                                    child: Text(
                                      eventProvider.events[index].title,
                                      softWrap: true,
                                      maxLines: 2,
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.black,
                                          fontSize: 18),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icon/map-pin.svg',
                                        semanticsLabel: 'Acme Logo',
                                      ),
                                      const SizedBox(width: 5),
                                      SizedBox(
                                        width: 200,
                                        child: Text(
                                          '${eventProvider.events[index].venueName} • ${eventProvider.events[index].venueCity}, ${eventProvider.events[index].venueCountry}',
                                          softWrap: true,
                                          maxLines: 1,
                                          style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              color: Constants.greyTextColor,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );

                  // ListTile(
                  //   title: Text(
                  //     eventProvider.events[index].title,
                  //     style: TextStyle(color: Colors.black),
                  //   ),
                  //   onTap: () {
                  //     Navigator.pushNamed(
                  //       context,
                  //       Constants.eventDetailsRoute,
                  //       arguments: eventProvider.events[index].id,
                  //     );
                  //   },
                  // );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
