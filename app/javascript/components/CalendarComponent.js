import React from "react";
import Calendar from "@ericz1803/react-google-calendar";

const CalendarComponent = (props) => (
    <div className="Calendar">
        <div
          style={{
            width: "90%",
            paddingTop: "50px",
            paddingBottom: "50px",
            margin: "auto",
            maxWidth: "1200px"
          }}
        >
          <Calendar apiKey={props.apiKey} calendars={[props.calendars]} />
        </div>
    </div>
  )

export default CalendarComponent
