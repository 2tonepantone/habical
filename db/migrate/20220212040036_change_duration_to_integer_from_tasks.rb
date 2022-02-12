class ChangeDurationToIntegerFromTasks < ActiveRecord::Migration[6.1]
  def change
    change_table :tasks do |table|
      table.change :duration, :integer
    end
  end
end
