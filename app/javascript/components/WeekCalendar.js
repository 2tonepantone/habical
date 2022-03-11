import React, { useState, useEffect } from 'react'
import FullCalendar from '@fullcalendar/react'
import dayGridPlugin from '@fullcalendar/daygrid'
import listPlugin from '@fullcalendar/list'
import bootstrap5Plugin from '@fullcalendar/bootstrap5'
import timeGridPlugin from '@fullcalendar/timegrid'
import 'bootstrap-icons/font/bootstrap-icons.css'
import sampleEvents from '../../assets/data/sampleEvents'

const WeekCalendar = ({ events, user_present }) =>  {
  const [formattedEvents, setFormattedEvents] = useState(null)

  const formatEvents = (events) => {
    return events.map((event) => ({
      title: event.summary || event.title,
      start: event.start.date_time || event.start,
      end: event.end.date_time || event.end,
    }))
  }

  useEffect(() => {
    setFormattedEvents(formatEvents(user_present ? events : sampleEvents))
  }, [])

  return (
    <FullCalendar
      plugins={[dayGridPlugin, listPlugin, bootstrap5Plugin]}
      initialView='listWeek'
      headerToolbar={{
        left: 'prev,next today',
        center: 'title',
        right: 'dayGridMonth,listWeek,listDay'
      }}
      buttonText={{
        today: 'Today',
        dayGridMonth: 'Month',
        listWeek: 'Week',
        listDay: 'Day'
      }}
      navLinks='true'
      themeSystem='bootstrap5'
      events={formattedEvents}
    />
  )
}

export default WeekCalendar
