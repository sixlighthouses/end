class AddPositionToTodos < ActiveRecord::Migration[8.1]
  def change
    add_column :todos, :position, :integer
  end
end
