class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :inviter_id
      t.string :invitee_name
      t.string :invitee_email
      t.string :message
      t.string :token
      t.timestamps
    end
  end
end
