class Folder < ApplicationRecord
  belongs_to :organization
  has_many :video_folders
  validates :name, presence: true, uniqueness: { scope: :organization }

  def create(current_user)
    self.organization_id = current_user.organization_id
    self.save
  end
end
