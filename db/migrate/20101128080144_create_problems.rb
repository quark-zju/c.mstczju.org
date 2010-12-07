class CreateProblems < ActiveRecord::Migration
  def self.up
    create_table :problems do |t|
      t.string :title, :null => false
      t.string :source

      t.integer :memory_limit, :null => false
      t.integer :time_limit, :null => false
      
      # cached values
      t.integer :accept_count
      t.integer :submit_count

      t.timestamps
    end
    add_index :problems, :source
    add_index :problems, :title
  end

  def self.down
    drop_table :problems
  end
end
