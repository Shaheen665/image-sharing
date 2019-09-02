class PersonalMessage < ApplicationRecord
  include AttachmentUploader[:attachment]

  belongs_to :conversation
  belongs_to :user
  validates :body, presence: true, unless: :attachment_data

  def attachment_name=(name)
    @attachment_name = name
  end

  def attachment_name
    @attachment_name
  end

  def receiver
    if conversation.author == conversation.receiver || conversation.receiver == user
      conversation.author
    else
      conversation.receiver
    end
  end


  after_create_commit do
    conversation.touch
    NotificationsBroadcastJob.perform_later(self)
  end

end


