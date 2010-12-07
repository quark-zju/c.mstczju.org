class CreateSubmissions < ActiveRecord::Migration
  def self.up
    create_table :submissions do |t|
      t.integer :problem_id
      t.integer :user_id
      t.integer :result
      t.integer :used_memory
      t.integer :used_time
      t.string :lang
      t.string :visible_group

      t.timestamps
    end
    add_index :submissions, :problem_id
    add_index :submissions, :user_id
    add_index :submissions, :result
    add_index :submissions, :lang
    add_index :submissions, :created_at
    add_index :submissions, :visible_group
  end

  def self.down
    drop_table :submissions
  end
end
