class AddTimezoneToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :timezone, :string
  end
end
