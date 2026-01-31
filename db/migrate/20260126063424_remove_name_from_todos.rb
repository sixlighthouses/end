class RemoveNameFromTodos < ActiveRecord::Migration[8.1]
  def change
    remove_column :todos, :name, :string
    add_column :todos, :completed, :boolean, default: false, null: false
  end
end
