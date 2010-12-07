class CreateProblemLinks < ActiveRecord::Migration
  def self.up
    create_table :problem_links do |t|
      t.integer :contest_id
      t.integer :problem_id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :problem_links
  end
end
