import moment from "moment"

const sampleEvents =  [
  {
    title: "Japanese Class",
    start: moment().subtract(1, 'days').add(2, 'hours').format(),
    end: moment().subtract(1, 'days').add(3, 'hours').format(),
  },
  {
    title: "Meetup w/ Ryan",
    start: moment().add(4, 'days').subtract(2, 'hours').format(),
    end: moment().add(4, 'days').add(1, 'hours').format(),
  },
  {
    title: "Jill's Birthday",
    start: moment().add(8, 'days').add(2, 'hours').format(),
    end: moment().add(8, 'days').add(5, 'hours').format(),
  },
  {
    title: "Family Video Chat",
    start: moment().subtract(4, 'days').add(2, 'hours').format(),
    end: moment().subtract(4, 'days').add(3, 'hours').format(),
  },
  {
    title: "Water Plants",
    start: moment().subtract(2, 'days').add(1, 'hours').format(),
    end: moment().subtract(2, 'days').add(2, 'hours').format(),
  },
  {
    title: "Shelby's Birthday Party",
    start: moment().add(2, 'days').add(3, 'hours').format(),
    end: moment().add(2, 'days').add(5, 'hours').format(),
  },
  {
    title: "Car Service Appt",
    start: moment().add(14, 'days').subtract(1, 'hours').format(),
    end: moment().add(14, 'days').add(4, 'hours').format(),
  },
  {
    title: "Trash Day",
    start: moment().add(6, 'days').subtract(7, 'hours').format(),
    end: moment().add(6, 'days').subtract(6, 'hours').format(),
  },
  {
    title: "Chat w/ Marle",
    start: moment().add(7, 'days').add(1, 'hours').format(),
    end: moment().add(7, 'days').add(2, 'hours').format(),
  },
  {
    title: "Amazon Delivery",
    start: moment().add(2, 'hours').format(),
    end: moment().add(3, 'hours').format(),
  },
  {
    title: "Gym Time",
    start: moment().add(10, 'days').add(2, 'hours').format(),
    end: moment().add(10, 'days').add(4, 'hours').format(),
  },
  {
    title: "Doctor's Appt",
    start: moment().subtract(3, 'days').add(3, 'hours').format(),
    end: moment().subtract(3, 'days').add(4, 'hours').format(),
  },
  {
    title: "Piano Class",
    start: moment().subtract(8, 'days').add(2, 'hours').format(),
    end: moment().subtract(8, 'days').add(3, 'hours').format(),
  },
  {
    title: "Meetup w/ Terri",
    start: moment().add(11, 'days').subtract(2, 'hours').format(),
    end: moment().add(11, 'days').add(1, 'hours').format(),
  },
  {
    title: "My Birthday Party!",
    start: moment().add(19, 'days').add(2, 'hours').format(),
    end: moment().add(19, 'days').add(5, 'hours').format(),
  },
  {
    title: "Game Day",
    start: moment().subtract(11, 'days').add(2, 'hours').format(),
    end: moment().subtract(11, 'days').add(3, 'hours').format(),
  },
  {
    title: "Cat Sitting",
    start: moment().subtract(12, 'days').add(2, 'hours').format(),
    end: moment().subtract(12, 'days').add(3, 'hours').format(),
  },
  {
    title: "Kickback",
    start: moment().add(16, 'days').subtract(2, 'hours').format(),
    end: moment().add(16, 'days').add(2, 'hours').format(),
  },
  {
    title: "Dentist",
    start: moment().add(25, 'days').add(2, 'hours').format(),
    end: moment().add(25, 'days').add(3, 'hours').format(),
  },
  {
    title: "Clean House",
    start: moment().add(20, 'days').add(2, 'hours').format(),
    end: moment().add(20, 'days').add(3, 'hours').format(),
  },
]

export default sampleEvents
