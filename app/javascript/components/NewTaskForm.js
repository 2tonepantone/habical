import React, { useState } from "react"

export default function NewTaskForm(props) {
  const [formData, setFormData] = useState(
    {
      "task[title]": "",
      "task[duration]": 10
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
    // event.preventDefault()
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
          <label htmlFor="duration">Duration:</label>
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
        <input type="submit" name="commit" value="Create Task" data-disable-with="Create Task" className="btn btn-outline-primary"/>
      </form>
  )
}
