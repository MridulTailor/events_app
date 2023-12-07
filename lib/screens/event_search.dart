import 'package:events_app/constants.dart';
import 'package:events_app/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventSearchScreen extends StatefulWidget {
  const EventSearchScreen({super.key});

  @override
  State<EventSearchScreen> createState() => _EventSearchScreenState();
}

class _EventSearchScreenState extends State<EventSearchScreen> {
  @override
  void initState() {
    super.initState();

    // Call searchEvents with an empty search term
    Provider.of<EventProvider>(context, listen: false)
        .searchEvents(searchTerm: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back)),
        title: const Text('Search',
            style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w500)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    child: SvgPicture.asset('assets/icon/search 2.svg',
                        semanticsLabel: 'Acme Logo'),
                  ),
                ),
                const SizedBox(
                  height: 24, // Adjust the height of the container as needed
                  child: VerticalDivider(
                    color: Colors.black, // Set the color of the vertical rule
                    thickness: 1, // Set the thickness of the vertical rule
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: TextField(
                    onChanged: (searchTerm) {
                      Provider.of<EventProvider>(context, listen: false)
                          .searchEvents(searchTerm: searchTerm);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Type Event Name',
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                        color: Constants.greyTextColor2,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Consumer<EventProvider>(
                builder: (context, eventProvider, child) {
                  if (eventProvider.searchResults.isEmpty) {
                    return const Center(
                      child: Text('No events found.'),
                    );
                  } else {
                    return ListView.separated(
                      itemCount: eventProvider.searchResults.length,
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 20,
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/event_detail',
                              arguments: eventProvider.searchResults[index].id,
                            );
                          },
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
                                      onError: (exception, stackTrace) =>
                                          const Center(
                                              child:
                                                  Icon(Icons.error, size: 30)),
                                      image: NetworkImage(
                                        eventProvider
                                            .searchResults[index].bannerImage,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                SizedBox(
                                  height: 107,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          eventProvider
                                              .searchResults[index].title,
                                          softWrap: true,
                                          maxLines: 3,
                                          style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
