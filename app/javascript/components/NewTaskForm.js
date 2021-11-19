import React, { useState } from "react"

export default function NewTaskForm(props) {
  const [formData, setFormData] = useState(
    {
      taskName: "",
      duration: 10,
      weeklyFrequency: 1
    }
  )

  function handleChange(event) {
    const { name, value } = event.target
    setFormData(prevFormData => {
      return {
        ...prevFormData,
        [name]: value
      }
    })
  }

  function handleSubmit(event) {
    event.preventDefault()
    console.log(formData)
  }

  return (
      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label htmlFor="taskName">Task Name:</label>
          <input
            type="text"
            placeholder="Do yoga"
            onChange={handleChange}
            name="taskName"
            value={formData.taskName}
            className="form-control"
          />
        </div>
        <div className="form-group">
          <label htmlFor="duration">Duration:</label>
          <input
            type="number"
            placeholder="10"
            onChange={handleChange}
            name="duration"
            step="5"
            min="5"
            max="180"
            value={formData.duration}
            className="form-control"
          />
        </div>
        <div className="form-group">
          <label htmlFor="weeklyFrequency">Weekly Frequency:</label>
          <select
            id="weeklyFrequency"
            value={formData.weeklyFrequency}
            onChange={handleChange}
            name="weeklyFrequency"
            className="form-control"
          >
            <option value="1">1</option>
            <option value="2">2</option>
            <option value="3">3</option>
            <option value="4">4</option>
            <option value="5">5</option>
            <option value="6">6</option>
            <option value="7">7</option>
          </select>
        </div>
        <input type='hidden' name="authenticity_token" value={props.authenticityToken} />
        <button>Submit</button>
      </form>
  )
}
