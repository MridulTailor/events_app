import 'package:events_app/constants.dart';
import 'package:events_app/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final eventId = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          height: 80,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(255, 255, 255, 0.07999999821186066),
                offset: Offset(0, -2),
                blurRadius: 10,
              ),
            ],
          ),
          child: Stack(
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: Constants.blueButtonColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text('BOOK NOW',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  )),
              Positioned(
                right: 15,
                top: 12,
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: SvgPicture.asset(
                    'assets/icon/Group 4.svg',
                    semanticsLabel: 'Acme Logo',
                  ),
                ),
              ),
            ],
          )),
      body: SafeArea(
        child: FutureBuilder(
          future: Provider.of<EventProvider>(context).fetchEventDetail(eventId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final event = Provider.of<EventProvider>(context)
                  .events
                  .firstWhere((event) => event.id == eventId);

              // Display event details based on the snapshot data
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Image.network(
                          event.bannerImage,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(child: Icon(Icons.error, size: 30)),
                          width: double.infinity,
                          height: 244,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          child: Container(
                            color: Colors.black.withOpacity(0.3),
                            width: MediaQuery.of(context).size.width,
                            height: 244,
                          ),
                        ),
                        Positioned(
                          top: 25,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    size: 25,
                                  ),
                                  color: Colors.white,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                const Text(
                                  'Event Details',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: ShapeDecoration(
                                    color: Colors.white
                                        .withOpacity(0.30000001192092896),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.bookmark,
                                      size: 20,
                                    ),
                                    color: Colors.white,
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: const TextStyle(
                                fontSize: 40, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Image.network(
                                event.organiserIcon,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Center(
                                        child: Icon(Icons.error, size: 30)),
                                height: 50,
                                width: 50,
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.organiserName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Organizer',
                                    style: TextStyle(
                                      color: Constants.greyTextColor2,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Stack(
                                children: [
                                  Opacity(
                                    opacity: 0.10,
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFF5668FF),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 10,
                                    top: 10,
                                    child: SvgPicture.asset(
                                      'assets/icon/Calendar.svg',
                                      semanticsLabel: 'Acme Logo',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat('dd MMMM, yyyy').format(
                                      DateTime.parse(event.dateTime),
                                    ),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "${DateFormat('EEEE, hh:mm a').format(DateTime.parse(event.dateTime))} - ${DateFormat('h:mm a').format(DateTime.parse(event.dateTime).add(const Duration(hours: 5)))}",
                                    style: const TextStyle(
                                      color: Constants.greyTextColor2,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Stack(
                                children: [
                                  Opacity(
                                    opacity: 0.10,
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFF5668FF),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 10,
                                    top: 10,
                                    child: SvgPicture.asset(
                                      'assets/icon/Location.svg',
                                      semanticsLabel: 'Acme Logo',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.venueName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${event.venueCity}, ${event.venueCountry}',
                                    style: const TextStyle(
                                      color: Constants.greyTextColor2,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          const Text(
                            "About Event",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            event.description,
                            style: const TextStyle(height: 1.5, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
