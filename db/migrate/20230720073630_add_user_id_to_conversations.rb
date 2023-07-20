class AddUserIdToConversations < ActiveRecord::Migration[7.0]
  def change
    add_column :conversations, :user_id, :integer
  end
end
