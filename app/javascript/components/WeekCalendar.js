import React, { useState, useEffect } from "react"
import FullCalendar from "@fullcalendar/react";
import dayGridPlugin from "@fullcalendar/daygrid";

const WeekCalendar = ({ events }) =>  {
  const [formattedEvents, setFormattedEvents] = useState(null);

  const formatEvents = (events) => {
    return events.map((event) => ({
      title: event.summary,
      start: event.start.date_time || event.start.date,
      end: event.end.date_time || event.end.date,
    }));
  };

  useEffect(() => {
    setFormattedEvents(formatEvents(events))
  }, [])

  return (
    console.log("WeekCalendarComponent Fevents", formattedEvents),
    console.log("WeekCalendarComponent events", events),
    <FullCalendar
      plugins={[dayGridPlugin]}
      initialView="dayGridWeek"
      events={formattedEvents}
    />
  );
}

export default WeekCalendar
