class P2pFile < ApplicationRecord
  belongs_to :p2p
  belongs_to :user

  validates :file_name, presence: true
end