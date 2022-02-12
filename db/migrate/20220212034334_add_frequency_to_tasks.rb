class AddFrequencyToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :frequency, :integer
  end
end
