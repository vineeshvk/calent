import 'package:device_calendar/device_calendar.dart';

DeviceCalendarPlugin deviceCalendar = new DeviceCalendarPlugin();
final String calendarId = "1";
final String eventId = "_cale_nt_";

Future<List<Event>> getCalendarEvents() async {
  Result<List<Event>> allEvents = await deviceCalendar.retrieveEvents(
    calendarId,
    RetrieveEventsParams(
        startDate: DateTime(DateTime.now().year), endDate: DateTime(2020)),
  );
  return allEvents.data;
}

Future addCalendarEvents(
    {String title,
    String description,
    DateTime startDate,
    DateTime endDate}) async {
  Result<String> response = await deviceCalendar.createOrUpdateEvent(Event(
    calendarId,
    eventId: eventId,
    title: title,
    description: description ?? '',
    start: startDate ?? DateTime.now(),
    end: endDate ?? startDate,
  ));
  return response.data;
}

Future deleteCaldendarEvents(_eventId) async{
  Result<bool> del =  await deviceCalendar.deleteEvent(calendarId,_eventId );
  return del;
}