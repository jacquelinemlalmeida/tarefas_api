class Task < ApplicationRecord
  STATUSES = %w[em_andamento em_atraso concluida cancelada]

  validates :title, presence: true
  validates :status, inclusion: { in: STATUSES }

  scope :filter_by_status, ->(status) { where(status: status) if status.present? }
  scope :filter_by_title, ->(title) { where('title ILIKE ?', "%#{title}%") if title.present? }
  scope :filter_by_description, ->(description) { where('description ILIKE ?', "%#{description}%") if description.present? }
  scope :filter_by_created_at, ->(date) { where(created_at: Date.parse(date).all_day) if date.present? }
  scope :filter_by_due_date, ->(date) { where(due_date: Date.parse(date)) if date.present? }
end
