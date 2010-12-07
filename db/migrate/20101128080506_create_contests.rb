class CreateContests < ActiveRecord::Migration
  def self.up
    create_table :contests do |t|
      t.string :name
      t.datetime :start_time
      t.datetime :freeze_time
      t.datetime :end_time

      t.string :visible_group
      t.string :moderate_group

      t.timestamps
    end
    add_index :contests, :name
    add_index :contests, :visible_group
    add_index :contests, :start_time
    add_index :contests, :moderate_group
  end

  def self.down
    drop_table :contests
  end
end
