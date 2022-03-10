import React, { useState } from "react"

export default function NewTaskForm(props) {
  const [formData, setFormData] = useState(
    {
      "task[title]": "",
      "task[duration]": 10,
      "task[frequency]": 1,
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
    console.log(formData)
  }

  return (
      <form onSubmit={handleSubmit}
        role='form'
        acceptCharset="UTF-8"
        action="/tasks"
        method="post"
      >
        <input type='hidden' name="authenticity_token" value={props.authenticityToken}/>
        <h1 className="fw-light">Add a new task to your calendar</h1>
        <div className="form-group">
          <label htmlFor="task_title">Task Name:</label>
          <input
            type="text"
            placeholder="Do yoga"
            onChange={handleChange}
            name="task[title]"
            id="task_title"
            value={formData["task[title]"]}
            className="form-control"
            required
          />
        </div>
        <div className="form-group">
          <label htmlFor="task_duration">Duration (minutes):</label>
          <input
            type="number"
            placeholder="10"
            onChange={handleChange}
            name="task[duration]"
            id="task_duration"
            step="5"
            min="5"
            max="180"
            value={formData["task[duration]"]}
            className="form-control"
            required
          />
        </div>
        <div className="form-group">
          <label htmlFor="task_frequency">Frequency (next seven days):</label>
          <select
            onChange={handleChange}
            name="task[frequency]"
            id="task_frequency"
            value={formData["task[frequency]"]}
            className="form-control"
            required
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
        <input type="submit" name="commit" value="Create Task" data-disable-with="Create Task" className="btn btn-outline-primary"/>
      </form>
  )
}
