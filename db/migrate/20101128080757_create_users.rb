class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :nick
      t.string :group
      t.string :email
      t.string :salt
      t.string :encrypted_password
      t.string :signature

      t.timestamps
    end
    add_index :users, :nick
    add_index :users, :email
    add_index :users, :name

  end

  def self.down
    drop_table :users
  end
end
