class AddCompletedToTodos < ActiveRecord::Migration[8.1]
  def change
    add_column :todos, :completed, :boolean
  end
end
