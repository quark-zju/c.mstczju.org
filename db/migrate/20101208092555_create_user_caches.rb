class CreateUserCaches < ActiveRecord::Migration
  def self.up
    create_table :user_caches do |t|
      t.integer :problem_id
      t.integer :user_id
      t.datetime :first_accepted_time
      t.integer :attempt

      t.timestamps
    end
    add_index :user_caches, :problem_id
    add_index :user_caches, :user_id
    add_index :user_caches, [ :user_id, :problem_id ]
    add_index :user_caches, :attempt
    add_index :user_caches, :first_accepted_time
  end

  def self.down
    drop_table :user_caches
  end
end
