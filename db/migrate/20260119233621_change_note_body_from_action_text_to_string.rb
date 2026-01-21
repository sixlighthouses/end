class ChangeNoteBodyFromActionTextToString < ActiveRecord::Migration[8.1]
  def up
    # Add body column to notes table
    add_column :notes, :body, :text

    # Migrate data from Action Text to the new body column
    execute <<-SQL
      UPDATE notes#{' '}
      SET body = (
        SELECT body#{' '}
        FROM action_text_rich_texts#{' '}
        WHERE action_text_rich_texts.record_type = 'Note'#{' '}
        AND action_text_rich_texts.record_id = notes.id#{' '}
        AND action_text_rich_texts.name = 'body'
        LIMIT 1
      )
    SQL

    # Remove Action Text rich texts for notes
    execute <<-SQL
      DELETE FROM action_text_rich_texts#{' '}
      WHERE record_type = 'Note' AND name = 'body'
    SQL
  end

  def down
    # Restore Action Text data if possible
    # Note: This is a simplified rollback - in production you might want to preserve the original data
    execute <<-SQL
      INSERT INTO action_text_rich_texts (record_type, record_id, name, body, created_at, updated_at)
      SELECT 'Note', id, 'body', body, created_at, updated_at
      FROM notes#{' '}
      WHERE body IS NOT NULL
    SQL

    # Remove the body column
    remove_column :notes, :body
  end
end
