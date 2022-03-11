import moment from "moment"

const sampleEvents =  [
  {
    title: "Festival in HH",
    start: moment().add(1, 'days').format(),
    end: moment().add(4, 'days').add(3, 'hours').format(),
  },
  {
    title: "Party in HH",
    start: moment().subtract(2, 'days').format(),
    end: moment().subtract(2, 'days').add(3, 'hours').format(),
  },
  {
    title: "Party in SH",
    start: moment().format(),
    end: moment().add(3, 'hours').format(),
  },
  {
    title: "Concert in SH",
    start: moment().add(1, 'days').format(),
    end: moment().add(1, 'days').add(3, 'hours').format(),
  },
  {
    title: "Concert in HH",
    start: moment().subtract(3, 'days').format(),
    end: moment().subtract(3, 'days').add(3, 'hours').format(),
  },
  {
    title: "#1 Background title",
    start: moment().subtract(6, 'days').format('YYYY-MM-DD'),
    end: moment().subtract(2, 'days').format('YYYY-MM-DD'),
  },
  {
    title: "#2 title",
    start: moment().subtract(8, 'days').format('YYYY-MM-DD'),
    end: moment().subtract(8, 'days').format('YYYY-MM-DD'),
  },
  {
    title: "#3 Overlap",
    start: moment().subtract(8, 'days').format('YYYY-MM-DD'),
    end: moment().subtract(8, 'days').format('YYYY-MM-DD'),
  }
]

export default sampleEvents
