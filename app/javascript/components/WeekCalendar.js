import React, { useState, useEffect } from "react"
import FullCalendar from "@fullcalendar/react";
import dayGridPlugin from "@fullcalendar/daygrid";

const WeekCalendar = (props) =>  {
  const SCOPES = "https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/calendar.readonly https://www.googleapis.com/auth/calendar.events https://www.googleapis.com/auth/calendar";
  const CLIENT_ID = props.clientId
  const API_KEY = props.apiKey
  const TIME_MIN = getLastSundayMidnight(new Date())

  const [events, setEvents] = useState(null);

  useEffect(() => {
    const script = document.createElement("script");
    script.async = true;
    script.defer = true;
    script.src = "https://apis.google.com/js/api.js";

    document.body.appendChild(script);

    script.addEventListener("load", () => {
      if (window.gapi) handleClientLoad();
    });
  }, []);

  const handleClientLoad = () => {
    window.gapi.load("client:auth2", initClient);
  };

  const openSignInPopup = () => {
    window.gapi.auth2.authorize(
      { client_id: CLIENT_ID, scope: SCOPES },
      (res) => {
        if (res) {
          if (res.access_token)
            localStorage.setItem("access_token", res.access_token);

          // Load calendar events after authentication
          window.gapi.client.load("calendar", "v3", listUpcomingEvents);
        }
      }
    );
  }

  const initClient = () => {
    if (!localStorage.getItem("access_token")) {
      openSignInPopup();
    } else {
      // Get events if access token is found without sign in popup
      fetch(
        `https://www.googleapis.com/calendar/v3/calendars/primary/events?
        key=${API_KEY}&orderBy=startTime&singleEvents=true&timeMin=${TIME_MIN}`,
        {
          headers: {
            Authorization: `Bearer ${localStorage.getItem("access_token")}`,
          },
        }
      )
        .then((res) => {
          // Check if unauthorized status code is return open sign in popup
          if (res.status !== 401) {
            return res.json();
          } else {
            localStorage.removeItem("access_token");

            openSignInPopup();
          }
        })
        .then((data) => {
          if (data?.items) {
            setEvents(formatEvents(data.items));
          }
        });
    }
  };

  function getLastSundayMidnight(today) {
    today.setDate(today.getDate() - today.getDay());
    return new Date(today.setHours(0, 0, 0, 0)).toISOString();
  }

  const listUpcomingEvents = () => {
    console.log("hello from listUpcomingEvents");
    window.gapi.client.calendar.events
      .list({
        // Fetch events from user's primary calendar
        calendarId: 'primary',
        timeMin: TIME_MIN,
        showDeleted: false,
        singleEvents: true,
        orderBy: 'startTime'
      })
      .then(function (response) {
        let events = response.result.items;

        if (events.length > 0) {
          setEvents(formatEvents(events));
        }
      });
  };

  const formatEvents = (list) => {
    return list.map((item) => ({
      title: item.summary,
      start: item.start.dateTime || item.start.date,
      end: item.end.dateTime || item.end.date,
    }));
  };

  return (
    console.log(events),
    <div
      style={{
        width: "90%",
        paddingTop: "50px",
        paddingBottom: "50px",
        margin: "auto",
        maxWidth: "1200px"
      }}
    >
      <FullCalendar
        plugins={[dayGridPlugin]}
        initialView="dayGridWeek"
        events={events}
      />
    </div>
  );
}

export default WeekCalendar
