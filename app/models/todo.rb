class Todo < ApplicationRecord
  has_many :notes, dependent: :destroy

  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :due_date, comparison: { greater_than_or_equal_to: Date.current, message: "can't be in the past" }, allow_nil: true
  scope :completed, -> { where(completed: true) }
  scope :incomplete, -> { where(completed: false) }

  # Add methods
  def mark_completed!
    update!(completed: true)
  end

  def mark_incomplete!
    update!(completed: false)
  end

  def completed?
    completed
  end

  def due_soon?
    due_date.present? && due_date <= Date.current + 3.days && due_date >= Date.current
  end

  def overdue?
    due_date.present? && due_date < Date.current
  end
end
