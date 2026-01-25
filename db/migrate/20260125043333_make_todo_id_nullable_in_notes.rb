class MakeTodoIdNullableInNotes < ActiveRecord::Migration[8.1]
  def change
    change_column_null :notes, :todo_id, true
  end
end
