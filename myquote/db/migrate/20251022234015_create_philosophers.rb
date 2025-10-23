class CreatePhilosophers < ActiveRecord::Migration[8.0]
  def change
    create_table :philosophers do |t|
      t.string :first_name
      t.string :last_name
      t.integer :birth_year
      t.integer :death_year
      t.text :biography

      t.timestamps
    end
  end
end
