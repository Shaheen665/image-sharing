class AddAttachmentDataToPersonalMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :personal_messages, :attachment_data, :text
  end
end
