class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :nick
      t.string :group
      t.string :email
      t.datetime :last_login
      t.string :signature

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
