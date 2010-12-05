class CreateContests < ActiveRecord::Migration
  def self.up
    create_table :contests do |t|
      t.string :name
      t.datetime :start_time
      t.datetime :end_time
      t.string :visible_group
      t.string :moderate_group
      t.string :author_group
      t.string :path

      t.timestamps
    end
  end

  def self.down
    drop_table :contests
  end
end
