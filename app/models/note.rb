class Note < ActiveRecord::Base

  belongs_to :user
  belongs_to :subject
  belongs_to :affiliation
  has_many :note_comments
  has_many :note_items, dependent: :destroy
  has_one :feed_content, as: :content, dependent: :destroy
  accepts_nested_attributes_for :note_items, allow_destroy: true
  after_create :create_feed_content

  private
    def create_feed_content
      self.feed_content = FeedContent.create(affiliation_id: affiliation_id, subject_id: subject_id, user_id: user_id, updated_at: updated_at)
    end
end
