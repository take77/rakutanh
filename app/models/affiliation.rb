class Affiliation < ActiveRecord::Base
  has_many :users
  has_many :subjects
  has_many :exams
  has_many :reports
  has_many :notes
  validates :college, uniqueness:{scope: [:department, :course]}
  has_many :feed_contents, ->{ order("updated_at DESC") }
end
