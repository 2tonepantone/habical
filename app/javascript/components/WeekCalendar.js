import React, { useState, useEffect } from 'react'
import FullCalendar from '@fullcalendar/react'
import dayGridPlugin from '@fullcalendar/daygrid'
import listPlugin from '@fullcalendar/list'
import bootstrap5Plugin from '@fullcalendar/bootstrap5'
import timeGridPlugin from '@fullcalendar/timegrid'
import 'bootstrap-icons/font/bootstrap-icons.css'
import sampleEvents from '../../assets/data/sampleEvents'

const WeekCalendar = ({ events, sample }) =>  {
  const [formattedEvents, setFormattedEvents] = useState(null)

  const formatEvents = (events) => {
    return events.map((event) => ({
      title: event.summary || event.title,
      start: event.start.date_time || event.start,
      end: event.end.date_time || event.end,
    }))
  }

  useEffect(() => {
    setFormattedEvents(formatEvents(sample ? sampleEvents : events))
  }, [])

  return (
    <FullCalendar
      plugins={[dayGridPlugin, timeGridPlugin, listPlugin, bootstrap5Plugin]}
      initialView={sample ? 'dayGridMonth' : 'listWeek'}
      headerToolbar={{
        left: 'prev,next today',
        center: 'title',
        right: 'dayGridMonth,timeGridWeek,listWeek,listDay'
      }}
      buttonText={{
        today: 'Today',
        dayGridMonth: 'Month',
        timeGridWeek: 'Week',
        listWeek: 'Week List',
        listDay: 'Day List'
      }}
      navLinks='true'
      slotDuration='00:10'
      slotMinTime='09:00'
      slotMaxTime='21:00'
      allDaySlot={false}
      nowIndicator='true'
      themeSystem='bootstrap5'
      events={formattedEvents}
    />
  )
}

export default WeekCalendar
