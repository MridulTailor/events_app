import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Event {
  final int id;
  final String title;
  final String description;
  final String bannerImage;
  final String dateTime;
  final String organiserName;
  final String organiserIcon;
  final String venueName;
  final String venueCity;
  final String venueCountry;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.bannerImage,
    required this.dateTime,
    required this.organiserName,
    required this.organiserIcon,
    required this.venueName,
    required this.venueCity,
    required this.venueCountry,
  });
}

class EventProvider with ChangeNotifier {
  final Dio _dio = Dio();
  List<Event> _events = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  List<Event> get events {
    return [..._events];
  }

  List<Event> _searchResults = [];

  List<Event> get searchResults {
    return [..._searchResults];
  }

  bool get isLoading => _isLoading;

  bool get hasError => _hasError;

  String get errorMessage => _errorMessage;

  Future<void> fetchEvents() async {
    try {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
      notifyListeners();

      final response = await _dio.get(
        'https://sde-007.api.assignment.theinternetfolks.works/v1/event',
      );

      if (response.data['status']) {
        final List<Event> events = (response.data['content']['data'] as List)
            .map((eventData) => Event(
                  id: eventData['id'],
                  title: eventData['title'],
                  description: eventData['description'],
                  bannerImage: eventData['banner_image'],
                  dateTime: eventData['date_time'],
                  organiserName: eventData['organiser_name'],
                  organiserIcon: eventData['organiser_icon'],
                  venueName: eventData['venue_name'],
                  venueCity: eventData['venue_city'],
                  venueCountry: eventData['venue_country'],
                ))
            .toList();

        _events = events;
        notifyListeners();
      }
    } catch (error) {
      _hasError = true;
      _errorMessage = 'Error fetching events: $error';
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchEventDetail(int eventId) async {
    try {
      final response = await _dio.get(
        'https://sde-007.api.assignment.theinternetfolks.works/v1/event/$eventId',
      );

      if (response.data['status']) {
        final eventData = response.data['content']['data'];

        // Parse the response and update the state
        // Example: _eventDetail = parseEventDetail(eventData);
        // Make sure to call notifyListeners() after updating the detail.
      }
    } catch (error) {
      print('Error fetching event detail: $error');
    }
  }

  Future<void> searchEvents({String searchTerm = ""}) async {
    try {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
      notifyListeners();

      final response = await _dio.get(
        'https://sde-007.api.assignment.theinternetfolks.works/v1/event?search=$searchTerm',
      );

      if (response.data['status']) {
        final List<Event> searchResults =
            (response.data['content']['data'] as List)
                .map((eventData) => Event(
                      id: eventData['id'],
                      title: eventData['title'],
                      description: eventData['description'],
                      bannerImage: eventData['banner_image'],
                      dateTime: eventData['date_time'],
                      organiserName: eventData['organiser_name'],
                      organiserIcon: eventData['organiser_icon'],
                      venueName: eventData['venue_name'],
                      venueCity: eventData['venue_city'],
                      venueCountry: eventData['venue_country'],
                    ))
                .toList();

        _searchResults = searchResults;
        notifyListeners();
      }
    } catch (error) {
      _hasError = true;
      _errorMessage = 'Error searching events: $error';
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add methods to modify the state as needed
}
