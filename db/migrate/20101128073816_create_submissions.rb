class CreateSubmissions < ActiveRecord::Migration
  def self.up
    create_table :submissions do |t|
      t.integer :problem_id
      t.integer :user_id
      t.integer :result
      t.datetime :time
      t.integer :used_memory
      t.integer :used_time
      t.string :lang
      t.string :visible_group
      t.string :path

      t.timestamps
    end
  end

  def self.down
    drop_table :submissions
  end
end
