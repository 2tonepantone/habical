import React from "react";
import Calendar from "@ericz1803/react-google-calendar";

//put your google calendar api key here
const API_KEY = "";

//replace calendar id with one you want to test

let calendars = [
  { calendarId: "09opmkrjova8h5k5k46fedmo88@group.calendar.google.com" }
];

export default function CalendarComponent() {
  return (
    <div className="Calendar">
      <body>
        <div
          style={{
            width: "90%",
            paddingTop: "50px",
            paddingBottom: "50px",
            margin: "auto",
            maxWidth: "1200px"
          }}
        >
          <Calendar apiKey={API_KEY} calendars={calendars} />
        </div>
      </body>
    </div>
  );
}
