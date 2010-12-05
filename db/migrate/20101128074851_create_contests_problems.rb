class CreateContestsProblems < ActiveRecord::Migration
  def self.up
    create_table :contests_problems, :id => false do |t|
      t.integer :contest_id, :null => false
      t.integer :problem_id, :null => false
    end

    add_index :contests_problems, [:contest_id, :problem_id], :unique => true
  end

  def self.down
    remove_index :contests_problems, :column => [:contest_id, :problem_id]
    drop_table :contests_problems
  end
end
